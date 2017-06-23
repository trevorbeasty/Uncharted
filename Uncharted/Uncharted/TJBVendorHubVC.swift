//
//  TJBVendorHubVC.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/23/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit

class TJBVendorHubVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addSceneTransitionGestureRecognizer()
    }
    
    private func addSceneTransitionGestureRecognizer() {
        
        let gr = UIScreenEdgePanGestureRecognizer(target: self,
                                                  action: #selector(didPanRightFromLeftEdge(gr:)))
        gr.edges = UIRectEdge.left
        view.addGestureRecognizer(gr)
    }
}

// custom transition
extension TJBVendorHubVC {
    
    func didPanRightFromLeftEdge(gr: UIScreenEdgePanGestureRecognizer) {
        guard let mapBasedSearchVC = presentingViewController as? TJBMapBasedSearchVC else { return }
        let interactor = mapBasedSearchVC.interactor
        
        let translation = gr.translation(in: view)
        let horizontalMovement = translation.x / view.bounds.width
        let rightMovement = fmaxf(Float(horizontalMovement), 0.0)
        let rightMovementPercent = fminf(rightMovement, 1.0)
        let progress = CGFloat(rightMovementPercent)
        
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
