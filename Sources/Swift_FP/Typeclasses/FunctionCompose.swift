import Foundation

infix operator |>: FunctionComposePrecedence
infix operator <|: FunctionComposePrecedenceReverse

precedencegroup FunctionComposePrecedence {
    associativity: left
    assignment: true
}

precedencegroup FunctionComposePrecedenceReverse {
    associativity: right
    assignment: true
}

public func |><_A, _B, _C>(
        _ g: @escaping (_A) -> _B,
        _ f: @escaping (_B) -> _C) -> ((_A) -> _C) {
    return {
        f(g($0))
    }
}

public func <|<_A, _B, _C>(
        _ f: @escaping (_B) -> _C,
        _ g: @escaping (_A) -> _B) -> ((_A) -> _C) {
    return {
        f(g($0))
    }
}
