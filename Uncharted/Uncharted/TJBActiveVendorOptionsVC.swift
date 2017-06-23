//
//  TJBActiveVendorOptionsVC.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/21/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit

class TJBActiveVendorOptionsVC: UIViewController {
    
    @IBOutlet weak var vendorListContainerView: UIView!
    let listHorizontalInset: CGFloat = 10.0
    let listVerticalInset: CGFloat = 10.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        addSceneTransitionGestureRecognizer()
        
        addVendorListChildVC()
    }
    
    private func addSceneTransitionGestureRecognizer() {
        
        let gr = UIScreenEdgePanGestureRecognizer(target: self,
                                                  action: #selector(didPanLeftFromRightEdge(gr:)))
        gr.edges = UIRectEdge.right
        view.addGestureRecognizer(gr)
    }
    
    private func addVendorListChildVC() {
        let vendorOptions = TJBVendor.VendorType.allVendorTypes
        let vendorListVC = TJBVendorOptionsListVC(vendorOptions: vendorOptions)
        
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
}

// custom transitions
extension TJBActiveVendorOptionsVC {
    
    func didPanLeftFromRightEdge(gr: UIScreenEdgePanGestureRecognizer) {
        
        guard let mapBasedSearchVC = presentingViewController as? TJBMapBasedSearchVC else { return }
        let interactor = mapBasedSearchVC.interactor
        
        let translation = gr.translation(in: view)
        let horizontalMovement = -1.0 * translation.x / view.bounds.width /* gesture is pan left so translation will be negative */
        let leftMovement = fmaxf(Float(horizontalMovement), 0.0)
        let leftMovementPercent = fminf(leftMovement, 1.0)
        let progress = CGFloat(leftMovementPercent)
        
        switch gr.state {
            
        case .began:
            interactor.hasStarted = true
            mapBasedSearchVC.dismiss(animated: true, completion: nil)
            
        case .changed:
            interactor.shouldFinish = progress > mapBasedSearchVC.sceneTransitionProgressThreshold
            interactor.update(progress)
            
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
            
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
            
        default:
            break
        }
    }
    
}










