# KwaLite

Shared window and minimized-bar framework for Kwa addons on **WoW Forever (16001)**.

## Usage

- `/kwa` or `/kwalite` toggles the window: closes it if open, opens it if closed.
- The window opens automatically once per login/reload, starting minimized.
- The title bar shows the active addon's name, with a 16×16 plugin icon on the right for each registered addon.
- Other addons register a panel and a minimized widget with `KwaLite:RegisterAddon`.
- Each addon page has a checkbox at the top: when checked, that addon's compact info appears while the window is minimized.
- Each compact entry shows the addon's icon to the left of its text, RuneLite-style.
- If no addon is checked, the minimized bar only shows the `+` button.
- The close button is intentionally omitted. Right-click the title bar or minimized bar and choose **Close Kwa**.

## API

```lua
KwaLite:RegisterAddon({
    id = "MyAddon",
    name = "My Addon",
    icon = "Interface\\Icons\\INV_Misc_Bag_07", -- shown in the right-side plugin bar
    -- Required: build the full panel page. `parent` is the page content area.
    createPanel = function(parent, addon)
        local page = CreateFrame("Frame", nil, parent)
        -- ... build page contents ...
        return page
    end,
    -- Required: build the compact widget shown in the minimized bar.
    createMinimized = function(parent, addon)
        local widget = CreateFrame("Frame", nil, parent)
        -- ... build compact contents ...
        return widget
    end,
    -- Optional: refresh the page, usually on data changes.
    refresh = function(page, addon) end,
    -- Optional: refresh the compact widget and update its width.
    refreshMinimized = function(widget, addon) end,
    -- Optional: defaults to true.
    showMinimizedByDefault = true,
})
```
