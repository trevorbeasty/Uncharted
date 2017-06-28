//
//  TJBMockURLSessionDownloadTask.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/28/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import Foundation

protocol URLSessionDownloadTaskProtocol {
    func resume()
}

extension URLSessionDownloadTask: URLSessionDownloadTaskProtocol {}

class TJBMockURLSessionDownloadTask: URLSessionDownloadTaskProtocol {
    var resumeWasCalled: Bool = false
    
    func resume() {
        resumeWasCalled = true
    }
}
