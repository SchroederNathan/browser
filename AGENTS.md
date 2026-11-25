<!-- exact:begin (exact new writes this block; bun exact.mjs update rewrites it) -->
# exact-browser: an Exact app

Run `bun exact.mjs --help` first to create `.exact/checkout`; set `EXACT=<checkout>` if needed.

`app.contract` is the view, `app.ts` the data module, `app.test.contract` the tests, `app.json`
the manifest: set `app.name` and `app.id` before building. The app uses Exact at
`.exact/checkout` by path (`EXACT` overrides it).

Start from the nearest pattern: `bun exact.mjs
pattern` lists them and `pattern <name>` writes one, tested. .exact/checkout/docs/start-here-site.md (a site) or
.exact/checkout/docs/start-here.md is the only required reading. `bun exact.mjs contract vocab <name>` answers a
name (none: the card); `bun exact.mjs docs <heading words>` a guide's
section. Run `bun exact.mjs verify` when the features work, and `verify ios|android` at the end for a
phone app. When an iPhone app is ready to try, run `bun exact.mjs share` and send its link;
repeat for each change the person should see. `bun exact.mjs help` lists the verbs, including
app.json's `"commands"`.
`bun exact.mjs update` refreshes files. Native verbs (`ios`, `mac`, `linux`, `android`, `windows`)
name their platform in app.json on first use and build in a generated workspace;
`update --without <platform>` stops shipping it.
`bun .exact/checkout/scripts/exact.mjs setup --check` names what a native build lacks (`--platform ios --device` for a phone's: `share`, `ios --device`).

Generated, so don't edit: `exact.mjs` and this block.

## Feedback (required)

When a doc was wrong or missing, a workaround was needed, something took several tries or a
command confused you, record it: `bun exact.mjs feedback note "<what happened>"`. It attaches
exact2's commit and the last exit code, never output or code. `bun exact.mjs feedback status` says
whether notes are sent and whether to keep a diary; under `never`, skip all of this.
<!-- exact:end -->

## Design system

The design source is the Paper file "iOS Browser MVP". Its tokens are in `app.forma`, and its type,
motion and surface styles are in `design.contract`. Name a token or a style; do not write a colour,
a radius, a duration or a spring value in a view. Icons are SF Symbols: add one in `tools/icons.py`
and run `python3 tools/icons.py`, which writes the icon tokens of `app.forma` and `assets/icons`.

## Unbuilt controls

`TODO.md` lists the controls that are on screen but do nothing yet. When you add one, or build one,
change `TODO.md` in the same commit.

## Design decisions (LLP)

Design decisions are [LLP](https://github.com/ccheever/llp) documents in `llp/`. Start at
`llp/0000-exact-browser.explainer.md`. Read the document that covers an area before you change it.
A comment `@ref LLP NNNN#section` points from code to the decision it implements. When a decision
changes, change its document in the same commit.
