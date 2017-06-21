//
//  HomeTransitionAnimator.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/21/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import Foundation
import UIKit

class HomeTransitionAnimator: NSObject {
    
    let duration: TimeInterval = 2.0
    var presenting: Bool = true
    
}

extension HomeTransitionAnimator: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // views / VCs to be manipulated
        let containerView = transitionContext.containerView
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
            else { return }
        
        // initial and final frames
        let screenBounds = UIScreen.main.bounds
        let offscreenOrigin = CGPoint(x: -1.0 * screenBounds.width,
                                      y: 0.0)
        let offscreenFrame = CGRect(origin: offscreenOrigin,
                                    size: screenBounds.size)
        let initialFrame = presenting ? offscreenFrame : fromView.frame
        let finalFrame = presenting ? fromView.frame : offscreenFrame
        
        // animate
        toView.frame = initialFrame
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: toView)
        
        UIView.animate(withDuration: duration,
                       animations: { toView.frame = finalFrame },
                       completion: { _ in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
    }
}














