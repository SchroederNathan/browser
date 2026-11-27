// Exact Browser's native module on Apple: its access hatches. Written by `exact hatch`; yours from here.
// A hatch is handed the platform object Exact built (a view, a window), configures it, and changes Contract
// state only by acting on authored nodes: click(), focus(), blur(), input(text). The app works without it
// (EXACT_HATCHES=off in a development build). `perf hatches`, `state` and `logs` show what each one did.
#if os(macOS)
import AppKit
#else
import UIKit
import WebKit
#endif

final class AppHatches: ExactModule {
    #if os(iOS)
    private let pinch = TabOverviewPinch()
    #endif

    override func element(_ element: ExactElement) {
        if element.hatch == .page { pageHatch(element) }
        #if os(iOS)
        if element.hatch == .openTabs { pinch.button = element }
        if element.hatch == .pinchStage { pinch.stage = element }
        if element.hatch == .pinchFace, element.data[.overview] == "flight" { pinch.face = element }
        if element.hatch == .pinchTarget {
            if element.data[.overview] == "first" { pinch.target = element }
            else if pinch.target === element { pinch.target = nil }
        }
        if element.hatch == .page { pinch.update(element) }
        #endif
        // exact:element (exact hatch adds a word's line above this one)
    }

    override func elementEnded(_ element: ExactElement) {
        if element.hatch == .page { pageHatchEnded(element) }
        #if os(iOS)
        if pinch.page === element { pinch.detach() }
        if pinch.button === element { pinch.button = nil }
        if pinch.target === element { pinch.target = nil }
        if pinch.face === element { pinch.face = nil }
        #endif
        // exact:elementEnded
    }

    override func app(_ app: ExactApp) {
        // exact:app
    }

    override func appEnded(_ app: ExactApp) {
        // exact:appEnded
    }

    override func window(_ window: ExactWindow) {
        windowHatch(window)
        // exact:window
    }

    override func windowEnded(_ window: ExactWindow) {
        windowHatchEnded(window)
        // exact:windowEnded
    }
}

let exactModule: ExactModule.Type = AppHatches.self

#if os(iOS)
private final class TabOverviewPinch: NSObject, UIGestureRecognizerDelegate {
    weak var button: ExactElement?
    weak var stage: ExactElement?
    weak var target: ExactElement?
    weak var face: ExactElement?
    private var picture: UIView?
    private var faceRect: CGRect?
    private var pageRect = CGRect.zero
    private var startCenter = CGPoint.zero
    private var pivot = CGPoint.zero
    private var startAngle: CGFloat = 0
    private var settling = false
    private(set) weak var page: ExactElement?
    private lazy var gesture: UIPinchGestureRecognizer = {
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(track(_:)))
        gesture.cancelsTouchesInView = false
        gesture.delegate = self
        return gesture
    }()

    func update(_ element: ExactElement) {
        guard element.data[.overview] == "ready", let web = element.platform as? WKWebView else {
            if page === element { detach() }
            return
        }
        guard gesture.view !== web else { return }
        detach()
        page = element
        web.addGestureRecognizer(gesture)
        web.scrollView.pinchGestureRecognizer?.require(toFail: gesture)
        element.owns(recognizer: gesture, "Pinch inward to show tabs")
    }

    func detach() {
        let wasTracking = picture != nil
        resetProjection()
        picture?.removeFromSuperview()
        picture = nil
        settling = false
        gesture.view?.removeGestureRecognizer(gesture)
        page = nil
        if wasTracking { stage?.click() }
    }

    private func resetProjection() {
        guard faceRect != nil else { return }
        stage?.view?.layer.removeAnimation(forKey: "tab-settle")
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        stage?.view?.layer.sublayerTransform = CATransform3DIdentity
        CATransaction.commit()
        faceRect = nil
    }

    private func project(in stage: UIView, center: CGPoint, width: CGFloat, angle: CGFloat, settle: Bool = false, completion: (() -> Void)? = nil) {
        guard let faceRect else { return }
        let anchor = CGPoint(x: stage.bounds.minX + stage.bounds.width * stage.layer.anchorPoint.x, y: stage.bounds.minY + stage.bounds.height * stage.layer.anchorPoint.y)
        let scale = width / faceRect.width
        let placement = CGAffineTransform(translationX: center.x - anchor.x, y: center.y - anchor.y)
            .rotated(by: angle).scaledBy(x: scale, y: scale)
            .translatedBy(x: anchor.x - faceRect.midX, y: anchor.y - faceRect.midY)
        let destination = CATransform3DMakeAffineTransform(placement)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if settle {
            let spring = CASpringAnimation(keyPath: "sublayerTransform")
            spring.mass = 1
            spring.stiffness = 420
            spring.damping = 41
            spring.duration = spring.settlingDuration
            spring.fromValue = NSValue(caTransform3D: stage.layer.sublayerTransform)
            spring.toValue = NSValue(caTransform3D: destination)
            CATransaction.setCompletionBlock(completion)
            stage.layer.add(spring, forKey: "tab-settle")
        }
        stage.layer.sublayerTransform = destination
        CATransaction.commit()
    }

    private func firstSlot(in layer: UIView) -> CGRect? {
        guard let view = target?.view, let window = layer.window, view.window === window else { return nil }
        var ancestor = view.superview
        while let container = ancestor {
            if let scroll = container as? UIScrollView {
                scroll.setContentOffset(CGPoint(x: scroll.contentOffset.x, y: -scroll.adjustedContentInset.top), animated: false)
                break
            }
            ancestor = container.superview
        }
        let rect = view.convert(view.bounds, to: layer)
        return rect.isEmpty || !rect.intersects(layer.bounds) ? nil : rect
    }

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let scroll = (gesture.view as? WKWebView)?.scrollView else { return false }
        return picture == nil && stage?.view != nil && gesture.scale < 1 && scroll.zoomScale <= scroll.minimumZoomScale + 0.001
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith other: UIGestureRecognizer) -> Bool { true }

    @objc private func track(_ pinch: UIPinchGestureRecognizer) {
        guard let layer = stage?.view, let web = pinch.view, !settling else { return }
        switch pinch.state {
        case .began, .changed:
            guard pinch.numberOfTouches == 2 else { return }
            let first = pinch.location(ofTouch: 0, in: layer)
            let second = pinch.location(ofTouch: 1, in: layer)
            let center = CGPoint(x: (first.x + second.x) / 2, y: (first.y + second.y) / 2)
            let angle = atan2(second.y - first.y, second.x - first.x)
            if pinch.state == .began {
                guard let snapshot = web.snapshotView(afterScreenUpdates: false) else { return }
                pageRect = web.convert(web.bounds, to: layer)
                snapshot.isUserInteractionEnabled = false
                if !UIAccessibility.isReduceMotionEnabled, let face = face?.view, face.window === layer.window, !face.bounds.isEmpty {
                    faceRect = face.convert(face.bounds, to: layer)
                    snapshot.bounds = web.bounds
                    snapshot.center = CGPoint(x: face.bounds.midX, y: face.bounds.midY)
                    snapshot.transform = CGAffineTransform(scaleX: face.bounds.width / web.bounds.width, y: face.bounds.height / web.bounds.height)
                    face.addSubview(snapshot)
                } else {
                    snapshot.frame = pageRect
                    layer.addSubview(snapshot)
                }
                picture = snapshot
                startCenter = CGPoint(x: pageRect.midX, y: pageRect.midY)
                pivot = center
                startAngle = angle
                stage?.click()
            }
            guard let picture else { return }
            let scale = min(1, max(0.15, pinch.scale))
            if UIAccessibility.isReduceMotionEnabled {
                picture.alpha = scale
            } else {
                let transform = CGAffineTransform(rotationAngle: angle - startAngle).scaledBy(x: scale, y: scale)
                let offset = CGPoint(x: startCenter.x - pivot.x, y: startCenter.y - pivot.y).applying(transform)
                let tracked = CGPoint(x: center.x + offset.x, y: center.y + offset.y)
                if faceRect != nil {
                    project(in: layer, center: tracked, width: pageRect.width * scale, angle: angle - startAngle)
                } else {
                    picture.center = tracked
                    picture.transform = transform
                }
            }
        case .ended, .cancelled, .failed:
            guard let picture else { return }
            settling = true
            let commit = pinch.state == .ended && pinch.scale <= 0.75 && button?.isLive == true
            let card = commit ? firstSlot(in: layer) : nil
            if commit { button?.click() }
            let finish = { [weak self] in
                guard let self, self.picture === picture else { return }
                self.picture = nil
                self.stage?.click()
                DispatchQueue.main.async {
                    self.resetProjection()
                    picture.removeFromSuperview()
                    self.settling = false
                }
            }
            if faceRect != nil {
                let destination = card ?? pageRect
                project(in: layer, center: CGPoint(x: destination.midX, y: destination.midY), width: destination.width, angle: 0, settle: true, completion: finish)
                return
            }
            UIView.animate(withDuration: UIAccessibility.isReduceMotionEnabled ? 0.12 : 0.25, delay: 0, options: [.curveEaseOut, .beginFromCurrentState]) {
                if commit, let card, !card.isEmpty, !UIAccessibility.isReduceMotionEnabled {
                    picture.center = CGPoint(x: card.midX, y: card.midY)
                    picture.transform = CGAffineTransform(scaleX: card.width / picture.bounds.width, y: card.height / picture.bounds.height)
                } else if commit {
                    picture.alpha = 0
                } else {
                    picture.center = self.startCenter
                    picture.transform = .identity
                    picture.alpha = 1
                }
            } completion: { _ in finish() }
        default: break
        }
    }
}
#endif
