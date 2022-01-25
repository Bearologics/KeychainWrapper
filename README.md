# KeychainWrapper

A very simple wrapper around the iOS keychain.

## Usage

First instantiate `KeychainWrapper`, then use the instance to create, read or delete keychain entries, e.g.:

```swift
let keychainWrapper = KeychainWrapper(service: "myApp")

// store password <-> username mapping for service "myApp"
keychainWrapper["username"] = "secretPassword"

// retrieve password for username
let password = keychainWrapper["username"]

// delete password entry for username in service "myApp"
keychainWrapper["username"] = nil
```

## License

See [LICENSE.md](LICENSE.md).
