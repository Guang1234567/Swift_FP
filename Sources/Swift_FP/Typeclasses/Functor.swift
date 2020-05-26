import Foundation

protocol Functor {

    associatedtype _KA: Kind
    associatedtype _KB: Kind

    @inlinable
    static func fmap(_ transform: (_KA._A) -> _KB._A, _ ka: _KA) -> _KB
}

/*
infix operator <$>: FunctorFmapPrecedence

precedencegroup FunctorFmapPrecedence {
    associativity: left
    assignment: true
}
*/
