//
//  TJBUrlManager.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/13/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import Foundation

class TJBUrlManager {
    
    static let sharedInstance = TJBUrlManager()
    
    var serverOption: TJBServerOption = TJBServerOption.LocalServer
    private let baseUrlString_Local = "http://127.0.0.1:8000/"
    private let getAllVendorsExtension_Local = "vendor/getAll/"
    private let createVendorExtension_Local = "vendor/create/"
    
    private init() {}
    
    func baseUrl() -> URL? {
        let url: URL?
        switch serverOption {
        case .LocalServer:
            url = URL(string: baseUrlString_Local)
        default:
            url = nil
        }
        return url
    }
    
    func allVendorsUrl() -> URL? {
        let url: URL?
        switch serverOption {
        case .LocalServer:
            url = URL(string: getAllVendorsExtension_Local, relativeTo: baseUrl())
        default:
            url = nil
        }
        return url
    }
    
    func createVendorUrl() -> URL? {
        let url: URL?
        switch serverOption {
        case .LocalServer:
            url = URL(string: createVendorExtension_Local, relativeTo: baseUrl())
        default:
            url = nil
        }
        return url
    }
    
    enum TJBServerOption {
        case LocalServer, HostedServer
    }
}
