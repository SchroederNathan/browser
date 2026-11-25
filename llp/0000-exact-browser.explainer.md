# LLP 0000: Exact Browser

**Type:** Explainer
**Role:** Root
**Status:** Draft
**Systems:** App
**Author:** Claude (not yet reviewed by a maintainer)
**Date:** 2026-11-25

Provenance: `[observed]` names where a fact was seen. `[confirmed]` names the person who stated it and
the date. A line marked *Agent decision* is a choice the agent made while it built the feature. No
maintainer has ratified an agent decision.

## Summary

Exact Browser is a mobile web browser for iPhone and iPhone Duo. It is an
[Exact](https://github.com/expo/exact) app. `[observed]` `README.md`, `app.json`.

## Where things are

| File | What it holds |
| --- | --- |
| `app.contract` | The root view: pages, the bar, the tab grid, and every action |
| `sheets.contract` | The search sheet and the page menu |
| `tabs.contract` | The `Tab` record, a tab's card, and one page of the tab pager |
| `address.contract` | Address helpers and a site's icon |
| `design.contract` | Type, motion and surface styles |
| `icons.contract` | Draws an icon token by name |
| `app.forma` | Colour, radius, spacing and icon tokens. `tools/icons.py` writes the icons |
| `app.ts` | The data module. It answers no source yet |
| `modules/apple/PageHatch.swift` | Native code for a page's web view |
| `app.test.contract` | Behavior tests |
| `TODO.md` | Controls that are on screen but do nothing yet |

## Subsystems

- **The browser's chrome**: the bar, its two sheets, and the tab grid. See LLP 0001.
- **Pages**: one `iframe` for each tab, in the `persist:browser` partition. See LLP 0001#pages.
- **The design system**: `app.forma` and `design.contract`. See LLP 0001#design-system.

## Constraints

- The design source is the Paper file "iOS Browser MVP". It has four iPhone screens, a design
  system page, and sixteen iPhone Duo screens. `[observed]` Paper file, 2026-11-25.
- CI builds with Exact at the commit that `eas.json` names in `EXACT_REF`. `[observed]` `eas.json`,
  `.ci/prepare-native.sh`.
