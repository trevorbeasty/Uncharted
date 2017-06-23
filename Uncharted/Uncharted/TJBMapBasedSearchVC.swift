//
//  TJBMapBasedSearchVC.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/12/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit
import MapKit

class TJBMapBasedSearchVC: UIViewController {
    
    let transition = HomeTransitionAnimator()
    let interactor = TJBHomeTransitionInteractor()
    let sceneTransitionProgressThreshold: CGFloat = 0.5
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var randomVendorsButton: UIBarButtonItem!
    @IBOutlet weak var centerOnLocationButton: UIButton!
    @IBOutlet weak var bottomLeftTab: UIButton!
    @IBOutlet weak var bottomRightTab: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self;
        
        addSceneTransitionGestureRecognizers()
        
        configureLocationDidUpdateNotification()
    }
    
    private func addSceneTransitionGestureRecognizers() {
        
        // bottom left tab
        let bottomLeftTabGR = UIPanGestureRecognizer(target: self,
                                                     action: #selector(didPanBottomLeftTab(gr:)))
        bottomLeftTab.addGestureRecognizer(bottomLeftTabGR)
        
        // bottom right tab
        let bottomRightTabGR = UIPanGestureRecognizer(target: self,
                                                      action: #selector(didPanBottomRightTab(gr:)))
        bottomRightTab.addGestureRecognizer(bottomRightTabGR)
    }

    private func configureLocationDidUpdateNotification() {
        NotificationCenter.default.addObserver(forName: Notification.Name(TJBLocationManager.Notifications.LocationDidUpdate.rawValue),
                                               object: TJBLocationManager.sharedInstance,
                                               queue: nil,
                                               using: { (notification: Notification) in
            if let info = notification.userInfo as? Dictionary<String,[CLLocation]> {
                if let locations = info["locations"] {
                    let location = locations[0]
                    self.centerMap(location: location, radiusInMeters: 50)
                }
            }
        })
    }
    
    func centerMap(location: CLLocation, radiusInMeters: CLLocationDistance) {
        let distance = radiusInMeters * 2
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, distance, distance)
        DispatchQueue.main.async {
            self.map.setRegion(region, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

// IBAction
extension TJBMapBasedSearchVC {
    
    @IBAction func didPressCenterOnLocationButton(_ sender: Any) {
        TJBLocationManager.sharedInstance.requestLocation()
    }
    
    @IBAction func didPressRandButton(_ sender: Any) {
        let randVendor = TJBVendorFactory.randomVendor(region: map.region)
        map.addAnnotation(randVendor)
    }
}

// MKMapViewDelegate protocol
extension TJBMapBasedSearchVC: MKMapViewDelegate {
    
    var annotationViewIdentifier: String { return "AnnotationView" }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let vendor = annotation as? TJBVendor {
            if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: vendor.type.stringRepresentation) {
                dequeuedAnnotationView.annotation = annotation
                return dequeuedAnnotationView
            }
            else {
                let newAnnotationView = MKAnnotationView(annotation: annotation,
                                                     reuseIdentifier: vendor.type.stringRepresentation)
                newAnnotationView.isEnabled = true
                newAnnotationView.canShowCallout = true
                newAnnotationView.image = vendor.type.mapSymbol
                return newAnnotationView
            }
        }
        
        return nil
    }
}

// custom transitions
extension TJBMapBasedSearchVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.presenting = true
        
        if presented is TJBActiveVendorOptionsVC { transition.swipeDirection = .SwipeRight }
        else if presented is TJBVendorHubVC { transition.swipeDirection = .SwipeLeft }
        
        return transition
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.presenting = false
        
        if dismissed is TJBActiveVendorOptionsVC { transition.swipeDirection = .SwipeLeft }
        else if dismissed is TJBVendorHubVC { transition.swipeDirection = .SwipeRight }
        
        return transition
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
//        return nil
        return interactor
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
//        return nil
        return interactor
    }
    
    func didPanBottomLeftTab(gr: UIPanGestureRecognizer) {
        
        let translation = gr.translation(in: view)
        let horizontalMovement = translation.x / view.bounds.width
        let rightMovement = fmaxf(Float(horizontalMovement), 0.0)
        let rightMovementPercent = fminf(rightMovement, 1.0)
        let progress = CGFloat(rightMovementPercent)
        
        switch gr.state {
            
        case .began:
            interactor.hasStarted = true
            let vc = TJBActiveVendorOptionsVC()
            vc.transitioningDelegate = self
            present(vc,
                    animated: true,
                    completion: nil)
            
        case .changed:
            interactor.shouldFinish = progress > sceneTransitionProgressThreshold
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
    
    func didPanBottomRightTab(gr: UIPanGestureRecognizer) {
    
        let translation = gr.translation(in: view)
        let horizontalMovement = -1.0 * translation.x / view.bounds.width /* gesture is pan left so translation will be negative */
        let leftMovement = fmaxf(Float(horizontalMovement), 0.0)
        let leftMovementPercent = fminf(leftMovement, 1.0)
        let progress = CGFloat(leftMovementPercent)
        
        switch gr.state {
            
        case .began:
            interactor.hasStarted = true
            let vc = TJBVendorHubVC()
            vc.transitioningDelegate = self
            present(vc,
                    animated: true,
                    completion: nil)
            
        case .changed:
            interactor.shouldFinish = progress > sceneTransitionProgressThreshold
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




