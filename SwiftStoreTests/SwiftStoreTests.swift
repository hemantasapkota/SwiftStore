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

class OpenSansSwiftTests: XCTestCase {
  
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
  
  override func tearDown() {
    store.close()
    super.tearDown()
  }
  
}