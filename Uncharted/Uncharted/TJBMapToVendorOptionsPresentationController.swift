//
//  TJBMapToVendorOptionsPresentationController.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/27/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit

class TJBMapToVendorOptionsPresentationController: UIPresentationController {
    
    let coverageRatio: CGFloat = 5.0 / 6.0
    let manager: TJBMapToVendorOptionsTransitionManager!
    var dimmingView: UIView!

    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = CGSize(width: containerView!.frame.size.width * coverageRatio,
                            height: containerView!.frame.size.height)
        return frame
    }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, manager: TJBMapToVendorOptionsTransitionManager) {
        self.manager = manager
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        setupDimmingView()
    }
}

// MARK: - Overriden Methods
extension TJBMapToVendorOptionsPresentationController {
    
    override func presentationTransitionWillBegin() {
        containerView?.insertSubview(dimmingView, at: 0)
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[dimmingView]-0-|",
                                           options: [], metrics: nil, views: ["dimmingView":dimmingView]))
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[dimmingView]-0-|",
                                           options: [], metrics: nil, views: ["dimmingView":dimmingView]))
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition:  { _ in
            self.dimmingView.alpha = 1.0
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        }, completion: nil)
    }
}

// MARK: - Dimming View
extension TJBMapToVendorOptionsPresentationController {
    
    func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(tapGestureRecognizer:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        dimmingView.addGestureRecognizer(tap)
    }
    
    func didTap(tapGestureRecognizer: UITapGestureRecognizer) {
        manager.isInteractiveDismissal = false
        presentingViewController.dismiss(animated: true, completion: nil)
        print("tapped")
    }
}













