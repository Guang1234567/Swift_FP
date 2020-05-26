import Foundation

public protocol Monad: Applicative {

    @inlinable
    static func `return`(_ a: _KA._A) -> _KA

    @inlinable
    static func bind(_ ka: _KA, _ a2KB: @escaping (_KA._A) -> _KB) -> _KB
}

infix operator >>>=: MonadBindPrecedence

precedencegroup MonadBindPrecedence {
    associativity: left
    assignment: true
}
