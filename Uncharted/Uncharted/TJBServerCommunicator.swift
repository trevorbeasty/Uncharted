//
//  TJBServerCommunicator.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/28/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import UIKit

class TJBServerCommunicator {
    
    let session: URLSessionProtocol
    
    init(withSession session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

}

// MARK: - GET TJBVendor
extension TJBServerCommunicator {
    
    func getVendors(url: URL?, completion: @escaping ([TJBVendor]) -> Void) {

        guard let url = url else { return }
        
        let task = session.dataTask(with: url,
                                    completionHandler: { (data, urlResponse, error) in
                                        if let error = error {
                                            print(error.localizedDescription)
                                            return
                                        }
                                        
                                        guard let data = data,
                                            let vendors = try? TJBJsonSerializer.vendorsFromJson(data: data) else {
                                                return
                                        }
                                        
                                        if let vendors = vendors {
                                            completion(vendors)
                                        }
        })
        
        task.resume()
    }
}
























