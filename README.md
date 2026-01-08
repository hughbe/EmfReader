# EmfReader

Swift definitions for structures, enumerations and functions defined in [MS-EMF](https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-emf/).

## Example Usage

Add the following line to your project's SwiftPM dependencies:
```swift
.package(url: "https://github.com/hughbe/EmfReader", from: "1.0.0"),
```

```swift
import EmfReader

let data = Data(contentsOfFile: "<path-to-file>.emf")!
let file = try EmfFile(data: data)
try file.enumerateRecords { record in
    print("Record: \(record)")
    return .continue
}
```
