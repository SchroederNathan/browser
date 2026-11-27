# Native Page Zoom verification

These captures are from the PR simulator build (`dfc1d87`) on Expo-hosted iOS 27.2 simulators, not from the web renderer.

| Run | What the test observed |
| --- | --- |
| [iPhone Duo](https://expo.dev/accounts/exponathan/projects/browser/workflows/01a21eea-16d8-7a27-b8e3-c9323232ab6a) | Page Menu at 100%, 125%, 150%, back to 125%; Site Settings resets the value to 100%. The three PNGs are captures from this run. |
| [iPhone 18 Pro](https://expo.dev/accounts/exponathan/projects/browser/workflows/01a21eee-aa04-79d4-a846-3c4d8747452b) | Same sequence. `page-zoom.mp4` is the simulator recording, trimmed and resized for playback. |
| [Private tabs](https://expo.dev/accounts/exponathan/projects/browser/workflows/01a21ef0-d09e-7eb6-a1b8-e2203e019d05) | With regular zoom at 125%, a private tab on the same site starts at 100%. After setting it to 75% and closing the last private tab, a new private tab starts at 100%. |
| [App relaunch](https://expo.dev/accounts/exponathan/projects/browser/workflows/01a21eff-c84d-72b6-81d1-881af2bcb72d) | After stopping and relaunching the app, the regular site's Page Menu still reads 125%. Resetting it returns the menu to 100%. |
