//
//  TJBUrlManager.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/13/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import Foundation

class TJBUrlManager {
    
    let serverOption: ServerOption
    
    init(withServerOption option: ServerOption) {
        self.serverOption = option
    }
    
    func baseUrl() -> URL? {

        switch serverOption {
        case .Local:
            return URL(string: "http://127.0.0.1:8000/")
        case .Hosted:
            return nil
        }
    }
    
    func getAllVendorsUrl() -> URL? {

        switch serverOption {
        case .Local:
            return URL(string: "vendor/getAll/",
                       relativeTo: baseUrl())
        case .Hosted:
            return nil
        }
    }
    
    func postVendorUrl() -> URL? {

        switch serverOption {
        case .Local:
            return URL(string: "vendor/create/",
                       relativeTo: baseUrl())
        case .Hosted:
            return nil
        }
    }
}

// MARK: - ServerOption Enum
extension TJBUrlManager {
    
    enum ServerOption {
        case Local, Hosted
    }
}





