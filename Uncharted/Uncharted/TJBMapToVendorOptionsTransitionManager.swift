//
//  TJBMapToVendorOptionsTransitionManager.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/27/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit

class TJBMapToVendorOptionsTransitionManager: NSObject {

    let progressThreshold: CGFloat = 0.4
    let progressDrivenInteractiveTransition = TJBProgressDrivenInteractiveTransition()
    let animationDuration: TimeInterval = 0.3
    var isPresentation: Bool = true
    var isInteractiveDismissal: Bool = true
}

extension TJBMapToVendorOptionsTransitionManager: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return TJBMapToVendorOptionsPresentationController(presentedViewController: presented,
                                                           presenting: presenting,
                                                           manager: self)
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
        if isInteractiveDismissal { return progressDrivenInteractiveTransition }
        else { return nil }
    }
}

extension TJBMapToVendorOptionsTransitionManager: UIViewControllerAnimatedTransitioning {
    
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
        dismissedFrame.origin.x = -1 * presentedFrame.width
        
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        let animationDuration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        UIView.animate(withDuration: animationDuration,
                       animations: {
                        controller.view.frame = finalFrame
        }, completion: { finished in
            if self.isPresentation || self.isInteractiveDismissal {
                transitionContext.completeTransition(self.progressDrivenInteractiveTransition.shouldComplete)
            } else {
                transitionContext.completeTransition(true)
            }
            
        })
    }
}













