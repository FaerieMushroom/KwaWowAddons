# KwaLite

Shared window and minimized-bar framework for Kwa addons on **WoW Forever (16001)**.

## Usage

- `/kwa` or `/kwalite` toggles the window: closes it if open, opens it if closed.
- The window opens automatically once per login/reload, starting minimized.
- The title bar shows the active addon's name, with a 16×16 plugin icon on the right for each registered addon.
- Other addons register a panel with `KwaLite:RegisterAddon`, and can optionally provide a minimized widget.
- Each addon that provides one or more minimized views has a checkbox per view at the top of the page: when checked, that view's compact info appears while the window is minimized. Plugins can set `renderMinimizedOptions = false` and render their own checkboxes inside the page; use `KwaLite:SetMinimizedViewShown` to toggle views.
- Addons without minimized views have no minimized display and no checkbox; their page uses the full panel height.
- Plugins are ordered by their `priority` value (lowest first); plugins with equal priority keep registration order.
- Plugins are enabled by default. A plugin can set `enabledByDefault = false` to start disabled. A plugin can be disabled from the Settings page; disabled plugins are removed from the plugin bar and minimized bar.
- A plugin can optionally register a settings panel. The Settings page shows a **Settings** button only for plugins that provide `createSettings`.
- Each compact entry shows the addon's icon to the left of its text, RuneLite-style.
- If no addon is checked, the minimized bar only shows the `+` button.
- The close button is intentionally omitted. Right-click the title bar or minimized bar and choose **Close Kwa**.

## Shared helpers

`KwaLite/KwaLiteUtil.lua` loads before the window and exposes `KwaLite.Util`. Plugins
should use it instead of copying helpers. It provides:

- `Util.DEFAULT_ICON` – fallback texture path.
- `Util.SafeCall(fn, ...)` – pcall wrapper returning the first result or `nil`.
- `Util.NormalizeIcon(icon)` – treats `0`/`""`/numeric strings as missing.
- `Util.GetItemInfoAPI()`, `Util.GetItemInfoInstantAPI()`, `Util.GetItemIcon(id)`.
- `Util.RequestItemData(id)` – asks the client to load item data.
- `Util.UpdateItemMeta(id, meta)` – fills name/link/quality/icon/class fields in place.
- `Util.FormatMoney(copper)` – coin string, preferring `C_CurrencyInfo`.
- `Util.ColorName(name, quality)` – quality-colored item name.
- `Util.CreateScrollPanel(panel, options)` – standard scroll frame + scroll child.
- `Util.FitContentWidth(scroll, content, panel, padding, fallbackWidth)` – resize scroll content. Returns the fitted width.
- `Util.AddRowHoverBackground(row, alpha)` – hover-highlight BACKGROUND texture attached to a row, hidden until OnEnter.
- `Util.SetHoverScripts(frame)` – attach standard OnEnter/OnLeave show/hide scripts.
- `Util.SetHoverBackground(frame, alpha)` – create hover background + scripts in one call.
- `Util.CreateSearchBox(parent, options)` – backdropped search field with placeholder; returns `frame, box, placeholder, updatePlaceholder`.
- `Util.CreateItemLoader(options)` – staggered `RequestItemData` loader for lists of item IDs (`budget`/`interval`/`retryInterval`/`maxAttempts`/`scanBudget`/`isReady`/`isActive`/`onRefresh`); `Start`, `Stop`, `Reset`, `SetItems`, `AddItems`, `MarkDirty`, `Requeue`. Retries dropped requests, so call `Requeue` from item-data events.
- `Util.ParseMoney(text)` – parses `1g 50s 25c` (or plain copper) into copper.
- `Util.ParseFilterQuery(text, spec)` – shared filter syntax (`kills>5`, `vendor>=1g`, `count<3`, `@recipe`, free-text terms). `spec.fields` defines token prefixes and min/max keys; `spec.aliases`/`spec.aliasField` add exact-match aliases; `spec.flags` adds literal flags.
- `Util.MatchesFilter(parsed, values)` – evaluates a parsed query against a values table (`values.nameLower` plus one key per field).
- `Util.CreateRowPool(createRow)` – sequential row pool; `Get(index)` creates on demand, `Trim(count[, onHide])` hides extra rows.
- `Util.CreateItemRow(parent, options)` – shared Button row with highlight/icon/name; caller adds extra columns or scripts.
- `Util.ShowItemTooltip(owner, id, link)` / `Util.HideTooltip()`.

```lua
local Util = KwaLite.Util
local scroll, content = Util.CreateScrollPanel(panel, { top = 40 })
```

## API

```lua
KwaLite:RegisterAddon({
    id = "MyAddon",
    name = "My Addon",
    icon = "Interface\\Icons\\INV_Misc_Bag_07", -- shown in the right-side plugin bar
    priority = 0, -- optional; lower values appear higher in the plugin bar
    -- Required: build the full panel page. `parent` is the page content area.
    createPanel = function(parent, addon)
        local page = CreateFrame("Frame", nil, parent)
        -- ... build page contents ...
        return page
    end,
    -- Optional: build one or more compact widgets shown in the minimized bar.
    -- Omit this to give the plugin no minimized display.
    minimizedViews = {
        {
            id = "myView",                 -- stable, unique within the plugin
            label = "Time to Level",       -- checkbox label after "Minimized window:"
            icon = "Interface\\Icons\\INV_Misc_QuestionMark",
            showByDefault = false,
            create = function(parent, addon, view)
                local widget = CreateFrame("Frame", nil, parent)
                -- ... build compact contents ...
                return widget
            end,
            refresh = function(widget, addon, view) end, -- called when shown/refreshed
            onToggle = function(checked, addon, view) end, -- optional
        },
    },
    -- Legacy single-view shorthand, equivalent to one minimizedViews entry.
    -- createMinimized = function(parent, addon) ... end,
    -- refreshMinimized = function(widget, addon) end,
    -- Optional: render minimized checkboxes inside your own page instead.
    -- renderMinimizedOptions = false,
    -- Optional: refresh the page, usually on data changes.
    refresh = function(page, addon) end,
    -- Optional: build this plugin's settings panel. The Settings page shows a
    -- Settings button only when this is provided.
    createSettings = function(parent, addon)
        local page = CreateFrame("Frame", nil, parent)
        return page
    end,
    -- Optional: defaults to true. Set false to register the plugin disabled.
    enabledByDefault = true,
    -- Optional: defaults to true.
    showMinimizedByDefault = true,
})
```

### Managing plugins

```lua
KwaLite:GetAddons()                  -- all registered addon tables, sorted
KwaLite:GetAddon(id)
KwaLite:IsAddonEnabled(id)
KwaLite:SetAddonEnabled(id, false)   -- hides the plugin and its page
KwaLite:IsMinimizedViewShown(id, viewID) -- true when that view is enabled
KwaLite:SetMinimizedViewShown(id, viewID, checked)
KwaLite:HasAddonSettings(id)         -- true only when createSettings was provided
KwaLite:CreateAddonSettings(id, parent)
```

`SetAddonEnabled` persists to `KwaLiteDB`. Disabling the active plugin switches
to the next enabled plugin.
