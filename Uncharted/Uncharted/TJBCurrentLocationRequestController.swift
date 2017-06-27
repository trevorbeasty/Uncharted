//
//  TJBCurrentLocationRequestController.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/26/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit
import MapKit

class TJBCurrentLocationRequestController: UIViewController {
    
    var awaitingLocationUpdate: Bool = false {
        didSet{
            switch awaitingLocationUpdate {
            case true:
                activityIndicator.startAnimating()
                updateLocationButton.isEnabled = false
            case false:
                activityIndicator.stopAnimating()
                updateLocationButton.isEnabled = true
            }
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var updateLocationButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.insertSubview(activityIndicator, aboveSubview: updateLocationButton)

        activityIndicator.hidesWhenStopped = true
        
        configureLocationDidUpdateNotification()    
    }
    
    private func configureLocationDidUpdateNotification() {
        let notification = Notification.Name(TJBLocationManager.Notifications.LocationDidUpdate.rawValue)
        NotificationCenter.default.addObserver(forName: notification,
                                               object: TJBLocationManager.sharedInstance,
                                               queue: nil,
                                               using: { (notification: Notification) in
                                                self.awaitingLocationUpdate = false
        })
    }

    @IBAction func didPressUpdateLocationButton(_ sender: Any) {
        TJBLocationManager.sharedInstance.requestLocation()
        awaitingLocationUpdate = true
    }
}













