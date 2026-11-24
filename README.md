# Exact Browser

A mobile web browser built with [Exact](https://github.com/expo/exact).

## Develop

Set `EXACT` to an Exact checkout at the commit in `eas.json` (`EXACT_REF`), then:

```sh
bun exact.mjs web          # web dev loop
bun exact.mjs ios --run    # iOS Simulator
bun exact.mjs test web     # tests
```

## Release

Each push to `main` builds the iOS app on EAS and submits it to TestFlight (`.eas/workflows/testflight.yml`).
