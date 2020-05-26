import Foundation

public typealias A2B<A, B> = (A) -> B

/// ==================================
/// for Optional
/// ==================================


final class OptionalFP<_A, _B>: Functor, Applicative, Monad {

    typealias _KA = Optional<_A>
    typealias _KB = Optional<_B>
    typealias _KA2B = Optional<A2B<_A, _B>>

    static func fmap(
            _ transform: A2B<_A, _B>,
            _ ka: _KA
    ) -> _KB {
        return ka.map(transform)
    }

    static func pure(_ a: _A) -> _KA {
        return Optional.some(a)
    }

    static func apply(_ ka2b: _KA2B, _ ka: _KA) -> _KB {
        switch ka2b {
            case .none:
                return .none
            case .some(let a2b):
                return fmap(a2b, ka)
        }
    }

    static func `return`(_ a: _A) -> _KA {
        return pure(a)
    }

    static func bind(_ ka: _KA, _ a2KB: (_A) -> _KB) -> _KB {
        return ka.flatMap(a2KB)
    }
}

extension Optional: Kind {

    public typealias _A = Wrapped

    public func fmap<U>(_ transform: (_A) -> U) -> Optional<U> {
        return OptionalFP.fmap(transform, self)
    }

    public static func pure(_ a: _A) -> Optional<_A> {
        return OptionalFP<_A, Any>.pure(a)
    }

    public func apply<U>(_ ka2b: Optional<A2B<_A, U>>) -> Optional<U> {
        return OptionalFP.apply(ka2b, self)
    }

    public static func <*><U>(_ ka2b: Optional<A2B<_A, U>>, _ ka: Optional<_A>) -> Optional<U> {
        return OptionalFP.apply(ka2b, ka)
    }

    public static func `return`(_ a: _A) -> Optional<_A> {
        return OptionalFP<_A, Any>.return(a)
    }

    public func bind<U>(_ a2KB: (_A) -> Optional<U>) -> Optional<U> {
        return OptionalFP.bind(self, a2KB)
    }

    public static func >>>=<U>(_ ka: Optional<_A>, _ a2KB: (_A) -> Optional<U>) -> Optional<U> {
        return OptionalFP.bind(ka, a2KB)
    }
}


/// ==================================
/// for Array
/// ==================================


final class ArrayFP<_A, _B>: Functor, Applicative, Monad {

    typealias _KA = Array<_A>
    typealias _KB = Array<_B>
    typealias _KA2B = Array<A2B<_A, _B>>

    static func fmap(_ transform: A2B<_A, _B>, _ ka: _KA) -> _KB {
        return ka.map(transform)
    }

    static func pure(_ a: _A) -> Array<_A> {
        return [a]
    }

    static func apply(_ ka2b: Array<(_A) -> _B>, _ ka: Array<_A>) -> Array<_B> {
        return ka2b.map {
            let a2b: (_A) -> _B = $0
            return ka.map {
                return a2b($0)
            }
        }.reduce([], +)
    }

    static func `return`(_ a: _A) -> Array<_A> {
        return pure(a)
    }

    static func bind(_ ka: Array<_A>, _ a2KB: (_A) -> Array<_B>) -> Array<_B> {
        return ka.flatMap(a2KB)
    }
}

extension Array: Kind {

    public typealias _A = Element

    public func fmap<U>(_ transform: (_A) -> U) -> Array<U> {
        return ArrayFP.fmap(transform, self)
    }

    public static func pure(_ a: _A) -> Array<_A> {
        return ArrayFP<_A, Any>.pure(a)
    }

    public func apply<U>(_ ka2b: Array<A2B<_A, U>>) -> Array<U> {
        return ArrayFP.apply(ka2b, self)
    }

    public static func <*><U>(_ ka2b: Array<A2B<_A, U>>, _ ka: Array<_A>) -> Array<U> {
        return ArrayFP.apply(ka2b, ka)
    }

    public static func `return`(_ a: _A) -> Array<_A> {
        return ArrayFP<_A, Any>.return(a)
    }

    public func bind<U>(_ a2KB: (_A) -> Array<U>) -> Array<U> {
        return ArrayFP.bind(self, a2KB)
    }

    public static func >>>=<U>(_ ka: Array<_A>, _ a2KB: (_A) -> Array<U>) -> Array<U> {
        return ArrayFP.bind(ka, a2KB)
    }
}


/// ==================================
/// for Result
/// ==================================


final class ResultSuccessFP<_A, _B>: Functor, Applicative, Monad {

    typealias _KA = Result<_A, Error>
    typealias _KB = Result<_B, Error>
    typealias _KA2B = Result<A2B<_A, _B>, Error>

    static func fmap(_ transform: A2B<_A, _B>, _ ka: _KA) -> _KB {
        return ka.map(transform)
    }

    static func pure(_ a: _A) -> _KA {
        return Result.success(a)
    }

    static func apply(_ ka2b: _KA2B, _ ka: _KA) -> _KB {
        switch ka2b {
            case .success(let a2b):
                return fmap(a2b, ka)
            case .failure(let error):
                return .failure(error)
        }
    }

    static func `return`(_ a: _A) -> _KA {
        return pure(a)
    }

    static func bind(_ ka: _KA, _ a2KB: (_A) -> _KB) -> _KB {
        return ka.flatMap(a2KB)
    }
}

extension Result: Kind where Failure == Error {
    public typealias _A = Success

    public func fmap<U>(_ transform: (_A) -> U) -> Result<U, Failure> {
        return ResultSuccessFP.fmap(transform, self)
    }

    public static func pure(_ a: _A) -> Result<_A, Failure> {
        return ResultSuccessFP<_A, Any>.pure(a)
    }

    public func apply<U>(_ ka2b: Result<A2B<_A, U>, Failure>) -> Result<U, Failure> {
        return ResultSuccessFP.apply(ka2b, self)
    }

    public static func <*><U>(_ ka2b: Result<A2B<_A, U>, Failure>, _ ka: Result<_A, Failure>) -> Result<U, Failure> {
        return ResultSuccessFP.apply(ka2b, ka)
    }

    public static func `return`(_ a: _A) -> Result<_A, Failure> {
        return ResultSuccessFP<_A, Any>.return(a)
    }

    public func bind<U>(_ a2KB: (_A) -> Result<U, Failure>) -> Result<U, Failure> {
        return ResultSuccessFP.bind(self, a2KB)
    }

    public static func >>>=<U>(_ ka: Result<_A, Failure>, _ a2KB: (_A) -> Result<U, Failure>) -> Result<U, Failure> {
        return ResultSuccessFP.bind(ka, a2KB)
    }
}


/// ==================================
/// for (->)
/// ==================================

/*
/// Note: not support in Swift5 https://forums.swift.org/t/extension-methods-for-non-nominal-types/17196
extension A2B : Functor, Applicative, Monad where A == Any, B == Any{
    // ...
}
*/
