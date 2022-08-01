public protocol Tappable {
	func tap(configure: (inout Self) -> Void) -> Self
}

public extension Tappable {
	func tap(configure: (inout Self) -> Void) -> Self {
		var copy = self
		configure(&copy)
		return copy
	}
}
