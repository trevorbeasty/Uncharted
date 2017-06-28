//
//  TJBURLManagerTests.swift
//  TJBURLManagerTests
//
//  Created by Trevor Beasty on 6/28/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import XCTest
@testable import Uncharted

class TJBURLManagerTests: XCTestCase {
    
    var subject: TJBUrlManager!
    let session = URLSession.shared
    
    override func setUp() {
        super.setUp()
        subject = TJBUrlManager(withServerOption: .Local)
    }
    
    override func tearDown() {
        subject = nil
        super.tearDown()
    }
    
    func testGetAllVendorsURL() {
        // given
        let url = subject.getAllVendorsUrl()
        let promise = expectation(description: "completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = session.dataTask(with: url!,
                                        completionHandler: { (data, response, error) in
                                            statusCode = (response as? HTTPURLResponse)?.statusCode
                                            responseError = error
                                            promise.fulfill()
        }) as URLSessionDataTask
        dataTask.resume()
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testCreateVendorURL() {
        // given
        let url = subject.postVendorUrl()
        let promise = expectation(description: "completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = session.dataTask(with: url!,
                                        completionHandler: { (data, response, error) in
                                            statusCode = (response as? HTTPURLResponse)?.statusCode
                                            responseError = error
                                            promise.fulfill()
        }) as URLSessionDataTask
        dataTask.resume()
        
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
}
