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
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var randomVendorsButton: UIBarButtonItem!
    @IBOutlet weak var centerOnLocationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self;
        
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




