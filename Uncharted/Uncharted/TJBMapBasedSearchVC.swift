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

        NotificationCenter.default.addObserver(forName: Notification.Name("LocationDidUpdate")
            , object: TJBLocationManager.sharedInstance
            , queue: nil
            , using: { (notification: Notification) in
                print("location did update")
        })
    }
}

extension TJBMapBasedSearchVC: MKMapViewDelegate {
    
}




