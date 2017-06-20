//
//  TJBVendorFactory.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/20/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import Foundation
import MapKit

class TJBVendorFactory {
    static func randomVendor(region: MKCoordinateRegion) -> TJBVendor {
        let randType = randomVendorType()
        let randName = randomVendorName(vendorType: randType)
        return TJBVendor(name: randName,
                         detail: randomVendorDescription(),
                         location: randomVendorLocation(region: region),
                         isActive: true,
                         type:  randType)
    }
    
    private static func randomVendorLocation(region: MKCoordinateRegion) -> CLLocation {
        let randLatitude = region.center.latitude + randomRadius(span: region.span.latitudeDelta)
        let randLongitude = region.center.longitude + randomRadius(span: region.span.longitudeDelta)
        return CLLocation(latitude: randLatitude,
                          longitude: randLongitude)
    }
    
    private static func randomRadius(span: CLLocationDegrees) -> CLLocationDegrees {
        let rand: Double = drand48()
        let randSpan: Double = rand * span
        let randRadius: Double = randSpan - span / 2.0
        return randRadius
    }
    
    private static func randomVendorType() -> TJBVendor.VendorType {
        if let vendor = TJBVendor.VendorType(rawValue: randomInt(max: TJBVendor.VendorType.count)) {
            return vendor
        } else {
            return TJBVendor.VendorType.StreetArtist
        }
        
    }
    
    private static func randomInt(max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
    
    private static func randomVendorName(vendorType: TJBVendor.VendorType) -> String {
        let names: [String]
        
        switch vendorType {
        case .StreetArtist:
            names = ["Wire Creations", "Organic Art", "City Portraits"]
        case .FoodTruck:
            names = ["Halal", "Tacos", "Ice Cream"]
        case .HouseParty:
            names = ["The House Guys", "Block Party"]
        case .StreetPerformer:
            names = ["Acrobatics", "Singing"]
        case .OpenHouse:
            names = ["Studios", "1 Bedroom Flex"]
        }
        
        return names[randomInt(max: names.count)]
    }
    
    private static func randomVendorDescription() -> String {
        let descriptions = ["This is how we do",
                            "Cause we the bestest",
                            "Mmm, delicious",
                            "You know you want to"]
        
        return descriptions[randomInt(max: descriptions.count)]
    }
}







