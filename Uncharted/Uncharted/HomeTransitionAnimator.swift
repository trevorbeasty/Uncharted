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
    
    enum SwipeDirection {
        case SwipeRight, SwipeLeft
    }
    
    enum OffscreenFrameOrientation {
        case OffscreenFrameLeft, OffscreenFrameRight
    }
    
    let duration: TimeInterval = 2.0
    var presenting: Bool = true
    var swipeDirection: SwipeDirection = .SwipeRight
    var offscreenFrameOrientation: OffscreenFrameOrientation {
        if (swipeDirection == .SwipeLeft && presenting == true) ||
            (swipeDirection == .SwipeRight && presenting == false) {
            
            return .OffscreenFrameRight
            
        } else /* (swipeDirection == .SwipeLeft && presenting == false) ||
            (swipeDirection == .SwipeRight && presenting == true) */ {
            
            return .OffscreenFrameLeft
            
        }
    }
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
        
        if presenting == true {
            
            animateForPresenting(containerView: containerView,
                                 fromView: fromView,
                                 toView: toView,
                                 offscreenFrame: offscreenFrame(),
                                 transitionContext: transitionContext)
            
        } else /* presenting == false */ {
            animateForDismissing(containerView: containerView,
                                 fromView: fromView,
                                 toView: toView,
                                 offscreenFrame: offscreenFrame(),
                                 transitionContext: transitionContext)
        }
    }
    
    private func offscreenFrame() -> CGRect {
        let screenBounds = UIScreen.main.bounds
        
        // offscreen frame varies according to swipe direction
        let offscreenOrigin: CGPoint
        
        switch offscreenFrameOrientation {
        case .OffscreenFrameRight:
            offscreenOrigin = CGPoint(x: 1.0 * screenBounds.width, y: 0.0)
        case .OffscreenFrameLeft:
            offscreenOrigin = CGPoint(x: -1.0 * screenBounds.width, y: 0.0)
        }
        
        return CGRect(origin: offscreenOrigin, size: screenBounds.size)
    }
    
    private func animateForPresenting(containerView: UIView, fromView: UIView, toView: UIView, offscreenFrame: CGRect, transitionContext: UIViewControllerContextTransitioning) {
        
        toView.frame = offscreenFrame
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: toView)
        
        UIView.animate(withDuration: duration,
                       animations: { toView.frame = containerView.bounds },
                       completion: { _ in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    
    private func animateForDismissing(containerView: UIView, fromView: UIView, toView: UIView, offscreenFrame: CGRect, transitionContext: UIViewControllerContextTransitioning) {
        
        toView.frame = containerView.bounds
        containerView.addSubview(toView)
        containerView.bringSubview(toFront: fromView)
        
        UIView.animate(withDuration: duration,
                       animations: { fromView.frame = offscreenFrame },
                       completion: { _ in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}














