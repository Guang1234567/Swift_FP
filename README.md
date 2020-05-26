# Swift_FP

The Library that provide :

- Some extension functions like in Kotlin (apply, let, with).

- add light-weight `Functor`, `Applicative`, `Monad` that implemented by myself O(∩_∩)O~.

- [bow-swift/bow](https://github.com/bow-swift/bow) the `FP Library` implemented by Swift.
    Similar to [arrow-kt/arrow](https://github.com/arrow-kt/arrow) in Kotlin.

## Usage

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
