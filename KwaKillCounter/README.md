# ⚠️ WARNING: VIBE CODED SLOP

Simple WoW addon for tracking NPC kills and item drop sources. Ported to **WoW Forever (1.60.1 / interface 16001)**.

## ✨ Features

- **🎯 Kill Tracking**: Automatically records kills of unique NPCs.
- **🧬 Species Tracking**: Logs kills by NPC species.
- **💰 Mob value tracking**: Logs kills, displaying average vendor and auction values of that NPC.
- **🧾 Session Loot Tracker**: `/kwa` (or `/kwalite`) opens the Kwa Lite window with a RuneLite-style loot panel showing only mobs killed this session, with per-item counts and vendor/auction totals.
- **💰 Drop Source Discovery**: Records items dropped by NPCs to help you find where to farm them later.

## ⌨️ Slash Commands

- `/kwakills` — Displays your total kills and the top 5 most killed NPCs.
- `/kwaracekills` — Displays your kill counts categorized by NPC race / species.
- `/kwafind [Item Link/Name]` — Searches for NPCs that have dropped a specific item and shows their calculated drop rates.
- `/kwatopvendor` — Displays the top 10 most profitable NPCs based on vendor value.
- `/kwatopauction` — Displays the top 10 most profitable NPCs based on auction value (requires Auctionator).
- `/kwa` or `/kwalite` — Opens the Kwa Lite window, including the session loot tracker.
- `/kwapurge` — Clears all loot and value data to remove outliers (kill counts are preserved).
- `/kwafullpurge` — Fully resets everything: kills, loot, XP, and value data.
- `/kwahelp` — Displays a list of all available slash commands.

## 🧾 Loot Tracker

- The panel starts empty each time the addon loads and only lists mobs killed during that session.
- Each mob's section moves to the top when it is killed again.
- Each mob shows its kill count and direct coin drops (gold/silver/copper) for the selected view; merged groups show combined totals.
- The top of the panel shows the current view's total vendor and auction value.
- `Session loot` checkbox: checked shows this session's drops, unchecked shows all recorded loot.
- Use the `-` button in the title bar to minimize; the compact bar shows the minimized info for each checked addon, with a `+` button to expand.
- Right-click the title bar or minimized bar for the `Close Kwa` option.
- Merged groups persist across reloads and game sessions.
- Hover items for item tooltips with per-item vendor/auction values.
- **Ctrl+Click** a mob name to start a merge (the first mob gets a green outline), then Ctrl+Click another mob to merge their tracker entries. Merged entries show the first mob's name with `+X`.
- **Right-click** a mob name to open a context menu:
  - `Reset group/kill` — deletes the recorded kill/loot data for the mob, or for every mob in a merged group.
  - `Reset session` — clears only this session's loot for the mob/group.
  - `Unmerge` — splits a merged group without touching any data.

## 🖱️ Tooltips

- **Shift + Hover** 🖱️: Hold the `Shift` key while hovering over an item in your inventory or a merchant window to see the top 3 NPC sources and their calculated drop rates based on your recorded data.

## 📦 Install (WoW Forever)

Forever uses its own client folder. Install to:

```
World of Warcraft\_forever_\Interface\AddOns\KwaLite\
World of Warcraft\_forever_\Interface\AddOns\KwaKillCounter\
```

Install **KwaLite** as well as **KwaKillCounter**. Requires the Forever client (`1.60.1`, interface `16001`). Classic Era files will not load. `install.bat` now targets the `_forever_` folder.

## ⚠️ Known Forever limitations

- Forever does not expose a combat log to addons. Kill detection uses `UNIT_DIED` with a cached target. **Off-target kills** (e.g. AoE / pet kills where that mob was never your target) cannot be attributed and are skipped.
- Hostile GUIDs are **secret values** on Forever. The source GUID of a loot window may also be secret, in which case loot is attributed to the recently targeted dead unit.
- No official WeakAuras build exists for Forever, so the legacy WeakAura display is not required. Use the slash commands and Shift-hover tooltips instead. `WeakAura.lua` is kept only for reference / Musca Auras forks.
