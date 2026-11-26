# LLP 0001: The browser's chrome

**Type:** RFC
**Status:** Draft
**Systems:** App
**Author:** Claude (not yet reviewed by a maintainer)
**Date:** 2026-11-25
**Related:** LLP 0000

Provenance: `[observed]` names where a fact was seen. `[confirmed]` names the person who stated it and
the date. A line marked *Agent decision* is a choice the agent made while it built the feature. No
maintainer has ratified an agent decision.

## Summary

A page fills the screen. Three Liquid Glass surfaces sit over it at the bottom: the tabs button, the
address pill, and the page menu button. The same three surfaces become the search sheet, the page
menu, and the tab grid's controls. They are never replaced, so one spring carries each surface
between its states.

## Requirements

These come from the request. `[confirmed]` Nathan Schroeder, 2026-11-25.

1. The bar's buttons and containers, and the sheets' backgrounds, are Liquid Glass.
2. A press on the address pill morphs the pill into the search sheet. The address moves to the
   field, the field takes focus, and all of its text is selected.
3. A press on the up chevron morphs the pill into the page menu in the same way.
4. While a sheet grows, the two side buttons leave the screen, each on its own side. They use the
   same animation value as the sheet.
5. The tabs button shows the two most recent tabs.
6. A press on the tabs button shrinks the page into its card in the tab grid. The side buttons'
   icons blur and fade into the grid's icons. The pill shrinks, its address blurs and fades into a
   plus icon, and its background fades to black.
7. In the grid, the plus button opens a new tab and the search sheet grows out of the plus button.
   The left button closes all tabs after an alert asks. The check mark returns to the page it came
   from. A press on a card opens that tab. Each of these is a shared element transition.
8. A card has the aspect ratio of the device's current layout.
9. The app follows the Paper design system, and the code has a design system.
10. Controls for features that are not built yet are on screen and do nothing. `TODO.md` lists them.

These come from the second request. `[confirmed]` Nathan Schroeder, 2026-11-25.

11. The layer behind an open sheet is darker, so the sheet stands apart from the page. It was
    first asked for with a blur; the third request removed the blur.
12. Icons are SF Symbols.
13. Private tabs and regular tabs are a pager: a swipe goes between them, and a press on the other
    segment makes the same transition.
14. An icon beside text is aligned to the text by eye, for example the lock beside the address.
15. The search sheet has no site tiles. A recent entry that is a page shows the site's icon; one
    that is a search shows the search symbol.
16. Transitions follow "4 principles of transition" (Jakub Antalik, Interfaces issue 16).

These come from the request of 2026-11-26. `[confirmed]` Nathan Schroeder, 2026-11-26.

17. Words typed in the field, with spaces, open a Google search. The field is not for an address
    only.
18. While the field holds text, its trailing control is a clear button in place of the microphone.
19. A sheet's content stays clear of the side safe areas, for example the status rail of the folded
    iPhone Duo. The sheet keeps its box, and its content is inset.
20. The control above the tab grid has padding between it and the top of the screen on every
    device.
21. Each of the two cards in the tabs button has a shadow, so a white snapshot can be seen over a
    white page.
22. A bar surface changes colour by a fade over its whole shape. No edge of a colour moves across
    it.

## Design system

The Paper page "Browser Design System" (Tailwind neutral, Inter, v0.1) gives a palette, eight
semantic roles, five type sizes, six radii and seven spacing steps. `[observed]` Paper file.

- `app.forma` holds the palette, the roles, the radii and the spacing as tokens. A view names a
  token (`color="color.text"`), not a value.
- `design.contract` holds type, motion and surface styles. A view takes one with `class=`.
- An icon is a token in `app.forma` (`icon.lock`): an SF Symbol on Apple (requirement 12), and the
  Paper file's own path as an SVG on every other host. `tools/icons.py` writes the tokens and the
  SVG files. `icons.contract` draws one by name, sized as a font size.
- `assets/fonts/InterVariable.ttf` is Inter, under the SIL Open Font License.

*Agent decision.* Every colour token is `scheme=fixed`. The design has a light scheme only. A dark
theme needs a design first (`TODO.md`).

*Agent decision.* An element takes one `class`, so a style that needs two jobs is one combined style
(`BarGrow` is glass and a spring). `[observed]` The compiler refuses a second `class`.

### Optical alignment

A row centres an icon on its text's line box. For Inter that centre is the middle of the capital
letters, so an icon beside a capitalised label (a page menu row) needs no change. Lowercase letters
sit lower: the middle of the x-height is about 0.09 em below the line's centre, 1.5 points at
17-point type. So an icon beside lowercase text (the lock beside the address) moves down 1 point
(`BesideLowercase`). `[observed]` At three pixels a point on the simulator, the lock's base then
sits on the address's baseline and its top is between the x-height and the capitals.

## Motion

Motion follows "4 principles of transition" (requirement 16). The values are in `design.contract`.

| Principle | Here |
| --- | --- |
| Duration follows size | An icon or a label takes 150 to 220 ms. A bar surface takes a spring that settles in about 400 ms. A page's snapshot, the largest thing that moves, takes the slowest spring. |
| An entrance is longer than its exit | A picture blurs in over 220 ms and out over 150 ms. Sheet content enters over 300 ms and leaves over 120 ms. The scrim enters over 300 ms and leaves over 200 ms. A surface grows on `-exact-spring(300, 30, 1)` and returns on the stiffer `-exact-spring(420, 41, 1)`. |
| Entrances and exits ease out | Entrances use `cubic-bezier(0.22, 1, 0.36, 1)`, the article's smooth ease-out. Exits use `ease-out`. |
| A morph takes a subtle spring | The growing spring has a damping ratio of 0.87, a small bounce. The returning spring has none, and the page's spring (damping ratio 0.93) has almost none. |
| Scale follows size, inversely | A picture, the smallest thing, scales from 0.9. Sheet content does not scale. |
| Movement shows where a thing comes from | Sheet content rises 8 points. A sheet grows out of the pill that opens it, and a page shrinks into its own card. |

## One spring

Each bar surface is one `column` with the style `BarGrow` or `BarSettle`. Its `left`, `bottom`,
`width`, `height` and `border-radius` are derives of `screen` and `sheet`. Both styles carry an
`-exact-layout-transition` spring, so a change of the laid-out box moves on that spring.

A surface takes `BarGrow` while a sheet is open and `BarSettle` otherwise, so all three surfaces
always share one spring.

The side buttons leave the screen by layout, not by a transform: their `left` becomes a value
outside the screen. So the sheet's growth and the buttons' exit are the same transition with the
same value (requirement 4).

`[observed]` On the iPhone 17 Pro Max simulator (iOS 27.2) the three surfaces move together and the
sheet settles after a small overshoot.

## Liquid Glass

`BarGrow` and `BarSettle` set `backgroundMaterial="glass"`: `UIGlassEffect` on iOS 26 and later. Each state
tints the glass with a token: `glass.sheet`, `glass.control`, `glass.accent`. In the browse state
the glass has no tint.

*Agent decision.* The Paper screens draw the browse bar as white at 18% with white text and icons.
On real glass the text and icons use the platform label colour (`-exact-label`). `[observed]` On the
simulator the glass stays light over a white page and over a dark page, so white content cannot be
read over a white page, and label-coloured content can be read over both.

*Agent decision.* On the tab grid the design draws the plus button black and the side buttons
`neutral-200`. A tint alone left the glass lighter than that, so a flat fill (`BarFill`) fades in
over the glass at 0.8 and 0.7.

The fill is larger than any surface, and each surface clips it to its own shape (requirement 22).
`[observed]` A surface's spring moves and resizes the surface only. A child keeps its final layout
while the surface moves, so a fill of the surface's own size showed a lighter band with a moving
edge as the pill shrank into the plus button, and a square inside each round side button on the way
back. `[observed]` A `background-color` on the glass surface itself is not an alternative: on the
simulator it left the side buttons white.

*Agent decision.* The tint alphas (0.78, 0.7, 0.88) and the fill alphas are a judgment. The design draws these surfaces
as flat fills (`neutral-100`, `neutral-200`, `neutral-900`); the alphas let the page show through.

## Tabs button

The tabs button shows the two most recent tabs as two small cards (requirement 5). Each card has a
soft drop shadow and a hairline ring (requirement 21): the style `Thumbnail`, with the colours
`thumbnail.shadow` and `thumbnail.ring`. The card casts the shadow and a face inside it clips the
snapshot, because a box that clips also clips its own shadow.

`[observed]` On the iOS host a `box-shadow` is not drawn for a box inside an ancestor that has a
`filter`, and `blur(0px)` counts. The same card showed its shadow outside `PictureIn` and none
inside it. So `PictureIn` has `filter="none"` at rest. The transition to and from `blur(6px)` still
runs.

*Agent decision.* The shadow values (black at 32%, 3 points of blur; a ring of black at 22%) are a
judgment. `[observed]` Both cards can be seen over a white page and over a dark page.

## Bar geometry

Values are from the Paper screens. `[observed]`

| Layout | Bar | Sheet |
| --- | --- | --- |
| Compact (width under 600: iPhone, folded Duo) | 12 from each side, 34 from the bottom, 48 high | Full width, attached to the bottom, radius 44 |
| Regular (unfolded Duo) | 381 wide, centred, 32 (portrait) or 24 (landscape) from the bottom | 401 wide, centred, radius 32 |
| Book fold (half-open Duo) | As regular, centred in the trailing half | As regular, in the trailing half |

*Agent decision.* A compact sheet reaches 44 points below the screen. Its four corners then share
one radius, and the bottom corners are never on screen.

*Agent decision.* The compact search sheet is `min(304 + keyboard, height - 118)` high and the
compact page menu is `min(640, height - 74)`. Both give the Paper heights on the iPhone frame
(640) and on the folded frame (560 and 604).

## Sheets

The search sheet and the page menu are children of the middle surface. Their content rises and
fades in as the surface grows, and fades out as it shrinks.

The search sheet lists up to four recent entries (requirement 15). `recents` keeps what the person
entered: an address, or the words of a search. `icons` keeps each site's icon address from
`FrameNavigation.icons`; a site not seen yet answers its `/favicon.ico`.

*Agent decision.* A private tab adds nothing to `recents` or `icons`.

The field's keyboard is the web search keyboard (`inputmode="search"`), which has a space key and a
period key (requirement 17). `[observed]` On the simulator the URL keyboard (`inputmode="url"`) has
no space key, so a person could not type the words of a search.

The field's trailing control is the microphone while the field is empty and a clear button while it
holds text (requirement 18). The two pictures trade places as the bar's pictures do (`PictureIn`,
`PictureOut`), and only the one that shows takes a press. A press on the clear button empties the
field and keeps the keyboard up. A sheet for the current page opens with the page's address in the
field, so it opens with the clear button.

### Sheet insets

A sheet's surface keeps its box, and its content stays clear of the side safe areas (requirement
19). `sheetInsetLeft` and `sheetInsetRight` are how far each side safe area reaches into the sheet's
box. They come from the sheet's geometry, so they are 0 where the sheet is clear of the safe area,
as the centred regular sheet is. The content column sits between the two insets and keeps its own
16-point padding. The address (see "Address flight") takes its place in an open sheet from the same
insets, so it stays centred in the page menu's top row and on the field's text in the search sheet.

`[observed]` The folded iPhone Duo simulator reports `safeAreaRight` 84: a status rail with the
clock is on the trailing side. Before this change the field's trailing control and the page menu's
Copy Link and Reload buttons were under the rail.

### Scrim

A layer between the page and an open sheet darkens the page (`scrim.tint`, black at 32%). It fades
with the sheet. A press on it closes the sheet.

The first version also blurred the page (`backgroundMaterial="ultra-thin-dark"`). The blur was too
strong, so the layer is a dark overlay only. `[confirmed]` Nathan Schroeder, 2026-11-25.

*Agent decision.* The 32% value is a judgment.

## Address flight

The address is one `text` in the middle surface through every state. Its parent row changes place
with the state: centred in the pill, centred in the page menu's top row, and at the field's text in
the search sheet. The text carries the bar's spring, so it flies to its new place. In the search
sheet it blurs and fades out as the field, which holds the full address, fades in.

`[observed]` A `filter` animates as a transition and not in `keyframes`. So content that blurs and
fades stays mounted and trades places by transition (`PictureIn` and `PictureOut`, `AddressIn` and
`AddressOut`).

## Pages

Each tab is one `iframe` in the `persist:browser` partition. A tab's `src` never changes after the
tab is made, so the frame keeps its page; `navigate` moves it.

`[observed]` Hiding the front page's frame (`display="none"`) while the grid shows delayed the
return to the page by more than three seconds on the simulator. The front tab's frame stays shown
under the grid. Frames of the other tabs are hidden.

### Page insets

Exact pins a frame's content insets to zero. `modules/apple/PageHatch.swift` gives a page a
browser's insets instead:

- The scroll view follows the safe area, so a page starts below the status bar and scrolls under
  it. `[observed]` A page that declares `viewport-fit=cover` still reaches under the status bar.
- `WKWebView.obscuredContentInsets` (iOS 26) names the status bar and the browser's bar as covered.
  WebKit ends the page's layout viewport at those lines, so a fixed banner or a sticky header
  shows clear of them, and the page still scrolls under both.
- The scroll view's bottom inset lets the last line of a page scroll above the bar.

The Contract gives the hatch the numbers as data words on the frame: `data-top` and `data-home`
are the safe area, and `data-bar` is the bar's top plus 8 points, from the bottom of the screen.
`[observed]` On the simulator, expo.dev's fixed cookie banner sits above the bar and the page's
content passes under the bar.

*Agent decision.* Before iOS 26 only the scroll insets apply, so fixed content stays under the bar.

## Tab flights

A page and its card share the name `page-<id>` (`sharedElement`). When the screen changes, one
holder is destroyed and the other is created in the same commit, and the new one flies from the old
one's place on the `Fly` spring.

- To the grid: the tabs button first asks for a snapshot of the page (`captureScreenshot`). The
  grid shows when the snapshot arrives, or after 300 ms. The card's image is that snapshot, so it
  flies from the full screen into its card.
- From the grid: a snapshot image covers the page while it flies out of its card. After 700 ms the
  image becomes transparent and the live page is under it. The grid stays behind the flight and
  then fades.

`[observed]` On the simulator the snapshot arrived about 50 ms after the press.

## Tab pager

Private tabs and regular tabs are two pages of one horizontal `scroll` with mandatory snap
(requirement 13). The private page is on the left, as its segment is in the control. A swipe pages
between them. A press on a segment calls `scrollIntoView` with `behavior="smooth"`, so a press and
a swipe are the same motion. The control's white thumb is a scroll-driven animation on the pager's
timeline: one page of scroll moves it one segment.

*Agent decision.* The second request asks for the pager, so private tabs now exist. A private
tab's frame uses the partition `private`, which has no `persist:` prefix. The plus button makes a
tab of the kind the pager shows, and the close-all button closes the tabs of that kind. The private
page has no design, so it looks like the regular page and shows "No private tabs" when empty.

## Tab grid

*Agent decision.* A card's preview has the screen's aspect ratio (requirement 8), so a snapshot
lands in it with no crop. The Paper screens draw cards 268 points high (216 on the folded Duo);
with the screen's ratio a card on the iPhone frame is 472 points high.

The grid has 2 columns in a compact layout, 3 in regular portrait and 4 in regular landscape.
`[observed]` Paper screens. Across a book fold the grid is two columns on each side of the hinge.

The control above the grid is 4 points below the top inset, and the grid starts 28 points below the
control. The top inset is the top safe area, and at least 16 points (requirement 20).
`[observed]` The iPhone Duo simulator reports `safeAreaTop` 0 folded and unfolded: its status rail
is on the trailing side. Before this change the control was 4 points from the top edge there.

*Agent decision.* The 16-point value is a judgment. It is the design system's `space-4`.

## Not done

`TODO.md` lists the controls that do nothing yet and the behavior that is missing.
