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
    
        addVendorListChildVC()
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










