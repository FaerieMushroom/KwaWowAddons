# KwaXpTracker

Session XP tracker plugin for **KwaLite** on **WoW Forever (16001)**. Requires the `KwaLite` addon.

## Features

- RuneLite-style layout: XP gained, XP left, XP/hour, time to level, session time, and last gain.
- Solid-color XP bar with the current level on the left, percent in the middle, and next level on the right.
- Total XP gained is shown for the current session only.
- Right-click the panel for reset options.
- Compact minimized display with XP gained and XP/hour (plus the plugin icon in the Kwa Lite minimized bar).

Classic clients do not reliably distinguish quest XP from kill XP in the combat log, so this tracker counts all XP gains together instead of splitting them.

## Right-click menu

- **Reset session XP** — clears the session XP gained and last-gain values.
- **Reset XP/hour timer** — restarts the session timer without clearing XP.
- **Reset all** — clears XP and restarts the session timer.

## Usage

- `/kwa` or `/kwalite` opens the Kwa Lite window.
- Select the **XP Tracker** plugin from the right-side icon bar.
- Tick the checkbox at the top of the page to show the compact XP readout while Kwa Lite is minimized.
