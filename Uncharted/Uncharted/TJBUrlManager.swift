//
//  TJBUrlManager.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/13/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import Foundation

class TJBUrlManager {
    
    enum Option {
        case LocalServer, HostedServer
    }
    
    enum URLError: Error {
        case nilURL(String)
    }
    
    static var serverOption: Option = .LocalServer
    private static let baseUrlString_Local = "http://127.0.0.1:8000/"
    private static let getAllVendorsExtension_Local = "vendor/getAll/"
    private static let createVendorExtension_Local = "vendor/create/"
    
    static func baseUrl() throws -> URL? {
        let url: URL?
        
        switch serverOption {
        case .LocalServer:
            url = URL(string: baseUrlString_Local)
        default:
            throw URLError.nilURL("base")
        }
        
        return url
    }
    
    static func allVendorsUrl() throws -> URL? {
        let url: URL?
        
        switch serverOption {
        case .LocalServer:
            url = try URL(string: getAllVendorsExtension_Local, relativeTo: baseUrl())
        default:
            throw URLError.nilURL("all vendors URL")
        }
        
        return url
    }
    
    static func createVendorUrl() throws -> URL? {
        let url: URL?
        
        switch serverOption {
        case .LocalServer:
            url = try URL(string: createVendorExtension_Local, relativeTo: baseUrl())
        default:
            throw URLError.nilURL("create vendor URL")
        }
        
        return url
    }
}








