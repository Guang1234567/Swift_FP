import Foundation

protocol Applicative: Functor {

    associatedtype _KA2B: Kind

    @inlinable
    static func pure(_ a: _KA._A) -> _KA

    @inlinable
    static func apply(_ ka2b: _KA2B, _ ka: _KA) -> _KB
}

infix operator <*>: ApplicativeApplyPrecedence

precedencegroup ApplicativeApplyPrecedence {
    associativity: left
    assignment: true
}


