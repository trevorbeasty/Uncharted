//
//  TJBMockURLSession.swift
//  Uncharted
//
//  Created by Trevor Beasty on 6/28/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import Foundation

typealias DownloadTaskHandler = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    
    func dataTask(with url: URL, completionHandler: @escaping DownloadTaskHandler) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    
    func dataTask(with url: URL, completionHandler: @escaping DownloadTaskHandler) -> URLSessionDataTaskProtocol {

        let task = (dataTask(with: url, completionHandler: {_ in}) as URLSessionDataTask)
        return task as URLSessionDataTaskProtocol
    }
}

class TJBMockURLSession: URLSessionProtocol {
    var nextDataTask = TJBMockURLSessionDataTask()
    var lastURL: URL?
    var nextData: Data?
    var nextError: Error?
    
    func dataTask(with url: URL, completionHandler: @escaping DownloadTaskHandler) -> URLSessionDataTaskProtocol {
        lastURL = url
        completionHandler(nextData, nil, nextError)
        return nextDataTask
    }
}

