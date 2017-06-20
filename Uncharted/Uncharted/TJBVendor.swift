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
    
    enum VendorType : Int {
        case StreetArtist, StreetPerformer, HouseParty, OpenHouse, FoodTruck
        
        static let count: Int = {
            var max: Int = 0
            while let _ = VendorType(rawValue: max) { max += 1 }
            return max
        }()
        
        var stringRepresentation: String {
            return "vendorType_" + String(self.rawValue)
        }
        
        var mapSymbol: UIImage? {
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
    }

    let name : String
    let detail : String
    var location : CLLocation
    var isActive: Bool
    let type : VendorType
    
    init(name: String, detail: String, location: CLLocation, isActive: Bool, type: VendorType) {
        self.name = name
        self.detail = detail
        self.location = location
        self.isActive = isActive
        self.type = type
    }
    
    override var description: String {
        return "name: \(name), detail: \(detail), type: \(type), is active: \(isActive)"
    }
}


// server
extension TJBVendor {
    
    enum SerializationError: Error {
        case missing(String)
        case Location
        case VendorType
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
    
    private static let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    static func downloadAllVendors(completion: @escaping ([TJBVendor]) -> Void) throws {
        if let url = try TJBUrlManager.allVendorsUrl() {
            let task = session.downloadTask(with: url, completionHandler: { (url: URL?, response: URLResponse?, error: Error?) in
                if error != nil { print (error!.localizedDescription) }
                
                if let url = url {
                    do {
                        let data = try Data(contentsOf: url)
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                        guard let dictArray = jsonObject as? Array<Dictionary<String, Any>> else { return }
                        
                        var vendors = [TJBVendor]()
                        for dict in dictArray {
                            guard let fields = dict["fields"] as? [String: Any] else { continue }
                            let vendor = try TJBVendor(json: fields)
                            vendors.append(vendor)
                        }
                        
                        completion(vendors)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            })
            
            task.resume()
        }
    }
}

// MKAnnotation protocol
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








