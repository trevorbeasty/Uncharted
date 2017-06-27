//
//  TJBActiveVendorOptionsVC.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/21/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

/*
 ISSUES:
 1 - edge pan gr will not call its action method
 */

import UIKit

class TJBActiveVendorOptionsVC: UIViewController {
    
    @IBOutlet weak var vendorListContainerView: UIView!
    let listHorizontalInset: CGFloat = 10.0
    let listVerticalInset: CGFloat = 10.0
}

// MARK: - View Life Cycle
extension TJBActiveVendorOptionsVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addVendorListChildVC()
        setupEdgePanGestureRecognizer()
    }
    
    func addVendorListChildVC() {
        
        let vendorOptions = TJBVendor.VendorType.allVendorTypes
        let vendorListVC = TJBVendorOptionsListVC(vendorOptions: vendorOptions)
        
        // pan gesture recognizer
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(didPanOnVendorList(panGestureRecognizer:)))
        vendorListVC.view.addGestureRecognizer(panGestureRecognizer)
        
        // call add childCiewController
        addChildViewController(vendorListVC)
        
        // add child's root view to container's view hierarchy
        vendorListContainerView.addSubview(vendorListVC.view)
        
        // add constraints
        vendorListVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        var constraintMapping = [String: Any]()
        let childViewID = "vendorListVCView"
        constraintMapping[childViewID] = vendorListVC.view
        
        let horizontalVFLString = "H:|-\(listHorizontalInset)-[\(childViewID)]-\(listHorizontalInset)-|"
        let verticalVFLString = "V:|-\(listVerticalInset)-[\(childViewID)]-\(listVerticalInset)-|"
        
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horizontalVFLString,
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: constraintMapping)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: verticalVFLString,
                                                                 options: [],
                                                                 metrics: nil,
                                                                 views: constraintMapping)
        
        vendorListContainerView.addConstraints(horizontalConstraints)
        vendorListContainerView.addConstraints(verticalConstraints)
        
        
        // call didMoveToParentViewController
        vendorListVC.didMove(toParentViewController: self)
    }
    
    func setupEdgePanGestureRecognizer() {
        let gr = UIScreenEdgePanGestureRecognizer(target: self,
                                                  action: #selector(didPanOnScreenEdge(gr:)))
        gr.edges = .right
        view.addGestureRecognizer(gr)
    }
}

// MARK: - Custom Transitions / Gesture Recognizer Actions
extension TJBActiveVendorOptionsVC {
    
    func interactiveDismissalFor(gestureRecognizerState state: UIGestureRecognizerState, translation: CGPoint) {
        guard let mapBasedSearchVC = presentingViewController as? TJBMapBasedSearchVC else {
            return
        }
        let transitionManager = mapBasedSearchVC.toVendorOptionsTransitionManager
        let interactor = transitionManager.progressDrivenInteractiveTransition
        
        let horizontalMovement = -1.0 * translation.x / view.bounds.width /* gesture is pan left so translation will be negative */
        let leftMovement = fmaxf(Float(horizontalMovement), 0.0)
        let leftMovementPercent = fminf(leftMovement, 1.0)
        let progress = CGFloat(leftMovementPercent)
        
        let shouldComplete = progress > transitionManager.progressThreshold
        interactor.shouldComplete = shouldComplete
        
        switch state {
        case .began:
            transitionManager.isInteractiveDismissal = true
            mapBasedSearchVC.dismiss(animated: true, completion: nil)
            
        case .changed:
            interactor.update(progress)
            
        case .ended:
            shouldComplete ? interactor.finish() : interactor.cancel()
            
        default:
            interactor.cancel()
        }
    }
    
    func didPanOnVendorList(panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: view)
        interactiveDismissalFor(gestureRecognizerState: panGestureRecognizer.state,
                                translation: translation)
    }
    
    func didPanOnScreenEdge(gr: UIScreenEdgePanGestureRecognizer) {
        let translation = gr.translation(in: view)
        interactiveDismissalFor(gestureRecognizerState: gr.state,
                                translation: translation)
    }
    
}










