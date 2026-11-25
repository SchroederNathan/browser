// The `page` hatch on Apple: a tab's `iframe` hands this code its WKWebView.
//
// A page fills the screen, under the status bar and the browser's bar. Exact pins a frame's
// insets to zero, which suits a frame inside a page of the app. A browser's page needs more:
//
// - Its content starts below the status bar and scrolls under it, as in Safari.
// - The bar covers the bottom of the page. The page's own layout must end above the bar, so a
//   fixed banner or a sticky footer shows above it, while the page still scrolls under the bar.
//
// @ref LLP 0001#page-insets
#if os(macOS)
import AppKit
#else
import UIKit
#endif
import WebKit

/// Built (`element.isNew`) and changed (a data word moved): configure the web view Exact made.
func pageHatch(_ element: ExactElement) {
    #if os(iOS)
    guard let web = element.platform as? WKWebView else { return }
    let scroll = web.scrollView
    // The safe area becomes the scroll view's inset.
    scroll.contentInsetAdjustmentBehavior = .always
    // Behind the page, under the status bar, WebKit shows the page's own colour.
    web.underPageBackgroundColor = nil
    // The Contract gives the screen's facts as data words, in points: `data-top` and `data-home`
    // are the safe area's top and bottom, and `data-bar` is how far the bar's top is from the
    // bottom of the screen.
    func points(_ word: String?) -> CGFloat { CGFloat(Double(word ?? "") ?? 0) }
    let top = points(element.data[.top]), home = points(element.data[.home]), bar = points(element.data[.bar])
    // The page scrolls until its last line is above the bar. The safe area is already inset.
    let extra = max(0, bar - home)
    scroll.contentInset.bottom = extra
    scroll.verticalScrollIndicatorInsets.bottom = extra
    if #available(iOS 26.0, *) {
        // The layout viewport is between the status bar and the bar: WebKit keeps fixed and
        // sticky content inside it, and the page still scrolls under both.
        web.obscuredContentInsets = UIEdgeInsets(top: top, left: 0, bottom: bar, right: 0)
    }
    if element.isNew { element.diagnostics.log("page insets follow the safe area and the bar") }
    #endif
}

/// The node is leaving, its view still there: nothing was added to take back.
func pageHatchEnded(_ element: ExactElement) {
}
