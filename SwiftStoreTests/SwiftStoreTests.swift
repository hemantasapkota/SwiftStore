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

var q1 = DispatchQueue(label: "q1", attributes: [])

var q2 = DispatchQueue(label: "q2", attributes: [])

class SwiftStoreTests: XCTestCase {

    var store: SwiftStore!
  
    override func setUp() {
        store = SwiftStore(storeName: "db")
        super.setUp()
    }
  
    func testWrites() {
        store["apple"] = "ball"
        for i in (0 ..< 1000) {
              store["\(i)"] = "\(i)"
        }
    }

    func testReads() {
        XCTAssert(store["apple"] == "ball", "Apple -> Ball")
        for i in (0 ..< 1000) {
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
        let time = DispatchTime.now() + Double(secs) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: { () -> Void in
            let value = self.store["item1"]
            print(value)
        })

    }

    override func tearDown() {
        store.close()
        super.tearDown()
    }
  
}
