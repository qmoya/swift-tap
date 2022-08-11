/// A type that you can build with a configuration block.
public protocol Tappable {
	
	/// Creates and configures an instance.
	/// - Parameter configure: A configuration block. It receives an instance of the adopting type.
	/// - Returns: A new, configured instance of the adopting type.
	func tap(configure: (inout Self) -> Void) -> Self
}

/// A type that you can initialize without any arguments.
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
