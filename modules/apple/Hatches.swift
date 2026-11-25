// Exact Browser's native module on Apple: its access hatches. Written by `exact hatch`; yours from here.
// A hatch is handed the platform object Exact built (a view, a window), configures it, and changes Contract
// state only by acting on authored nodes: click(), focus(), blur(), input(text). The app works without it
// (EXACT_HATCHES=off in a development build). `perf hatches`, `state` and `logs` show what each one did.
#if os(macOS)
import AppKit
#else
import UIKit
#endif

final class AppHatches: ExactModule {
    override func element(_ element: ExactElement) {
        if element.hatch == .page { pageHatch(element) }
        // exact:element (exact hatch adds a word's line above this one)
    }

    override func elementEnded(_ element: ExactElement) {
        if element.hatch == .page { pageHatchEnded(element) }
        // exact:elementEnded
    }

    override func app(_ app: ExactApp) {
        // exact:app
    }

    override func appEnded(_ app: ExactApp) {
        // exact:appEnded
    }

    override func window(_ window: ExactWindow) {
        // exact:window
    }

    override func windowEnded(_ window: ExactWindow) {
        // exact:windowEnded
    }
}

let exactModule: ExactModule.Type = AppHatches.self
