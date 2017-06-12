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
    
    @IBAction func didPressCenterOnLocationButton(_ sender: Any) {
        TJBLocationManager.sharedInstance.requestLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self;
        
        NotificationCenter.default.addObserver(forName: Notification.Name("LocationDidUpdate"), object: TJBLocationManager.sharedInstance, queue: nil, using: { (notification: Notification) in
                print("location did update")
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
        map .setRegion(region, animated: true)
    }
    
    
}

extension TJBMapBasedSearchVC: MKMapViewDelegate {
    
}




