[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

### SwiftStore ###
Key/Value store for Swift backed by LevelDB

### Usage ###

#### Create instances of store ####

```
import SwiftStore

// Create a store.
let store = SwiftStore(storeName: "db")

// Write value
store["username"] = "jondoe"
store["auth-token"] = "cdfsd1231sdf12321"

// Get value
let username = store["username"]!
if !username.isEmpty {
  println(username)
}

let authToken = store["auth-token"]!
if !authToken.isEmpty {
  println(authToken)
}
```

#### As Singleton ####

```
class DB : SwiftStore {
    /* Shared Instance */
    struct Static {
        static var onceToken: dispatch_once_t = 0
        static var instance: OLDB? = nil
    }
    
    class var store:OLDB {
        dispatch_once(&Static.onceToken) {
            Static.instance = OLDB()
        }
        return Static.instance!
    }
    
    init() {
        super.init(storeName: "oldb")
    }
    
    override func close() {
        super.close()
        Static.onceToken = 0
    }
}

DB.store["username"] = "jondoe"
DB.store["auth-token"] = "1231sdfjl123"
```

### Installation ###

#### Carthage ####
* Add ```github "hemantasapkota/SwiftStore" ~> 1.2.3``` to your ```cartfile```
* Execute ```carthage update```

#### Manual Installation ####
* TODO

