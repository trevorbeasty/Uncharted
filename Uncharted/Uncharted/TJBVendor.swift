//
//  TJBVendor.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/12/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit
import MapKit

class TJBVendor: NSObject {
    
    let name : String
    let detail : String
    var location : CLLocation
    var isActive: Bool
    let type : VendorType
    
    override var description: String {
        return "name: \(name), detail: \(detail), type: \(type), is active: \(isActive)"
    }
    
    init(name: String, detail: String, location: CLLocation, isActive: Bool, type: VendorType) {
        self.name = name
        self.detail = detail
        self.location = location
        self.isActive = isActive
        self.type = type
    }
    
    convenience init(json: [String: Any]) throws {
        guard let name = json["name"] as? String else { throw SerializationError.missing("name") }
        guard let description = json["description"] as? String else { throw SerializationError.missing("description") }
        guard let latitude = json["latitude"] as? String else { throw SerializationError.missing("description") }
        guard let longitude = json["longitude"] as? String else { throw SerializationError.missing("longitude") }
        guard let type = json["type"] as? NSNumber else { throw SerializationError.missing("type") }
        
        guard let latitudeDouble = Double(latitude),
            let longitudeDouble = Double(longitude)
            else { throw SerializationError.Location }
        guard let vendorType = VendorType(rawValue: type.intValue) else { throw SerializationError.VendorType }
        
        let location = CLLocation(latitude: latitudeDouble, longitude: longitudeDouble)
        self.init(name: name, detail: description, location: location, isActive: true, type: vendorType)
    }
}

// MARK: - Vendor Type Enum
extension TJBVendor {
    
    enum VendorType : Int {
        case StreetArtist, StreetPerformer, HouseParty, OpenHouse, FoodTruck
        
        static var count: Int {
            var count = 0
            while let _ = VendorType(rawValue: count) {
                count += 1
            }
            return count
        }
        
        var stringRepresentation: String {
            switch self {
            case .StreetArtist:
                return "Street Artist"
            case .StreetPerformer:
                return "Street Performer"
            case .HouseParty:
                return "House Party"
            case .OpenHouse:
                return "Open House"
            case .FoodTruck:
                return "Food Truck"
            }
        }
        
        var mapSymbol: UIImage {
            switch self {
            case .StreetArtist:
                return #imageLiteral(resourceName: "StreetArt")
            case .StreetPerformer:
                return #imageLiteral(resourceName: "StreetPerformer")
            case .HouseParty:
                return #imageLiteral(resourceName: "HouseParty")
            case .OpenHouse:
                return #imageLiteral(resourceName: "OpenHouse")
            case .FoodTruck:
                return #imageLiteral(resourceName: "FoodTruck")
            }
        }
        
        static var allVendorTypes: [VendorType] {
            var count = 0
            var result = [VendorType]()
            while let currentVendorType = VendorType(rawValue: count) {
                result.append(currentVendorType)
                count += 1
            }
            return result
        }
    }
}

// MARK: - Serialization Error Enum
extension TJBVendor {
    
    enum SerializationError: Error {
        case missing(String)
        case Location
        case VendorType
    }
}

// MARK: - MKAnnotation 
extension TJBVendor: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.location.coordinate.latitude,
                                      longitude: self.location.coordinate.longitude)
    }
    
    var title: String? {
        return self.name
    }
    
    var subtitle: String? {
        return self.detail
    }
    
}








