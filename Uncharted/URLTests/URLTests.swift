//
//  URLTests.swift
//  URLTests
//
//  Created by Trevor Beasty on 6/27/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import XCTest
@testable import Uncharted

class URLTests: XCTestCase {
    
    var session: URLSession!
    var urlManager: TJBUrlManager!
    
    override func setUp() {
        super.setUp()
        session = URLSession(configuration: .default)
        urlManager = TJBUrlManager(withServerOption: .Local)
    }
    
    override func tearDown() {
        session = nil
        urlManager = nil
        super.tearDown()
    }
    
    func testGetAllVendorsURL() {
        // given
        let url = urlManager.getAllVendorsUrl()
        let promise = expectation(description: "completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        })
        dataTask.resume()
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testCreateVendorURL() {
        // given
        let url = urlManager.postVendorUrl()
        let promise = expectation(description: "completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = session.dataTask(with: url!, completionHandler: { (data, response, error) in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        })
        dataTask.resume()
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
}












