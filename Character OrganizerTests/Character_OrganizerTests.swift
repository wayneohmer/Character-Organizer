//
//  Character_OrganizerTests.swift
//  Character OrganizerTests
//
//  Created by Wayne Ohmer on 10/31/19.
//  Copyright © 2019 Tryal by Fyre. All rights reserved.
//

import XCTest
@testable import Character_Organizer

class Character_OrganizerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        var fileURL: URL?

        
        if let path = Bundle.main.path(forResource: "5e-SRD-Equipment", ofType: "json") {
            fileURL = URL(fileURLWithPath: path)
        } else {
            XCTAssert(false)
        }

        do {
            let data = try Data(contentsOf: fileURL!, options: .mappedIfSafe)
            do {
                let decoder = JSONDecoder()
                let array = try decoder.decode([Equipment].self, from: data)
                for item in array {
                    Equipment.shared[item.url] = item
                }
                
            } catch {
                print(error)
                XCTAssert(false, error.localizedDescription)
            }
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
