# Swift_FP

The Library that provide :

- Some extension functions like in Kotlin (apply, let, width).

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

public class MySubStruct: MyStruct {

    override public var description: String {
        self.apply {
            let _ = $0
        }

        MyStruct().apply {
            let _ = $0
        }
        return "MySubStruct(321)"
    }
}

```
