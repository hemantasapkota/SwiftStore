//
//  SwiftStoreTests.swift
//  SwiftStore
//
//  Created by Hemanta Sapkota on 4/05/2015.
//  Copyright (c) 2015 Hemanta Sapkota. All rights reserved.
//

import UIKit
import XCTest
import SwiftStore

var q1 = dispatch_queue_create("q1", nil)

var q2 = dispatch_queue_create("q2", nil)

class SwiftStoreTests: XCTestCase {

    var store: SwiftStore!
  
    override func setUp() {
        store = SwiftStore(storeName: "db")
        super.setUp()
    }
  
    func testWrites() {
        store["apple"] = "ball"
        for (var i = 0; i < 1000; i++) {
              store["\(i)"] = "\(i)"
        }
    }

    func testReads() {
        XCTAssert(store["apple"] == "ball", "Apple -> Ball")
        for (var i = 0; i < 1000; i++) {
            XCTAssert(store["\(i)"] == "\(i)", "Written value should be read")
        }
    }

    func testMultiThreadedReads() {

        self.store["item1"] = "10"

//        dispatch_async(q1, { () -> Void in
//            self.store["item1"] = "10"
//        })

//        dispatch_async(q2, { () -> Void in
//            self.store["item1"] = "20"
//        })

        let secs = Int64(3 * Double(NSEC_PER_SEC))
        let time = dispatch_time(DISPATCH_TIME_NOW, secs)
        dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
            let value = self.store["item1"]
            println(value)
        })

    }

    override func tearDown() {
        store.close()
        super.tearDown()
    }
  
}