public protocol Tappable {
	func tap(configure: (inout Self) -> Void) -> Self
}

public protocol DefaultConstructible {
    init()
}

public extension Tappable {
	func tap(configure: (inout Self) -> Void) -> Self {
		var copy = self
		configure(&copy)
		return copy
	}
}

public extension Tappable where Self: DefaultConstructible {
    static func tap(configure: (inout Self) -> Void) -> Self {
        return Self().tap(configure: configure)
    }
}
