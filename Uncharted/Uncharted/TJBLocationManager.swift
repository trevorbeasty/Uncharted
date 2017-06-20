//
//  TJBLocationManager.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/12/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit
import CoreLocation

class TJBLocationManager: NSObject {
    
    enum LocationNotifications: String {
        case LocationDidUpdate, LocationUpdateFailed
    }
    
    static let sharedInstance = TJBLocationManager()
    let locationManager: CLLocationManager
    
    private override init() {
        let lm = CLLocationManager()
        self.locationManager = lm;
        super.init();
        lm.delegate = self;
        
        if CLLocationManager.authorizationStatus() !=  CLAuthorizationStatus.authorizedWhenInUse {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

// API
extension TJBLocationManager {
    
    func requestLocation() {
        locationManager.requestLocation()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
}

extension TJBLocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        let notificationName = Notification.Name(LocationNotifications.LocationDidUpdate.rawValue)
        NotificationCenter.default.post(name: notificationName, object:  self, userInfo: ["locations":locations])
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    
    }
    
}

















