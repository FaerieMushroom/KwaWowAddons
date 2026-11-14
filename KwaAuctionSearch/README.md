# KwaAuctionSearch

Auctionator-powered item price search plugin for **KwaLite** on **WoW Forever (16001)**.

This addon is optional: it only registers itself when **Auctionator** is installed. If Auctionator is missing, the plugin is not shown in Kwa Lite and nothing errors.

## Features

- RuneLite-style item search panel inside Kwa Lite.
- Search by item name across the items stored in Auctionator's price database.
- Results are capped at **50 entries** to keep the panel responsive.
- Each row shows the item icon, quality-colored name, and price data:
  - **Value** — the last seen minimum price.
  - **Low** — the lowest price ever seen in the stored history.
  - **Max** — the highest price ever seen in the stored history.
  - **Avg** — Auctionator's mean price when available.
- Hover an item for its full tooltip.
- Shift-click a row to insert the item link into chat.
- Results update once Auctionator finishes a new scan.
- No minimized-bar display; the search panel is only available in the expanded window.

## Usage

- `/kwa` or `/kwalite` opens Kwa Lite.
- Select **Auction Search** from the right-side plugin bar.
- Type an item name in the search field and press Enter (or wait for the short debounce).
- Prices come from Auctionator's stored scan data, so the Auction House does not need to be open.

## Notes

- The item index is built from Auctionator's price database and cached for the session, then resolved in small chunks so searching stays responsive.
- Only items with prices in Auctionator's database are searchable.
- Auctionator is not bundled; install it separately.
