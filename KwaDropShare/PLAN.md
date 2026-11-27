# KwaDropShare — implementation plan

Status: **planned, not started** (Nov 2026). This folder exists only to hold the plan.

Share observed loot/droprate samples between Kwa users over addon messages, merge them
locally, and eventually fold anonymised samples into a shipped snapshot. The plugin is
the networking/merge layer; **KwaKillCounter already does the sampling**.

## Why this is possible

Addon-to-addon communication is plain chat traffic with an addon-only prefix:

```lua
C_ChatInfo.RegisterAddonMessagePrefix("KWADROP")
C_ChatInfo.SendAddonMessage("KWADROP", text, "PARTY")          -- PARTY/RAID/GUILD/INSTANCE_CHAT/WHISPER
C_ChatInfo.SendAddonMessage("KWADROP", text, "WHISPER", name)
-- receive: frame:RegisterEvent("CHAT_MSG_ADDON")
--          prefix, text, chatType, sender, target, zoneChannelID, localID, name, instanceID
```

Nothing is authenticated; sender is just the name the chat system reports. Treat all
remote data as untrusted samples.

Working precedents in the local client:

| Addon | What it proves |
| --- | --- |
| `BagBrother/libs/StaleCheck-1.0` | Version broadcast (`addon\|version`) over PARTY/RAID/GUILD, once a minute. This is the Bagnon "your version is outdated" popup. |
| `ProfPlanner/Sync.lua` | Full data sharing on Forever: whisper gossip, address books, digests, chunking, compression, validation, throttling. |
| `Details/core/network.lua` | Multiple prefixes + built-in `C_EncodingUtil.SerializeCBOR` / `DeserializeCBOR`. |
| `Auctionator/Source/Initialize/Main.lua` | Prefix registration + `CHAT_MSG_ADDON` stub. |

## Existing data we reuse

`KwaKillCounter/KwaCore.lua` already stores, per NPC (SavedVariables `MyKillCountTable`):

```lua
MyKillCountTable[npcID] = {
    name = "Defias Pillager",
    race = "Humanoid",
    count = 120,                 -- kills seen
    looted = 96,                 -- corpses looted (denominator)
    items = { [2589] = 41 },     -- times this item dropped
    itemCounts = { [2589] = 73 },-- total quantity
    coin = 1234,
    totalVendorValue = 0,
    xp = 0,
}
```

Drop rate = `items[itemID] / looted`. Sampling already works on Forever without CLEU:
`UNIT_DIED`, `LOOT_OPENED`, `LOOT_READY`, `CHAT_MSG_MONEY`, `CHAT_MSG_COMBAT_XP_GAIN`.
`LOOT_OPENED` is confirmed working in RareScanner on this client.

## Goals

1. Show, per NPC and item: your own rate, the community rate, and how many independent
   contributors back it.
2. Share only deltas/new data, in the background, with minimal chat traffic.
3. Persist merged data across sessions and reloads.
4. Never send in combat or instances; never block the UI.
5. Provide a plain-text export so samples can be merged offline into a shipped table.

## Non-goals

- Real-time sync, global reach, cross-faction, or arbitrary-player messaging.
- Authentication or anti-cheat (impossible over addon messages).
- Automatic loot/money decisions based on shared data.
- Replacing KwaKillCounter's tracking or UI.

## Reach and constraints on Forever

Learned from ProfPlanner's implementation:

- Custom chat channels are refused by Forever; use whisper + PARTY/RAID/GUILD/INSTANCE_CHAT.
- Forever character names include a surname ("Tillie Lumenwick"). Use
  `GetUnitName(unit, true)` and `Ambiguate(sender, "none")`, validate the full name, and
  whisper the full name.
- One addon message per second; ~200 characters per message; numbered parts because
  whispers can arrive out of order.
- No messages during combat; pause in instances as well.
- `SendAddonMessage` returns a result code: 0 = sent, throttle codes retried with
  backoff, `NotInGroup` dropped. Hide "No player named" for whispers we initiated.
- Discovery is the hard part: greet group/guild, and whisper players you meet (target,
  mouseover, nameplate, chat, trade). Exchange address books to grow the network.
- Storage must be capped (samples are unbounded in principle).

## Addon layout

```
KwaDropShare/
    KwaDropShare.toc          ## SavedVariables: KwaDropShareDB
                              ## Dependencies: KwaLite
                              ## OptionalDeps: KwaKillCounter
    KwaDropShare.lua          register plugin, panel, minimized, slash commands
    KwaDropShareData.lua      schema, validation, merge, pruning
    KwaDropShareSync.lua      prefix, queue, protocol, discovery, contacts
    README.md
    install.sh
    install.bat
```

Do **not** add to `InstallAll.sh` until the plugin is usable. Priority `10` (after Bank
Search). If `KwaKillCounter`/`MyKillCountTable` is missing, register disabled with a
panel message rather than returning early, so the user sees why.

## Data model

```lua
KwaDropShareDB = {
    version = 1,
    epoch = "a1b2c3d4",              -- random per install; resets counters if reinstalled
    local_ = {                        -- snapshot of our own samples we are willing to share
        [npcID] = {
            name = "Defias Pillager",
            kills = 120, looted = 96,
            items = { [2589] = 41 },
        },
    },
    peers = {                         -- per-faction address book
        ["Alliance"] = {
            ["Tillie Lumenwick"] = {
                added = 1730000000, heard = 1730000500,
                digest = "…", digestAt = 1730000400,
                lastVersion = "1.0.0",
            },
        },
    },
    remote = {                        -- latest cumulative snapshot per contributor, per NPC
        [npcID] = {
            name = "Defias Pillager",
            sources = {
                ["deadbeef"] = { epoch = "…", kills = 120, looted = 96,
                                 items = { [2589] = 41 }, at = 1730000000 },
            },
        },
    },
    seq = 0,                          -- local sample change counter
    updateNotice = nil,               -- newest addon version seen from 2+ peers
}
```

Key rules:

- **Idempotent snapshots, not running deltas.** A contributor sends its *cumulative*
  counts for changed NPCs, tagged with its install `epoch`. The receiver replaces that
  contributor's entry instead of adding. Retransmits and out-of-order chunks are
  harmless, and a reinstall is detected by the epoch change.
- **Merged view is computed**, not stored: sum `sources` per NPC. Keep `sources` so the
  UI can show contributor counts and the "confirmed by 2+" rule.
- **Our own data always wins** in the UI; community data is a separate column.
- Contributor IDs are anonymous random hex, not character names. Character names are
  only kept in `peers` for whispering (and are not shared with data payloads).
- Prune: NPCs with no new data for 180 days, peers not heard from for 21 days, max ~400
  peers per faction, max ~3000 NPCs, max ~120 items per NPC.

## Protocol (tag `KDS1`)

Messages are `|`-separated, ASCII, chunks of 180 chars. All data chunks are compressed
and printable-encoded before chunking:

```lua
-- preferred (already in the client; see WoW_API.md)
local blob = C_EncodingUtil.EncodeBase64(C_EncodingUtil.CompressString(
    C_EncodingUtil.SerializeCBOR(payload)))
-- fallback if unavailable
local blob = LibDeflate:EncodeForPrint(LibDeflate:CompressDeflate(ns.ToJson(payload)))
```

| Kind | Format | Purpose |
| --- | --- | --- |
| `H` | `KDS1\|H\|proto\|addonVersion` | Hello; asks for a summary. |
| `S` | `KDS1\|S\|digest\|npcCount\|epoch\|reply\|addonVersion` | Summary. Compare with ours; `reply=0` means don't answer. |
| `L` | `KDS1\|L\|mode\|last\|npcID:seq,npcID:seq,…` | Inventory of NPCs the sender holds, in chunks. `mode=Q` asks for theirs, `A` answers. |
| `Q` | `KDS1\|Q\|npcID,npcID,…` | Request specific NPC samples. |
| `D` | `KDS1\|D\|npcID\|epoch\|seq\|total\|blob` | One compressed snapshot chunk. |
| `B` | `KDS1\|B\|name,name,…` | Address-book exchange. |

Handshake:

```
A: H ───────────────▶ B
A: ◀─────────────── S (digest, count, epoch, ver)
A: L(Q) ────────────▶ B        (only if digests differ)
A: ◀─────────────── L(A)       (their NPC list)
A: Q(ids we lack/new/capped) ▶
A: ◀─────────────── D…         (compressed snapshots, numbered)
A: B(names) ────────▶ B        (occasionally, not every swap)
```

Rules:

- Accept `P/S/L/D/B` from `WHISPER` only; accept `S` from group/guild too (cheap digest
  broadcast). Ignore messages from ourselves (group messages echo back).
- Verify `prefix == "KWADROP"` and the `KDS1|` tag before parsing.
- Cap: chunk ≤ 200 chars, payload ≤ 60 KB compressed, ≤ 6000 items per snapshot, ≤ 2
  inventory chunks per swap, ≤ 20 NPC snapshots requested per swap.
- Rate: 1 msg/s, fast lane for `H/S/Q` ahead of `D` chunks, queue ≤ 1000, ≤ 600
  messages per peer per 10 minutes.
- Retry throttled sends up to 3 times (3 s backoff); never retry `NotInGroup` or
  "player not found".
- No traffic while `InCombatLockdown()` or in an instance. Start 20 s after login.
- A peer swap at most every 10 minutes; contact ping every 20 minutes; address book
  every 6 hours.

## Validation and trust

In `KwaDropShareData.lua`, before storing anything:

- Types: npcID/itemID numeric strings, names ≤ 80 chars, counts integers.
- Ranges: `0 ≤ items[id] ≤ looted ≤ kills`; `kills ≤ 1e7`; item IDs 1–1e6; npc IDs 1–1e7.
- Sizes: reject unknown keys, over-long lists, duplicate NPCs in one payload.
- Epoch: an older epoch from the same contributor replaces (or is ignored) by `at`.
- Merge: sum across contributors; expose `confirmed = (contributorCount >= 2)`.
- Changed values only become "community" when 2+ independent contributors agree, mirroring
  ProfPlanner's price rule. One contributor = "unconfirmed".
- Show provenance in tooltips: your rate, community rate, N contributors, last update.

## UI

Follow KwaLite conventions (`Util.CreateScrollPanel`, `Util.CreateSearchBox`, row pool,
`GameFontHighlightSmall`, tooltips with `GameTooltip:Hide()` on leave).

Panel:

```
[ Search… ]                         [Share now] [Reset mine]
Defias Pillager        41/96  43%   ███████        community 39% (3)
  Linen Cloth          41/96  43%   your 43% · 3 contributors · 120 kills
Moonbrook Guard        12/30  40%   ██████         community 41% (1, unconfirmed)
```

- Rows sorted by sample count; bar scaled to the highest rate.
- Expandable per item, or a second list when an NPC row is clicked.
- Tooltip: your `items/looted`, community `items/looted`, contributor count, last sync.
- Minimized: `Shared 1,240 samples` / `Sync: 3 peers`.
- Slash: `/kwadrop status | share | hello <Name> | contacts | export | purge | reset`.
- `export` prints a base64 blob (or writes it to a copyable edit box) for offline merge.

## Implementation milestones

1. **Skeleton** — folder, toc, plugin registration, panel showing your own
   `MyKillCountTable` rates (no networking). Verify with `/reload`.
2. **Local DB + merge** — `KwaDropShareData.lua` with schema, validation, snapshot
   replacement, merge, pruning. Mock tests for idempotency and bad payloads.
3. **Codec** — encode/decode payloads; feature-detect `C_EncodingUtil`, fall back to
   LibDeflate only if needed (avoid bundling until proven necessary).
4. **Transport** — prefix registration, send queue, 1/s pump, throttle/backoff, pause in
   combat/instances. Manual `/kwadrop hello <Name>` first.
5. **Protocol** — H/S/L/Q/D/B handlers, digest comparison, chunk assembly. Two-client
   mock harness in `/tmp/opencode`.
6. **Discovery** — group/guild hello, met-player candidates, caps, address book, version
   notice (2 peers, once per version).
7. **UI polish** — community column, contributor counts, search/filter, export.
8. **Optional** — `tools/merge_dropshare.py` to merge exported blobs into a shipped
   `KwaDropShareData.lua` snapshot; offline only, never at runtime.

## Test plan

- `luac -p` on every file.
- Mock two-client harness in `/tmp/opencode`:
  - snapshot replacement is idempotent across duplicate and out-of-order chunks
  - rejecting `items > looted`, oversized lists, unknown tags, wrong prefix
  - chunker round-trips at 180/200 char boundaries
  - throttle retry and `NotInGroup` drop
  - epoch change resets a contributor without double counting
- In game (two accounts or a friend):
  - `/kwadrop hello <name>` receives a summary and swaps data
  - no chat spam, no sends in combat/instance, queue drains at ~1/s
  - SavedVariables size stays reasonable after a long session
  - `/kwadrop export` produces a blob the mock parser accepts

## Risks / open questions

- **Reach** is limited to group/guild/met players; this will never be a global database.
  The address-book gossip is what makes it grow, and it is the most complex part.
- **Data volume**: many NPCs × items; snapshots per changed NPC keep messages small, but
  a fresh peer with many NPCs may take a long time at 1 msg/s. Request priority should
  favour rare mobs / under-sampled pairs.
- **Denominator semantics**: kills ≠ looted (corpses left unlooted, skinning, quest
  items). Always share both and display rates against `looted`.
- **Game changes**: rates shift with patches; stamp samples with addon/protocol version
  and prune old ones. No server build info is available to addons.
- **Cross-realm / connected realms**: whispers need `Name-Realm` in some cases; test on
  Forever. Same-faction only (ProfPlanner keeps separate books per faction).
- **Prefix registration**: ProfPlanner appears to receive without registering; still
  register (StaleCheck, Details, Auctionator do) and ignore the old Fallback globals.
- **Spoofing**: names, versions and samples are all forgeable. Never act on remote data;
  only display it, require 2+ contributors, keep your own data authoritative.

## Reference paths (installed client)

- `…/Interface/AddOns/BagBrother/libs/StaleCheck-1.0/StaleCheck-1.0.lua`
- `…/Interface/AddOns/ProfPlanner/Sync.lua` — constants at 53–90, queue at 988+,
  protocol at 1240+, receive at 1704+, discovery at 1780+
- `…/Interface/AddOns/Details/core/network.lua`
- `…/Interface/AddOns/Auctionator/Source/Initialize/Main.lua`
- `KwaKillCounter/KwaCore.lua` — `RecordKill` at ~200, loot merge at ~470
- `KwaKillCounter/KwaCommands.lua` — existing rate calculation at ~100
- `WoW_API.md` — `C_ChatInfo.*`, `C_EncodingUtil.*`, loot functions
