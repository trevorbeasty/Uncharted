//
//  TJBServerCommunicatorTests.swift
//  TJBServerCommunicatorTests
//
//  Created by Trevor Beasty on 6/28/17.
//  Copyright © 2017 BeastlyCreations. All rights reserved.
//

import XCTest
@testable import Uncharted

class TJBServerCommunicatorTests: XCTestCase {
    
    var subject: TJBServerCommunicator!
    let session = TJBMockURLSession()
    let urlManager = TJBUrlManager(withServerOption: .Local)
    
    override func setUp() {
        super.setUp()
        subject = TJBServerCommunicator(withSession: session)
    }
    
    override func tearDown() {
        subject = nil
        super.tearDown()
    }
    
    func test_GetVendors_RequestsTheURL() { /* largely trivial test from tutorial that seem to suggest testing every method call */
        // given
        let url = urlManager.getAllVendorsUrl()
        
        // when
        subject.getVendors(url: url!, completion: {_ in})
        
        // then
        XCTAssert(session.lastURL == url)
    }
    
    func test_GetVendors_StartsTheRequest() { /* largely trivial test from tutorial that seems to suggest testing every method call */
//        // given
//        let downloadTask = TJBMockURLSessionDataTask()
//        session.nextDownloadTask = downloadTask
//        let url = URL(string: "test")
//        
//        // when
//        subject.getVendors(url: url, completion: {_ in})
//        
//        // then
//        XCTAssert(downloadTask.resumeWasCalled == true)
    }
    
    func test_GetVendors_ReturnsDataWithNoError() {
        // given 
        
        
        // when
        
        // then
    }
    
}


















