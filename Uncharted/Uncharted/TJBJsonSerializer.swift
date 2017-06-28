//
//  TJBJsonSerializer.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/28/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import Foundation

class TJBJsonSerializer {
    
    static func vendorsFromJson(data: Data) throws -> [TJBVendor]? {
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
            let dictArray = jsonObject as? Array<Dictionary<String, Any>> else {
                return nil
        }
        
        var vendors = [TJBVendor]()
        
        for dict in dictArray {
            guard let fields = dict["fields"] as? [String: Any] else {
                continue
            }
            
            if let vendor = try? TJBVendor(json: fields) {
                vendors.append(vendor)
            }
        }
        
        return vendors
    }
    
}
