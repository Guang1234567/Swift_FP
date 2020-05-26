# Swift_FP

The Library that provide :

- Some extension functions like in Kotlin (apply, let, with).

- add light-weight `Functor`, `Applicative`, `Monad` that implemented by myself O(∩_∩)O~.

- add Function-Compose like operator `Elixir F#` :  `|>`.

- [bow-swift/bow](https://github.com/bow-swift/bow) the `FP Library` implemented by Swift.
    Similar to [arrow-kt/arrow](https://github.com/arrow-kt/arrow) in Kotlin.

## Scope Function like in kotlin

Just extension your `custom-type` to `ScopeFunc`

```swift
import Swift_FP

extension MyClazz: ScopeFunc {
}

extension MyStruct: ScopeFunc {
}

// Now you can
// ----------------
MyClazz().apply {
    let _ = $0
}

MySubClazz().apply {
    let _ = $0
}

MyStruct().apply {
    let _ = $0
}

MySubStruct().apply {
    let _ = $0
}

```

More detail

```swift

import Swift_FP

public class MyClazz: CustomStringConvertible {
    public var description: String {
        return "MyClazz(123)"
    }
}

extension MyClazz: ScopeFunc {
}

// Note: `MySubClazz` need not to inheritance from `ScopeFunc`
// ==========================================================
public class MySubClazz: MyClazz {

    override public var description: String {
        self.apply {
            let _ = $0
        }

        MyClazz().apply {
            let _ = $0
        }
        return "MySubClazz(123)"
    }
}

public struct MyStruct: CustomStringConvertible {
    public var description: String {
        return "MyStruct(321)"
    }
}

extension MyStruct: ScopeFunc {
}

// Note: `MySubStruct` can not to inheritance from `MyStruct`, because they are `Value-Type`
// ==========================================================
public struct MySubStruct {

    public var description: String {
        self.apply {
            let _ = $0
        }

        MyStruct().apply {
            let _ = $0
        }
        return "MySubStruct(321)"
    }
}

// So need it
// ===================================
extension MySubStruct: ScopeFunc {
}

```

## Functor Applicative Monad  function-compose

```swift
public func test() {
    let xs = [2.0, 3.0, 5.0, 7.0, 11.0, 13.0, 17.0]
    print("\(xs >>>= {[$0 + 10.0]} >>>= {[$0 * 2.0]})")
    print("\(xs.flatMap {[$0 + 10.0]} .flatMap {[$0 * 2.0]})")

    let gf = 2 |> {$0 * 2} |> {$0 + 3}
    print("\(gf)")

    let fg = 2 |> {$0 + 3} |> {$0 * 2}
    print("\(fg)")
}
```

## Dependency Injection   inversion-of-control
 
```swift
public protocol Animal {
    var name: String? { get }
}

public class Cat: Animal {
    public let name: String?

    init(name: String?) {
        self.name = name
    }
}

public protocol Person {
    func play()
}

public class PetOwner: Person {
    let pets: [Animal]

    init(pets: [Animal]) {
        self.pets = pets
    }

    public func play() {
        for pet in pets {
            let name = pet.name ?? "someone"
            print("I'm playing with \(name).")
        }
    }
}

public func testDI() {
    let appScope = DIContainer()
    let userScope = DIContainer(parent: appScope)

    appScope.register(Animal.self) { c in
        Cat(name: "Mimi")
    }
    appScope.register(Animal.self) { c in
        Cat(name: "Mimi")
    }
    appScope.register(Animal.self, name: "tag_Max") { (currentContainer: DIContainer) in
        Cat(name: "Max")
    }
    // Advanced Usage : be careful memory leak
    // ========================================
    appScope.registerProvider(Animal.self, name: "tag_Middle") { (currentContainer: DIContainer) in
        return (
                currentContainer.resolveProvider(Animal.self)?
                // note: `[unowned currentContainer]` is used to avoid memory leak.
                >>>= { [unowned currentContainer] (cat) in
                    ScopeProvider {
                        //let abc = currentContainer // for memory leak
                        return Cat(name: "\(cat.name!) (singleton Cat)")
                    }
                }
        )!
    }

    userScope.register(Person.self, isSingleton: false) { (currentContainer: DIContainer) in
        PetOwner(pets: [
            currentContainer.resolve(Animal.self, name: "tag_Max")!,
            currentContainer.resolve(Animal.self, name: "tag_Middle")!,
            currentContainer.resolve(Animal.self)!,
        ])
    }


    let person: Person = userScope.resolve(Person.self)!
    person.play() // prints "I'm playing with Mimi."

    let person2: Person = userScope.resolve(Person.self)!

    print("\(ObjectIdentifier(person as AnyObject))")
    print("\(ObjectIdentifier(person2 as AnyObject))")
    print("\(ObjectIdentifier(Person.self))")

    print("\(ObjectIdentifier(userScope.resolve(Animal.self, name: "tag_Middle")! as AnyObject))")
    print("\(ObjectIdentifier(userScope.resolve(Animal.self, name: "tag_Middle")! as AnyObject))")
}
```