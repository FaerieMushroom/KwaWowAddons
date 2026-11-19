# KwaBankSearch

Account-wide bank and inventory search for **KwaLite** on **WoW Forever (16001)**.

## What it does

- Remembers each character's bags and bank in `KwaBankSearchDB`.
- Lists every character's inventories and banks, grouped by character.
- The search box filters that list; filter-only queries such as `count>1` work
  on their own.
- The **Show own inventory** checkbox shows or hides your current character's
  live bags. It is on by default.
- Hover an item for its tooltip. Shift-click to insert its link into chat.

Only the logged-in character's containers can be read by the client. Bags are
rescanned live on bag updates, and the bank is rescanned whenever it is open.
Other characters' data is shown from their last saved snapshot, so it is as
fresh as the last time that character logged in or opened their bank.

## Search syntax

Plain words match item names. Multiple words must all match.

| Filter | Meaning |
| --- | --- |
| `@recipe` | Only profession recipes (`Recipe:`, `Pattern:`, `Formula:`, `Schematic:`, `Plans:`, `Technique:`). |
| `@gray`, `@white`, `@green`, `@blue`, `@purple` | Exact rarity. |
| `rarity=poor`, `rarity=common`, `rarity=uncommon`, `rarity=rare`, `rarity=epic` | Exact rarity (names or numeric ids work). |
| `rarity>rare`, `rarity<epic`, `rarity>=uncommon`, `rarity<=blue` | Rarity comparison. |
| `count>10`, `count<5`, `count>=20`, `count<=3`, `count=1` | Section count comparison. |

Examples:

```text
@recipe
@epic sword
rarity>=rare count>5
@recipe rarity>green
```

Counts are the combined quantity of that item inside the shown section, so
`count>10` means "10 or more of this item in that character's bank (or your
bags)".

## Notes

- The plugin is enabled by default.
- Entries are grouped per character and per location (Inventory or Bank).
- The checkbox only controls whether your current character's bags are listed.
- Filters apply to the listed sections; a filter alone needs no name text.
- The first open scans your bags immediately.
- Empty sections are not shown.
