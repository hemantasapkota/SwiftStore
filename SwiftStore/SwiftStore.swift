//
//  SwiftStore.swift
//  SwiftStore
//
//  Created by Hemanta Sapkota on 4/05/2015.
//  Copyright (c) 2015 Hemanta Sapkota. All rights reserved.
//

import Foundation

public class SwiftStore {
  
  var db:Store!
  
  public init(storeName: String) {
    db = Store(DBName: storeName)
  }
  
  public subscript(key: String) -> String? {
    get {
      return db.get(key)
    }
    
    set(newValue) {
      db.put(key, value: newValue!)
    }
  }
  
  public func close() {
    db.close()
  }
}