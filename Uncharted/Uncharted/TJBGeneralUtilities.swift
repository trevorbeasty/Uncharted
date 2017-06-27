//
//  TJBGeneralUtilities.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/26/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit

class TJBGeneralUtilities {
    
    static func embedChildViewController(child: UIViewController, parent: UIViewController, containerView: UIView, leftInset: CGFloat, rightInset: CGFloat, topInset: CGFloat, bottomInset: CGFloat) {
        
        parent.addChildViewController(child)
        
        child.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(child.view)
        
        let childViewString = "childView"
        let constraintMapping: [String: Any] = [childViewString : child.view]
        
        let horizontalVFLString = "H:|-\(leftInset)-[\(childViewString)]-\(rightInset)-|"
        let verticalVFLString = "V:|-\(topInset)-[\(childViewString)]-\(bottomInset)-|"
        
        
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: horizontalVFLString,
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: constraintMapping)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: verticalVFLString,
                                                                 options: [],
                                                                 metrics: nil,
                                                                 views: constraintMapping)
        
        containerView.addConstraints(horizontalConstraints)
        containerView.addConstraints(verticalConstraints)
        
        child.didMove(toParentViewController: parent)
    }
    
    static func embedChildViewController(child: UIViewController, parent: UIViewController, containerView: UIView) {
        let zeroInset = CGFloat(0)
        
        embedChildViewController(child: child,
                                 parent: parent,
                                 containerView: containerView,
                                 leftInset: zeroInset,
                                 rightInset: zeroInset,
                                 topInset: zeroInset,
                                 bottomInset: zeroInset)
    }
}

