//
//  UnsplashServiceTest.swift
//  unsplashTests
//
//  Created by Dong-Wook Han on 2020/06/27.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import XCTest
import Alamofire
@testable import unsplash

class UnsplashServiceTest: XCTestCase {
    
    func testSearch_callsSearchAPIWithParameters() {
        // given
        let sessionManager = SessionManagerStub()
        let service = UnsplashService(sessionManager: sessionManager)
        
        // when
        service.search(keyword: "Swift", completionHandler: { _ in })
        
        // then
        let expectedURL = "https://api.unsplash.com//search/photos?"
        let actualURL = try? sessionManager.requestParameters?.url.asURL().absoluteString
        XCTAssertEqual(actualURL, expectedURL)
        
        let expectedMethod = HTTPMethod.get
        let actualMethod = sessionManager.requestParameters?.method
        XCTAssertEqual(actualMethod, expectedMethod)
        
        let expectedParameters: [String: String] = ["page": "1", "query": "Swift", "client_id": "rbyQZbn3ySVAfya2-idgr9W2Uo2_-RnsJkaA358YIB4", "per_page": "30"]
        let actualParameters = sessionManager.requestParameters?.parameters as? [String: String]
        XCTAssertEqual(actualParameters, expectedParameters)
    }
    
    func testList_callsSearchAPIWithParameters() {
        // given
        let sessionManager = SessionManagerStub()
        let service = UnsplashService(sessionManager: sessionManager)
        
        // when
        service.list(page: 1, completionHandler: { _ in })
        
        // then
        let expectedURL = "https://api.unsplash.com/photos/?"
        let actualURL = try? sessionManager.requestParameters?.url.asURL().absoluteString
        XCTAssertEqual(actualURL, expectedURL)
        
        let expectedMethod = HTTPMethod.get
        let actualMethod = sessionManager.requestParameters?.method
        XCTAssertEqual(actualMethod, expectedMethod)
        
        let expectedParameters = ["page": "1", "per_page": "30", "client_id": "rbyQZbn3ySVAfya2-idgr9W2Uo2_-RnsJkaA358YIB4"]
        let actualParameters = sessionManager.requestParameters?.parameters as? [String: String]
        XCTAssertEqual(actualParameters, expectedParameters)
    }
    
    
}
