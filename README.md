# Exact Browser

A mobile web browser built with [Exact](https://github.com/expo/exact).

## What is here

The browser's chrome follows the Paper file "iOS Browser MVP": a Liquid Glass bar over the page, a
search sheet, a page menu, and a tab grid, for iPhone and iPhone Duo.

- `app.contract`, `sheets.contract`, `tabs.contract`, `address.contract`: the views and actions.
- `app.forma`, `design.contract`, `icons.contract`: the design system.
- `llp/`: design decisions. Start at `llp/0000-exact-browser.explainer.md`.
- `TODO.md`: controls that are on screen but do nothing yet.

## Develop

Set `EXACT` to an Exact checkout at the commit in `eas.json` (`EXACT_REF`), then:

```sh
bun exact.mjs web          # web dev loop
bun exact.mjs ios --run    # iOS Simulator
bun exact.mjs test ios     # tests (also: test web)
```

## Release

Each push to `main` builds the iOS app on EAS and submits it to TestFlight (`.eas/workflows/testflight.yml`).
