# KwaUnitLabeler

Adds a chosen icon to matching friendly and enemy nameplates in **KwaLite** on **WoW Forever (16001)**.

## Features

- Add any number of name entries, one per player or mob name.
- Each entry has an icon picker with raid markers, class icons, common marker icons, and Forever hearthstone/Delves icons.
- Icons are drawn on the floating nameplate of every unit whose name matches, for both friendly and enemy units.
- Icons scale and move with the nameplate.
- Delete an entry with the `x` button next to it.
- **Settings → Unit Labeler → Settings** chooses the icon anchor: `On top`, `Left`, or `Right`, and the icon size from 10 to 48 pixels.

## Usage

1. `/kwa` or `/kwalite` to open Kwa Lite.
2. Select **Unit Labeler** from the plugin bar.
3. Click `+`, type a player or mob name exactly as it appears, then click the icon button and choose an icon.
4. Icons appear on nameplates as they show up. Existing visible nameplates update immediately.

## Notes

- Matching is case-insensitive and ignores leading/trailing spaces. Entries can be a first name (`Nickel`) or a full name (`Nickel Sparkyclip`); both match a player whose nameplate shows the full name.
- Friendly NPC nameplates must be enabled in the client's nameplate settings to be visible at all.
- Friendly nameplates inside instances are protected by the client and cannot be modified by addons; enemy plates still work.
- Entries are stored in `KwaUnitLabelerDB` and persist across sessions.
