# TODO

Controls and behavior that the design shows but the app does not do yet. Each control is on screen
and has a `testId`. Its code has a `TODO(TODO.md#<section>)` comment.

When you build one of these:

1. Replace the `later` action on the control with its own action.
2. Remove the item from this file and remove the `TODO` comment.
3. Add a test to `app.test.contract`.

When you add a control that does nothing yet, add it here in the same form.

## Voice search

Design: Paper "02 Search", the microphone in the search field. It shows while the field is empty.
While the field holds text, the clear button (`clear`) is in its place.

- [ ] `voice` (`sheets.contract`, `SearchSheet`): start dictation and write the result to the field.
  Exact has `@exact/speech-recognition`. The app must ask for the microphone and speech permissions.

## Page menu

Design: Paper "03 Page Menu". Code: `sheets.contract`, `MenuSheet`.

- [ ] `menu-find`, Find on Page: search the page text and step through the matches.
- [ ] `menu-summarize`, Summarize: summarize the page. Decide the model and where it runs first.
- [ ] `menu-pin`, Pin Tab: keep a tab at the start of the grid. `Tab` (`tabs.contract`) needs a `pinned` field.
- [ ] `menu-share`, Share: open the system share sheet with the page address. Exact has a `share` command.
- [ ] `menu-reader`, Reader Mode: show the page's article text only.
- [ ] `menu-translate`, Translate: translate the page. Exact has `@exact/translation`.
- [ ] `menu-zoom-out`, `menu-zoom-in`, Page Zoom: change the page zoom for the site and show it in `menu-zoom`.
  The readout shows `100%` now. `Tab` needs a `zoom` field. An `iframe` has a `zoom` attribute.
- [ ] `menu-desktop`, Request Desktop Site: load the page with a desktop user agent.
- [ ] `menu-settings`, Site Settings: the site's permissions and data.

These page menu controls work now: Back, Forward, Copy Link, Reload, Close Tab.

## Private tabs

Private tabs work: the left page of the pager above the tab grid (`app.contract`, `tabs.contract`).

- [ ] A design for the private page and for a private page's bar. Both look like the regular ones now.
- [ ] Decide what a private tab keeps. Its frame uses the partition `private`. No recent entry and no
  site icon is kept for it.

## Tabs

- [ ] Keep the tabs across launches. `tabs` is state in memory now. Records need a source in `app.ts`
  (`bun exact.mjs contract vocab files-and-grants`).
- [ ] Delete a tab's snapshots from `app:/cache` when the tab closes. Each tab has at most two files,
  `tab-<id>-0.png` and `tab-<id>-1.png`.
- [ ] Reorder tabs by drag in the grid.
- [ ] On the folded iPhone Duo the grid's second column is under the status rail at the top
  (`safeAreaRight` is 84). The grid does not read the side safe areas yet.
- [ ] When the Duo unfolds while the grid shows, the pager lands on the private page: `pagerStart`
  holds the old screen's width.

## Search sheet

- [ ] Suggestions while the person types. The sheet shows the four newest recent entries now.
- [ ] Favorites. The second design pass removed the site tiles from the sheet.
- [ ] Let the person clear the recent entries.
- [ ] Let the person choose the search engine. `addressOf` in `address.contract` uses Google.
- [ ] A pull down on the search field does not move the sheet: the field keeps its own drags. A
  pull anywhere else on the sheet closes it.

## Pages

- [ ] Show load progress and a load error. `navigateerror` has no handler now.
- [ ] Before iOS 26, a page's fixed bottom content stays under the bar. On iOS 26 and later it sits
  above the bar (`modules/apple/PageHatch.swift`).
- [ ] Downloads. A frame reports one with `download=`; there is no handler now.

## Design system

- [ ] A dark theme. The Paper design system has a light scheme only, so every colour in `app.forma`
  is `scheme=fixed`.
- [ ] Dynamic Type. The design gives type sizes in points, and the bar and rows have fixed heights,
  so text does not grow with the system text size.
- [ ] Contrast. "Close Tab" (`red-600` on `neutral-200`) is 3.8:1; body text needs 4.5:1.
