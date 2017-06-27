//
//  TJBMapToVendorHubTransitionManager.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/27/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit

class TJBMapToVendorHubTransitionManager: NSObject {

    let progressThreshold: CGFloat = 0.4
    let progressDrivenInteractiveTransition = TJBProgressDrivenInteractiveTransition()
    let animationDuration: TimeInterval = 0.3
    var isPresentation: Bool = true
}

// MARK: - UIViewControllerTransitionDelegate
extension TJBMapToVendorHubTransitionManager: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresentation = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresentation = false
        return self
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return progressDrivenInteractiveTransition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return progressDrivenInteractiveTransition
    }
}

// MARK: - UIViewControllerAnimatedTransitioning
extension TJBMapToVendorHubTransitionManager: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let key = isPresentation ? UITransitionContextViewControllerKey.to
            : UITransitionContextViewControllerKey.from
        
        let controller = transitionContext.viewController(forKey: key)!
        
        if (isPresentation) {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        dismissedFrame.origin.x = transitionContext.containerView.bounds.size.width
        
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        UIView.animate(withDuration: animationDuration,
                       animations: {
                        controller.view.frame = finalFrame
        }, completion: { finished in
            transitionContext.completeTransition(self.progressDrivenInteractiveTransition.shouldComplete)
        })
    }
}












