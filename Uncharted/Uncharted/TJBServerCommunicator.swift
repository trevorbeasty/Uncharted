//
//  TJBServerCommunicator.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/13/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import Foundation

class TJBServerCommunicator {
    
    static let sharedInstance = TJBServerCommunicator()
    private let session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    
    private init() {}
    
    func getAllVendors() {
        if let url = TJBUrlManager.sharedInstance.allVendorsUrl() {
            let task = session.downloadTask(with: url, completionHandler: { (url: URL?, response: URLResponse?, error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    if let url = url {
                        do {
                            let data = try Data(contentsOf: url)
                            TJBServerFacade.sharedInstance.didDownloadVendorJson(data: data)
                            print(data)
                        } catch {
                            print(error.localizedDescription)
                            return
                        }
                    }
            })
            task.resume()
        }
    }

}

protocol TJBServerCommunicatorDelegate {
    func didDownloadVendorJson(data: Data)
    func downloadFailedWithError(error: Error)
    func didPostVendorWithSuccess(success: Bool)
}
