# Tap
Tap is a tiny library (11 LOC!) that lets you configure objects after
their initialization without sacrificing your code’s semantics.
It works similarly to Ruby’s `#tap`.

## The problem
The ergonomics of Swift’s `struct`s are great. Picture this one:

```swift
struct Person {
    let name: String
    let age: Int
}
```

Without any extra work, you get an initializer, `Person(name:age:)`. If you turn the `let`s
into `var`s and provide default values, you get even more initializers. If you have
this `Person` instead:

```swift
struct Person {
    var name: String = ""
    var age: Int = 0
}
```

Then, besides `Person(name:age:)`, you’ll also get `Person()`, `Person(name:)`, and `Person(name: age:)` without having to write any extra code. This is wonderful, particularly when
you want some kind of stand-in object.

Should you want to add another field with a default value to the struct, say `phoneNumber`,

```swift
struct Person {
    var name: String = ""
    var age: Int = 0
    var phoneNumber: String = ""
}
```

then the rest of your program (remember when we called apps “programs”?)
will keep on working without modification. Good code
is malleable — easy to adapt to new requirements.

Sadly, all of this breaks when you want to consume a `struct` from a module
into another module. (This happens to me a lot, since I’m a fan of The Composable Architecture,
and I like splitting my app into isolated feature-based packages.)

Under these circumstances, you need to declare a `public` initializer in the `struct` you want to use.

```swift
struct Person {
    init(name: String = "", age: Int = 0) {
        self.name = name
        self.age = age
    }

    var name: String
    var age: Int
}
```

Code is now double as large! Even worse, let’s say we add a phone number:

```swift
public struct Person {
    public init(name: String = "", age: Int = 0, phoneNumber: String = "") {
        self.name = name
        self.age = age
        self.phoneNumber = phoneNumber
    }

    public var name: String
    public var age: Int
    public var phoneNumber: String
}
```
In order not to break existing clients of `Person`, we had to modify
 three different lines, compared to the one-line change we did
do above.

Now, ergonomics improve a lot if you use a parameter-less `init`, and configure the instance
_a posteriori_.

```swift
public struct Person {
    public init() {}

    public var name: String = ""
    public var age: Int = 0
}

var john = Person()
john.name = "John"
john.age = 41
```

Now, adding a new field will have a more manageable ripple effect.

However, I’d argue the code is weaker now. We’ve detached
initialization from configuration, so it doesn’t reveal intention as clearly as 
before. Plus,
it may be semantically incorrect: now `john` is forcefully a `var`,
regardless of whether we want to mutate it afterward or not.

## The solution
*Tap* fixes this by providing you with a protocol, `Tappable`,
that allows you to do this:

```swift
public struct Person: Tappable {
    public init() {}

    public var name: String = ""
    public var age: Int = 0
}

let john = Person().tap { john in
    john.name = "John"
    john.age = 41
}
```

Now you have structs that are easy to change across modules, and your code is as clear as if you were using your synthesized initializers.
