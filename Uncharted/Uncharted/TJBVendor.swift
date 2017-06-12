//
//  TJBVendor.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/12/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit
import MapKit

class TJBVendor {
    let name : String
    let detail : String
    var location : CLLocation
    var isActive: Bool
    let type : TJBVendorType
    
    init(name: String, detail: String, location: CLLocation, isActive: Bool, type: TJBVendorType) {
        self.name = name
        self.detail = detail
        self.location = location
        self.isActive = isActive
        self.type = type
    }
}

enum TJBVendorType : String {
    case StreetArtist, StreetPerformer, HouseParty, OpenHouse, FoodTruck
}
