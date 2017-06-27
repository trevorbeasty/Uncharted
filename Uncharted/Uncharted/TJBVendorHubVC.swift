//
//  TJBVendorHubVC.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/23/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit

class TJBVendorHubVC: UIViewController {
}

// MARK: - View Life Cycle
extension TJBVendorHubVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSceneTransitionGestureRecognizer()
    }
    
    private func addSceneTransitionGestureRecognizer() {
        
        let gr = UIPanGestureRecognizer(target: self,
                                        action: #selector(didPan(gestureRecognizer:)))
        view.addGestureRecognizer(gr)
    }
}

// MARK: - Custom Transition
extension TJBVendorHubVC {
    
    func didPan(gestureRecognizer gr: UIScreenEdgePanGestureRecognizer) {
        
        guard let mapBasedSearchVC = presentingViewController as? TJBMapBasedSearchVC else {
            return
        }
        let transitionManager = mapBasedSearchVC.toVendorHubTransitionManager
        let interactor = transitionManager.progressDrivenInteractiveTransition
        
        let translation = gr.translation(in: view)
        let horizontalMovement = translation.x / view.bounds.width
        let rightMovement = fmaxf(Float(horizontalMovement), 0.0)
        let rightMovementPercent = fminf(rightMovement, 1.0)
        let progress = CGFloat(rightMovementPercent)
        
        let shouldComplete = progress > transitionManager.progressThreshold
        interactor.shouldComplete = shouldComplete
        
        switch gr.state {
        case .began:
            mapBasedSearchVC.dismiss(animated: true, completion: nil)
            
        case .changed:
            interactor.update(progress)
            
        case .ended:
            shouldComplete ? interactor.finish() : interactor.cancel()
            
        default:
            interactor.cancel()
        }
    }
}






