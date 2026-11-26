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

/// When the hatches connect (`window.isNew`), and when its size or safe area changes.
func windowHatch(_ window: ExactWindow) {
    #if os(iOS)
    guard window.isNew, let root = window.window?.rootViewController else { return }
    if #available(iOS 27.1, *) {
        // UIKit asks the window's root view controller, whose class is Exact's and has no setting
        // for this. The answer is added to that class; a plain UIViewController is left alone.
        let kind: AnyClass = type(of: root)
        guard kind != UIViewController.self else { return }
        let disabled: @convention(block) (AnyObject) -> Int = { _ in UIVerticalBarBehavior.disabled.rawValue }
        class_replaceMethod(kind, #selector(getter: UIViewController.preferredVerticalBarBehavior), imp_implementationWithBlock(disabled), "q@:")
        root.setNeedsUpdateOfVerticalBarConfiguration()
    }
    #endif
}

/// The session is leaving the window: the class keeps its answer for the life of the app.
func windowHatchEnded(_ window: ExactWindow) {
}
