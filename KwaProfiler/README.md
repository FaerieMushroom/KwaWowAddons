# KwaProfiler

Optional per-plugin Lua CPU profiler for **KwaLite** on **WoW Forever (16001)**.

The plugin is **disabled by default** so it does not appear in the plugin bar
until it is enabled on the Kwa Lite Settings page.

## What it shows

While the profiler is enabled and the Kwa Lite window is shown and expanded, it
measures Lua time spent in:

- each Kwa plugin's `refresh` / `refreshMinimized` callbacks,
- the `OnUpdate`, `OnEvent`, `OnShow`, and `OnHide` scripts of frames created
  by Kwa plugins,
- Kwa Lite's own window methods and frame scripts.

Rows show the rolling **30-second** window, sorted slowest first:

- **ms/f** — Lua milliseconds per rendered frame in the window.
- **total** — milliseconds spent in the window.
- **calls** — number of instrumented callback invocations.
- **max** — the single slowest invocation.
- **session** — total milliseconds since the last **Reset**.

The page repolls every **5 seconds**.

## Notes

- WoW has no per-addon CPU counter. This instruments Kwa callbacks and frame
  scripts, so it reports **Lua time**, not total frame time. Engine and render
  work is not included, and shared code that does not belong to a plugin
  (for example `KwaUtils`) is not attributed.
- Hidden plugin pages do not run their `OnUpdate` or `refresh`, so a plugin only
  accumulates meaningful numbers while you actually use it. Global event frames
  (XP ticker, auction resolver, item-load handlers) are measured continuously.
- Profiling pauses when the Kwa Lite window is hidden or minimized, or when the
  plugin is disabled. Nothing is measured when the plugin is off.
- Use **Reset** to clear both the rolling window and session totals.

## Usage

1. Open `/kwa` and select **Settings**.
2. Enable **Profiler**.
3. Select **Profiler** in the plugin bar.
4. Browse the plugins you want to measure, then return to the Profiler page.
