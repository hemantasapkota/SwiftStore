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
let username = store["username"] 
if !username.isEmpty {
  println(username)
}

let authToken = store["auth-token"] 
if !authToken.isEmpty {
  println(authToken)
}
```

#### As Singleton ####

```
class DB : SwiftStore {
    /* Shared Instance */
    class var store:OLDB {
        struct Singleton {
            static let instance = DB()
        }
        return Singleton.instance
    }
    
    init() {
        super.init(storeName: "oldb")
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

