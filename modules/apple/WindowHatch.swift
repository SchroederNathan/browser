// The window hatch on Apple: the window the app shows in.
//
// The iPhone Duo puts the status bar in a vertical bar at one side of the screen, and the safe
// area keeps that side clear. A browser's page is the full width of the screen, so this app turns
// the vertical bar off: the status bar goes back to the top (`UIVerticalBarBehavior.disabled`,
// iOS 27.1).
//
// @ref LLP 0001#vertical-bar
#if os(macOS)
import AppKit
#else
import UIKit
#endif

#if os(iOS)
private var verticalBarIsOff = false
#endif

/// When the hatches connect (`window.isNew`), and when its size or safe area changes.
func windowHatch(_ window: ExactWindow) {
    #if os(iOS)
    // Once: every call tries until the window has its root view controller.
    guard !verticalBarIsOff, let root = window.window?.rootViewController else { return }
    if #available(iOS 27.1, *) {
        // UIKit asks the root view controller, or the controller of the nearest presentation: an
        // alert brought the vertical bar back while it showed. Exact owns the root controller and
        // UIKit owns an alert's, so the answer replaces UIViewController's own, for every one.
        let disabled: @convention(block) (AnyObject) -> Int = { _ in UIVerticalBarBehavior.disabled.rawValue }
        class_replaceMethod(UIViewController.self, #selector(getter: UIViewController.preferredVerticalBarBehavior), imp_implementationWithBlock(disabled), "q@:")
        root.setNeedsUpdateOfVerticalBarConfiguration()
        verticalBarIsOff = true
    }
    #endif
}

/// The session is leaving the window: UIViewController keeps the answer for the life of the app.
func windowHatchEnded(_ window: ExactWindow) {
}
