//
//  TJBServerFacade.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/13/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import Foundation

class TJBServerFacade {
    
    static let sharedInstance = TJBServerFacade()
    
    private init() {}
    
    func getAllVendors() {
        TJBServerCommunicator.sharedInstance.getAllVendors()
    }
    
    func postVendor(vendor: TJBVendor) {
        
    }
    
    enum TJBServerFacadeNotifications: String {
        case DidDownloadAllVendors
    }
}

extension TJBServerFacade: TJBServerCommunicatorDelegate {
    func didDownloadVendorJson(data: Data) {
        print("did download vendor json")
    }
    
    func downloadFailedWithError(error: Error) {
        
    }
    
    func didPostVendorWithSuccess(success: Bool) {
        
    }
}
