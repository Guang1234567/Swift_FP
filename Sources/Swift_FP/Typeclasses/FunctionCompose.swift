import Foundation

infix operator |>: FunctionComposePrecedence

precedencegroup FunctionComposePrecedence {
    associativity: left
    assignment: true
}

public func |><_A, _B>(_ a: _A, _ f: (_A) -> _B) -> _B {
    return f(a)
}

