# KwaPetSkills

Hunter pet ability and Beast Training reference plugin for **KwaLite** on **WoW Forever (16001)**.

The plugin is optional: it only registers when the player is a **Hunter**. Other classes never see it in Kwa Lite.

## Features

- Reads the summoned pet's level and creature family.
- Scans the spellbook (player and pet banks) for the pet abilities the hunter has learned.
- Only shows abilities that are available to the summoned pet's family (for example, `Shell Shield` only appears for turtles).
- Splits unlearned abilities into **trainer** and **tame** sections, then lists known abilities. Trainer skills show the best rank for the current pet level; tameable skills list **every unlearned rank separately**, so each tame source is visible, limited to ranks at or below the hunter's level.
- Each row shows the ability icon, name, rank, pet level requirement, and TP cost. Unlearned rows say only `Tame` or `Pet trainer`; hover for source mobs.
- **Show unlearnable** checkbox reveals abilities that the current pet family cannot learn, grouped at the top.
- Hover any ability row for a tooltip. Known abilities use the real spell tooltip when a spell ID can be resolved; otherwise a custom tooltip shows the Petopia description, rank details, and source mobs.
- No minimized-bar readout; the panel is only available in the expanded Kwa Lite window.

## Data

All ability, rank, icon, and source-mob data is hardcoded in `KwaPetSkillsData.lua`, generated from the Petopia Forever pet family abilities page. The addon does **not** read the HTML file at runtime.

Data summary: 31 abilities, 150 ranks, 437 mob sources.

## Usage

- `/kwa` or `/kwalite` opens Kwa Lite.
- Select **Pet Skills** from the right-side plugin bar.
- Summon a pet to see family- and level-specific recommendations.
- Tick **Show unlearnable** to also list abilities the current pet family cannot learn.
- Hover a row for details and source mobs.

## Notes

- Trainer ranks above the pet's level are not recommended until the pet levels up; the trainer section always picks the highest rank the pet qualifies for. Tameable ranks above the pet's current rank are all listed, but only up to your own level, since you cannot tame a pet higher than the hunter.
- Pet family, spellbook layout, and pet actions are read from the client API, so values update on pet, spellbook, and stable events.
- The **Show unlearnable** preference is saved per character in KwaLite's saved variables.
