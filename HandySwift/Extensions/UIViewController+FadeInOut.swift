//  UIViewController+FadeInOut.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/8/6.
//

import Foundation
import UIKit

private let dimmingViewColor = UIColor(white: 0.0, alpha: 0.501)

extension UIViewController {

    private func tempAddress() -> String {
        String(format: "%p", unsafeBitCast(self, to: Int.self))
    }

    private static var _fadeInWithTransform = [String: Bool]()
    private static var _fadeOutWithTransform = [String: Bool]()

    var fadeInWithTransform: Bool {
        get { UIViewController._fadeInWithTransform[tempAddress()] ?? false }
        set { UIViewController._fadeInWithTransform[tempAddress()] = newValue }
    }

    var fadeOutWithTransform: Bool {
        get { UIViewController._fadeOutWithTransform[tempAddress()] ?? false }
        set { UIViewController._fadeOutWithTransform[tempAddress()] = newValue }
    }

    func presentWithFadeAnimation(
        _ viewControllerToPresent: UIViewController,
        animated: Bool,
        transformedIn: Bool = true,
        transformedOut: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        viewControllerToPresent.modalPresentationStyle = .custom
        viewControllerToPresent.transitioningDelegate = self
        viewControllerToPresent.fadeInWithTransform = transformedIn
        viewControllerToPresent.fadeOutWithTransform = transformedOut
        present(viewControllerToPresent, animated: animated, completion: completion)
    }
}

extension UIViewController: UIViewControllerTransitioningDelegate {

    public func animationController(
        forPresented _: UIViewController,
        presenting _: UIViewController,
        source _: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        PresentAnimationControllerWithFadeIn()
    }

    public func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        DismissAnimationControllerWithFadeOut()
    }
}

private class PresentAnimationControllerWithFadeIn: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let toView = transitionContext.view(forKey: .to) else {
            return
        }

        let containerView = transitionContext.containerView
        let dimmingView = UIView(frame: containerView.bounds)
        dimmingView.backgroundColor = dimmingViewColor
        dimmingView.alpha = 0.0

        containerView.addSubview(dimmingView)
        containerView.addSubview(toView)

        toView.alpha = 0.0
        if toViewController.fadeInWithTransform {
            toView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }

        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseInOut,
                       animations: {
                           dimmingView.alpha = 1.0
                           toView.alpha = 1.0
                           toView.transform = CGAffineTransform.identity
                       }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

private class DismissAnimationControllerWithFadeOut: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.25
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from),
              let fromView = transitionContext.view(forKey: .from),
              let dimmingView = transitionContext.containerView.subviews.first(where: {
                  $0.backgroundColor == dimmingViewColor
              }) else {
            return
        }
        if fromViewController.fadeOutWithTransform {
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           delay: 0.0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 1.0,
                           options: .curveEaseInOut,
                           animations: {
                               dimmingView.alpha = 0.0
                               fromView.alpha = 0.0
                               fromView.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                           }) { finished in
                fromView.removeFromSuperview()
                dimmingView.removeFromSuperview()
                transitionContext.completeTransition(finished)
            }
        } else {
            UIView.animate(withDuration: transitionDuration(using: transitionContext),
                           animations: {
                               dimmingView.alpha = 0.0
                               fromView.alpha = 0.0
                           }) { finished in
                fromView.removeFromSuperview()
                dimmingView.removeFromSuperview()
                transitionContext.completeTransition(finished)
            }
        }
    }
}
