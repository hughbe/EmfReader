@testable import EmfReader
import XCTest

final class MetafileTests: XCTestCase {
    func testExample() throws {
        do {
            let data = try getData(name: "online_example", fileExtension: "emf")
            let file = try EmfFile(data: data)
            print(file)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
