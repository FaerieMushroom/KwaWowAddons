# KwaBookmarker

Keeps two character macros in sync with a list of mob names you bookmark, on **WoW Forever (16001)**.

## Features

- Automatically creates and maintains two macros:
  - **KwaMarker** — `/run KwaBookmarker:AddTarget()`, which adds your current target mob to the list.
  - **KwaTarget** — targets bookmarked mobs and puts the **X** raid marker on the result.
- Track as many mobs as you like. The list works like Unit Labeler, with an `x` button on every row.
- Type any mob name directly into the text field and press Enter (or `+`) to add it without targeting the mob.
- `Top` promotes a mob to the front of the list so it fits in the macro.
- Rows show whether each mob is **in macro** or **queued** because it did not fit in the 255-character macro limit.
- The macro is filled with as many names as fit, highest priority last, and drops the lowest-priority names when it runs out of room.
- Dead targets fall back to your previous target (`/targetlasttarget [dead]`).
- Macro edits are deferred during combat and applied when combat ends.

## Usage

1. `/kwa` or `/kwalite` to open Kwa Lite.
2. Select **Bookmarker** from the plugin bar.
3. Drag the **KwaMarker** macro onto an action bar (or use it from the macro UI).
4. Target a mob and click **KwaMarker**. The mob appears in the list; using KwaMarker on the same name again removes it.
5. You can also type a name into the field at the top and press Enter or `+` to add it manually, or again to remove it.
6. Click **KwaTarget** to target the highest-priority bookmarked mob that is nearby, and mark it with X.
7. Use `Top` to move a queued mob into the macro, or `x` to remove it.

Players cannot be bookmarked. Bookmarking a name that is already in the list removes it, so `KwaMarker` and the name field both toggle.

## Notes

- Macro priority is the list order: index 1 is the highest priority. New mobs are appended to the end.
- `/targetexact` matches the exact mob name, so the name stored is the name the client reports.
- The X marker is raid marker 7. `/tm !7` always sets it rather than toggling it off.
- The target macro reserves room for the marker and dead-fallback lines; on Forever that leaves 223 characters for `/targetexact` lines.
- If there are no free macro slots, the plugin reports it in chat and tries again on the next list change or login.
- Entries are stored in `KwaBookmarkerDB` and are shared across characters on the account. Each character gets its own copies of the two macros built from that list.
