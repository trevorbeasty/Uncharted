//
//  TJBMockURLSessionDataTask.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/28/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import Foundation

protocol URLSessionDataTaskProtocol {
    
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

class TJBMockURLSessionDataTask: URLSessionDataTaskProtocol {
    var resumeWasCalled: Bool = false
    
    func resume() {
        resumeWasCalled = true
    }
}
