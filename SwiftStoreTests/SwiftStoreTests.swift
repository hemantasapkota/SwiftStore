//
//  SwiftStoreTests.swift
//  SwiftStore
//
//  Created by Hemanta Sapkota on 4/05/2015.
//  Copyright (c) 2015 Hemanta Sapkota. All rights reserved.
//

import XCTest
import SwiftStore

// Modern queue creation without deprecated attributes parameter
private let q1 = DispatchQueue(label: "com.swiftstore.test.q1")
private let q2 = DispatchQueue(label: "com.swiftstore.test.q2")

class SwiftStoreTests: XCTestCase {

    var store: SwiftStore!
  
    override func setUp() {
        super.setUp()
        store = SwiftStore(storeName: "db")
        
        // Clean any previous test data
        cleanTestData()
    }
    
    override func tearDown() {
        store.close()
        super.tearDown()
    }
    
    // Helper to clean test data
    private func cleanTestData() {
        // Clean test keys to ensure tests start fresh
        for key in ["apple", "item1"] {
            _ = store.delete(key: key)
        }
        
        // Clean numeric keys
        for i in 0..<1000 {
            _ = store.delete(key: "\(i)")
        }
        
        // Clean collection test keys
        for prefix in ["r0", "r1", "r2"] {
            for i in 0..<30 {
                _ = store.delete(key: "\(prefix)-\(i)")
            }
        }
    }
  
    func testWrites() {
        store["apple"] = "ball"
        for i in 0..<1000 {
            store["\(i)"] = "\(i)"
        }
        
        // Verify a sample of writes
        XCTAssertEqual(store["apple"], "ball", "Apple -> Ball")
        XCTAssertEqual(store["0"], "0", "First element should match")
        XCTAssertEqual(store["999"], "999", "Last element should match")
    }

    func testReads() {
        // Prepare test data
        store["apple"] = "ball"
        for i in 0..<1000 {
            store["\(i)"] = "\(i)"
        }
        
        // Test reads
        XCTAssertEqual(store["apple"], "ball", "Apple -> Ball")
        for i in 0..<1000 {
            XCTAssertEqual(store["\(i)"], "\(i)", "Written value \(i) should match read value")
        }
    }

    func testMultiThreadedReads() {
        // Initial value
        store["item1"] = "10"
        
        // Test expectations
        let expectation1 = expectation(description: "Write from q1")
        let expectation2 = expectation(description: "Write from q2")
        let expectation3 = expectation(description: "Read from main queue")
        
        // Write from q1
        q1.async {
            self.store["item1"] = "20"
            expectation1.fulfill()
        }
        
        // Write from q2
        q2.async {
            self.store["item1"] = "30"
            expectation2.fulfill()
        }
        
        // Read after writes
        let delayTime = DispatchTime.now() + 0.5 // Reduced from 3s to 0.5s for faster tests
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            let value = self.store["item1"]
            // Can be any of the written values since writes are concurrent
            XCTAssertNotNil(value, "Value should exist")
            print("Multithreaded read value: \(value ?? "nil")")
            expectation3.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testCollection() {
        // Prepare test data for r1 prefix
        var r1Keys = [String]()
        for i in 0..<20 {
            let key = "r1-\(i)"
            r1Keys.append(key)
            store[key] = "r1-\(i)"
        }
        
        // Prepare test data for r2 prefix
        var r2Keys = [String]()
        for i in 0..<30 {
            let key = "r2-\(i)"
            r2Keys.append(key)
            store[key] = "r2-\(i)"
        }
        
        // Test collection functionality
        let r1 = store.collect(key: "r1")
        XCTAssertEqual(r1.count, 20, "Length of collected range should be 20.")

        let r2 = store.collect(key: "r2")
        XCTAssertEqual(r2.count, 30, "Length of collected range should be 30.")
        
        // Test deletion of collections
        let deleteResult1 = store.deleteCollection(keys: r1Keys)
        XCTAssertTrue(deleteResult1, "Deletion of r1 collection should succeed")
        
        // Verify deletion
        let r1AfterDelete = store.collect(key: "r1")
        XCTAssertEqual(r1AfterDelete.count, 0, "After deleting r1 collection, the length should be 0.")
        
        // Delete second set of keys
        let deleteResult2 = store.deleteCollection(keys: r2Keys)
        XCTAssertTrue(deleteResult2, "Deletion of r2 collection should succeed")
        
        // Verify deletion
        let r2AfterDelete = store.collect(key: "r2")
        XCTAssertEqual(r2AfterDelete.count, 0, "After deleting r2 collection, the length should be 0.")
    }
    
    func testFindKeys() {
        // Test non-existent key
        XCTAssertEqual(store.findKeys(key: "r0").count, 0, "Length of r0 should be 0.")
        
        // Prepare test data
        for i in 0..<10 {
            let key = "r1-\(i)"
            store[key] = "r1-\(i)"
        }
        
        for i in 0..<20 {
            let key = "r2-\(i)"
            store[key] = "r2-\(i)"
        }
        
        // Test finding keys
        XCTAssertEqual(store.findKeys(key: "r1").count, 10, "Length of r1 should be 10.")
        XCTAssertEqual(store.findKeys(key: "r2").count, 20, "Length of r2 should be 20.")
    }
    
    func testDeleteKey() {
        // Test deleting a single key
        store["apple"] = "delete-test"
        XCTAssertEqual(store["apple"], "delete-test", "Value should be set before deletion")
        
        let deleteResult = store.delete(key: "apple")
        XCTAssertTrue(deleteResult, "Deletion should succeed")
        
        XCTAssertNil(store["apple"], "Value should be nil after deletion")
    }
}
