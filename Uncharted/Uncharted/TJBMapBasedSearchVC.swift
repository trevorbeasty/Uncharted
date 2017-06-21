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
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var randomVendorsButton: UIBarButtonItem!
    @IBOutlet weak var centerOnLocationButton: UIButton!
    @IBOutlet weak var bottomLeftTab: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self;
        
        let bottomLeftTabGR = UIPanGestureRecognizer(target: self,
                                                     action: #selector(didPanBottomLeftTab(gr:)))
        bottomLeftTab.addGestureRecognizer(bottomLeftTabGR)
        
        configureLocationDidUpdateNotification()
    }

    private func configureLocationDidUpdateNotification() {
        NotificationCenter.default.addObserver(forName: Notification.Name(TJBLocationManager.LocationNotifications.LocationDidUpdate.rawValue),
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
        
        do {
            try TJBVendor.downloadAllVendors(completion: { (vendors: [TJBVendor]) -> Void in
                for vendor in vendors {
                    print(vendor.description)
                }
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func didPressRandButton(_ sender: Any) {
        let randVendor = TJBVendorFactory.randomVendor(region: map.region)
        map.addAnnotation(randVendor)
    }
    
    @IBAction func didPressPresentButton(_ sender: Any) {
        let vc = TJBActiveVendorOptionsVC()
        vc.transitioningDelegate = self
        present(vc,
                animated: true,
                completion: nil)
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
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactor
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        return interactor
    }
    
    func didPanBottomLeftTab(gr: UIPanGestureRecognizer) {
        
        let progressThreshhold: CGFloat = 0.5
        
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
            interactor.shouldFinish = progress > progressThreshhold
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




