import XCTest
@testable import Tap

struct Person: Tappable, DefaultConstructible {
	init() {}

	var name: String = ""
	var age: Int = 0
}

final class TappableTests: XCTestCase {
	func testInitialization() {
		let result = Person().tap {
			$0.name = "Jane"
			$0.age = 20
		}

		XCTAssertEqual(result.name, "Jane")
		XCTAssertEqual(result.age, 20)
	}

	func testStaticInitialization() {
		let result = Person.tap {
			$0.name = "Jane"
			$0.age = 20
		}

		XCTAssertEqual(result.name, "Jane")
		XCTAssertEqual(result.age, 20)
	}

}
