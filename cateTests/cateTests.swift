//
//  cateTests.swift
//  cateTests
//
//  Created by Winston Li on 16/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import XCTest
@testable import cate

class cateTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let dict: [String: NSObject] = [
            "category": "REP",
            "name": "Final Presentation",
            "sequence": 3,
            "startTime": "2016-03-07T00:00:00Z",
            "subjectId": "322",
            "type": "GREEN"
        ]
        let upcoming: Upcoming = Upcoming(dictionary: dict)
        print(upcoming)
    }
    
    
//    var sequence: Int = -1
//    var name: String!
//    var category: String!
//    var specUrl: String?
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
