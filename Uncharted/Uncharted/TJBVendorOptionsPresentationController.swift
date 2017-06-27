//
//  TJBVendorOptionsPresentationController.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/26/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit

class TJBVendorOptionsPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        var frame: CGRect = .zero
        frame.size = CGSize(width: containerView!.frame.size.width * 2.0 / 3.0,
                            height: containerView!.frame.size.height)
        return frame
    }
}
