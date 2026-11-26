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
23. The search sheet grows out of the pill at once and without a stop, as the page menu does.
24. A press on the address in the page menu turns the menu into the search sheet. The address
    moves to the field, Back and Forward leave to the leading side, and Copy Link and Reload give
    way to the field's own control.
25. A pull down closes a sheet. A press beside the sheet still closes it.
26. The bar is over the page at every moment of the flight between a page and its card.
27. A page shows under the bar as it scrolls, also when the page has a fixed bar or a toast at its
    bottom edge.

These come from the second request of 2026-11-26. `[confirmed]` Nathan Schroeder, 2026-11-26.

28. A page is the full width of the screen on the iPhone Duo. The Duo's vertical bar is off.
29. Where the sheet is narrower than the screen, the side buttons leave downward when a sheet
    opens. Where the sheet is the full width, they leave to the sides.
30. Every sheet is attached to the bottom of the screen, also on the unfolded Duo. Its content
    scrolls. A pull up makes it as tall as the screen allows. What takes focus stays above the
    keyboard.
31. A change of the screen's size (a fold, an unfold, a turn) closes an open sheet.

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
| Duration follows size | An icon or a label takes 150 to 220 ms. A bar surface takes a spring that settles in about 400 ms. A page's snapshot, the largest thing that moves, takes 450 ms. |
| An entrance is longer than its exit | A picture blurs in over 220 ms and out over 150 ms. Sheet content enters over 300 ms and leaves over 120 ms. The scrim enters over 300 ms and leaves over 200 ms. A surface grows on `-exact-spring(300, 30, 1)` and returns on the stiffer `-exact-spring(420, 41, 1)`. |
| Entrances and exits ease out | Entrances use `cubic-bezier(0.22, 1, 0.36, 1)`, the article's smooth ease-out. Exits use `ease-out`. |
| A morph takes a subtle spring | The growing spring has a damping ratio of 0.87, a small bounce. The returning spring has none. |
| Scale follows size, inversely | A picture, the smallest thing, scales from 0.9. Sheet content does not scale. |
| Movement shows where a thing comes from | Sheet content rises 8 points. A sheet grows out of the pill that opens it, and a page shrinks into its own card. |

## One spring

Each bar surface is one `column` with the style `BarGrow` or `BarSettle`. Its `left`, `bottom`,
`width`, `height` and `border-radius` are derives of `screen`, `sheet` and `sheetTall`. Both styles carry an
`-exact-layout-transition` spring, so a change of the laid-out box moves on that spring.

A surface takes `BarGrow` while a sheet is open and `BarSettle` otherwise, so all three surfaces
always share one spring.

The side buttons leave the screen by layout, not by a transform. Where the sheet is the full
width, their `left` becomes a value past the screen's sides. Where the sheet is narrower than the
screen (the regular layout), their `bottom` becomes a value below the screen, so they do not cross
the whole width (requirement 29). So the sheet's growth and the buttons' exit are the same
transition with the same value (requirement 4).

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
| Regular (unfolded Duo) | 381 wide, centred, 32 (portrait) or 24 (landscape) from the bottom | 401 wide, centred, attached to the bottom, radius 32 |
| Book fold (half-open Duo) | As regular, centred in the trailing half | As regular, in the trailing half |

*Agent decision.* A sheet reaches 44 points below the screen. Its four corners then share one
radius, and the bottom corners are never on screen.

*Agent decision.* At rest the search sheet shows `min(304 + keyboard, height - 118)` points and
the page menu shows `min(640, height - 74)`, and neither shows more than the full height (see
"Sheet height"). Both give the Paper heights on the iPhone frame
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

### Sheet focus

The search field takes focus 250 ms after the sheet starts to grow (the task `focusField`), when
the surface's spring is almost at rest (requirement 23). The field has no `autofocus`.

`[observed]` When the press that opened the sheet also focused the field, the simulator drew no
frame of the spring until the keyboard was ready: for 5 frames at 30 frames a second, and for 13
frames the first time the keyboard came up, the pill's glass was not drawn and nothing moved. Then
the sheet appeared together with the keyboard. With the focus 100 ms after the press the spring
stopped part of the way. With 250 ms the sheet grows as the page menu does, and the keyboard
follows it.

`[observed]` In the first frame after a press that opens either sheet, the pill's glass is not
drawn. The frame is there with one class and with one tint on the surface, so it is not a style
of this app. It is not fixed.

### Keyboard height

A sheet's height depends on the keyboard's height: the search sheet at rest is tall enough for the
field and the recent entries above the keyboard. The focus comes
after the sheet grows, so the sheet needs the height before the keyboard is up. `keyboards` keeps
the height last seen at each screen size, as "WxH height", and `keyboard` reads it. Before the
first time at a screen size the height is 336 points, the Paper iPhone frame's.

`[observed]` On the unfolded iPhone Duo, with 336 points for a keyboard that is lower, the sheet
grew to one place and then moved down when the keyboard came. `[observed]` On the folded Duo the
app kept "466x678 265" and read 265 at the next launch. The unfolded pose was not seen again with
the kept height: the simulator stopped showing its software keyboard.

### Sheet field

The top row of both sheets is one row, `SheetField` (requirement 24). In the page menu it holds
Back, Forward, the address, Copy Link and Reload. In the search sheet it is the field. A press on
the address in the page menu sets `sheet` to "search": the row stays, so its parts change place by
transition and nothing is cut.

- Back and Forward move 32 points to the leading side as they fade (`LeadingOut`).
- Copy Link and Reload blur out, and the field's trailing control blurs in, as the bar's pictures
  do (`TrailingOut`, `TrailingIn`).
- The row takes the field's ring (`FieldEditing`).
- The address flies to the field's text (see "Address flight").
- The menu's tiles and rows leave, and the recent entries rise in below the row.

`SheetShell` holds the row and what is below it, and fades both out when the sheet closes.

### Sheet height

A sheet is a panel as tall as the screen allows: its top is 8 points below the status bar. It is
attached to the bottom of the screen in every layout (requirement 30). At rest only its top part is
on the screen: the page menu's content, or the search field and the recent entries above the
keyboard. `sheetTall` says that all of it is on the screen. On a short screen the resting height is
already the full height.

What the sheet holds ends at the bottom of the screen, or at the keyboard's top, so a recent entry
is never under the keyboard. It scrolls where the sheet shows all of itself and cannot grow.

*Agent decision.* The first design drew the regular search sheet 320 points high above the
keyboard. It is now the compact sheet at a width of 401 points.

### Sheet pull

A finger that pulls an open sheet moves the middle surface with it (requirements 25 and 30): `pull`
is the distance, and the surface takes it as a `translate` with the transition off. The sheet goes
down without a limit and up as far as its full height. When the finger lifts, `pull` returns to 0
and the surface's spring takes the sheet to its place:

- 64 points up (or half of the way it can grow, if that is less), or a flick up: the sheet becomes
  tall. A flick up wins over a distance pulled down.
- 96 points down, or a flick down: a tall sheet returns to its resting height, and a resting sheet
  closes.

Where the content scrolls, a pull on it scrolls it. A pull 64 points down past the content's top
takes the same step down, once. A pull on the top row moves the sheet, except on the text field.

A change of the screen's size (a fold, an unfold, a turn) closes an open sheet (requirement 31):
the root's `resize` runs `screenResized`. The sheet's size and place belong to the old screen.

The surface has `touch-action="none"`, so the browser leaves it the drag on the web host.

`[observed]` On the simulator a pull of 50 points returned and a pull of 160 points closed the
sheet. `[observed]` A pull that starts on the text field does not move the sheet: the field keeps
its own drags. A flick (`swipe` with `swipe-direction="down"`) on the field did not close the
sheet either, so there is none.

`[observed]` Exact's own drag for a sheet's height (`heightDragFor`) was tried first. On iOS it
does not start on a button, and the sheets are made of buttons, so the sheet could be dragged only
from the gaps between them. A `pan` hears a drag that starts on a button.

*Agent decision.* The 64 and 96 points and the 600 points a second are a judgment.

### Scrim

A layer between the page and an open sheet darkens the page (`scrim.tint`, black at 32%). It fades
with the sheet. A press on it closes the sheet.

The first version also blurred the page (`backgroundMaterial="ultra-thin-dark"`). The blur was too
strong, so the layer is a dark overlay only. `[confirmed]` Nathan Schroeder, 2026-11-25.

*Agent decision.* The 32% value is a judgment.

## Address flight

The address is one `text` in the middle surface through every state, in a holder. The holder's
parent row changes place with the state: centred in the pill, centred in the page menu's top row,
and at the field's text in the search sheet. The holder carries the bar's spring, so the address
flies to its new place. On the way to the search field the holder fades after 130 ms
(`AddressAway`), and the field's own text, which is the full address, fades in after 220 ms
(`FieldText`): the address is seen to arrive before the field's text takes its place. For the tab
grid the text itself blurs out as the plus blurs in.

`[observed]` A `filter` animates as a transition and not in `keyframes`. So content that blurs and
fades stays mounted and trades places by transition (`PictureIn` and `PictureOut`, `AddressIn` and
`AddressOut`).

## Vertical bar

On the iPhone Duo UIKit puts the status bar in a vertical bar at one side of the screen, and the
safe area keeps that side clear: the simulator reported `safeAreaRight` 84 and `safeAreaTop` 0. A
page then lost that width. The app turns the vertical bar off (requirement 28): the status bar is
at the top again, and a page is the full width.

UIKit asks a view controller for `preferredVerticalBarBehavior` (iOS 27.1), and
`UIVerticalBarBehavior.disabled` turns the bar off. It asks the window's root view controller, or
the controller of the nearest presentation. Exact owns the root controller and has no setting for
this, and UIKit owns an alert's controller. So `modules/apple/WindowHatch.swift` replaces
`UIViewController`'s own answer, once, when the window connects: every controller in the app
answers `disabled`.

`[observed]` With the answer on the root controller's class only, the vertical bar came back while
the Close All alert showed, and went away again after it. With the answer on `UIViewController`
the status bar stays at the top through the alert.

*Agent decision.* UIKit's header says to turn the vertical bar off for a layout that horizontal bars
serve better, and to keep the choice stable. The app turns it off for the whole app, by the request
(requirement 28).

`[observed]` With the bar off the folded Duo simulator reports `safeAreaTop` 82 and no side safe
area. The sheet insets (see "Sheet insets") are then 0 there; they still apply wherever a side safe
area reaches into a sheet.

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

A page shows under the bar on every page (requirement 27). `[observed]` When a page has a fixed
bar along its whole bottom edge, WebKit paints that bar's colour over the covered strip below it:
a `WKColorExtensionView` in the scroll view, as tall as the bottom inset. The page then did not
show under the browser's bar. A fixed toast that does not reach both sides did not cause it.
`[observed]` WebKit's symbols have no public switch for the strip; the only setter is the private
`_setShouldSuppressTopColorExtensionView:`.

*Agent decision.* The hatch gives the strip's view an empty mask when WebKit adds it. It finds the
view by its class name and by its place in the lower half of the web view, and calls no private
method. `[observed]` On the simulator the strip was gone on a first load, after a navigation and
in a new tab (a page with a fixed bar along its bottom edge). The view at the top edge is left, so a
fixed header's colour still fills the status bar. If
WebKit renames the class, the strip shows again and nothing else changes. The other choices were to
keep the strip, as Safari does, or to remove the bottom inset, which puts a page's fixed bottom
content under the bar again.

## Tab flights

A page's snapshot flies between the screen and its card under the bar, so the bar is over it at
every moment (requirement 26). The snapshot is one image in the root, after the grid and before the
bar's surfaces. It is as large as the screen and moves by a transform from its top left corner: a
card's preview has the screen's aspect ratio, so one scale and one offset put it exactly on the
card. `flight` says where it is, and the style `Fly` moves it over 450 ms on the smooth ease-out.
`[observed]` On the web host `verify` reported the spring on this style's transition as skipped,
so `Fly` is not a spring.

`flyX`, `flyY` and `flyScale` return to the whole screen when a flight ends, so the next snapshot
starts over its page. A press on the pill or the chevron does nothing while the tabs button waits
for the snapshot: `[observed]` on the web host that press opened a sheet over the grid that was
about to show, and an address entered there left the grid over the page.

- To the grid: the tabs button asks for a snapshot of the page (`captureScreenshot`). The snapshot
  is placed over its page ("cover") and the grid shows when its picture is drawn, or after 300 ms
  ("drop"). One frame later the card's place is read with `frame()`, and the snapshot flies to it
  ("down").
- From the grid: the card's place is read at the press and the snapshot is placed on it ("lift").
  One frame later the page takes the grid's place under it, and the snapshot flies to the screen
  ("up"). The grid stays behind the flight and then fades.

700 ms after a flight starts the snapshot is removed. The card's own picture, or the live page, is
under it.

`[observed]` The first version used a shared element (`sharedElement`): the page and its card had
one name, and the host flew the new holder from the old one's place. The iOS host lifts a flying
element into a layer above every sibling of the app's root
(`host/apple/Sources/ExactFlights/IOS/FlightsIOS.swift`, `setPaintForeground()`), and no `z-index`
goes above that layer. So the flying page covered the bar until it landed.

`[observed]` Without the wait for the picture, the grid showed for one frame before the new
snapshot was drawn over it.

*Agent decision.* The snapshot's bottom corners take the card's radius at the card's size, and the
value changes at once when a flight starts: a radius does not animate.

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
`[observed]` With its vertical bar on, the iPhone Duo simulator reported `safeAreaTop` 0 folded and
unfolded, and the control was 4 points from the top edge there. The vertical bar is off now (see
"Vertical bar"), and the minimum stays for any device with no top safe area.

*Agent decision.* The 16-point value is a judgment. It is the design system's `space-4`.

## Not done

`TODO.md` lists the controls that do nothing yet and the behavior that is missing.
