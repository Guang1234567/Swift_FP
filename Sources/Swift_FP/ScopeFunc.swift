import Foundation

@inline(__always) func with<T, U>(_ receiver: T, _ block: (T) -> U) -> U {
    return block(receiver)
}

public protocol ScopeFunc {
    // Must comment below
    // -------------------
    //func apply(_ block: (Self) -> ()) -> Self
    //func `let`<U>(_ block: (Self) -> U) -> U
}

extension ScopeFunc {
    @inline(__always) public func apply(_ block: (Self) -> ()) -> Self {
        block(self)
        return self
    }

    @inline(__always) public func `let`<U>(_ block: (Self) -> U) -> U {
        return block(self)
    }
}

extension NSObject: ScopeFunc {
}

extension String: ScopeFunc {
}

extension Bool: ScopeFunc {
}

extension Int: ScopeFunc {
}

extension Int64: ScopeFunc {
}

extension Int32: ScopeFunc {
}

extension UInt: ScopeFunc {
}

extension UInt64: ScopeFunc {
}

extension UInt32: ScopeFunc {
}

extension Optional {

    @inline(__always) public func apply(_ block: (Wrapped) throws -> ()) rethrows -> Self {
        guard let w = self else {
            return self
        }
        try block(w)
        return self
    }

    @inline(__always) public func `let`<U>(_ block: (Wrapped) throws -> U) rethrows -> U? {
        return try self.map(block)
    }
}

extension Result {

    @inline(__always) public func apply(_ block: (Success) -> ()) -> Self {
        guard case let .success(s) = self else {
            return self
        }
        block(s)
        return self
    }

    @inline(__always) public func `let`<NewSuccess>(_ block: (Success) -> NewSuccess) -> Result<NewSuccess, Failure> {
        return self.map(block)
    }

    @inline(__always) public func applyError(_ block: (Failure) -> ()) -> Self {
        guard case let .failure(f) = self else {
            return self
        }
        block(f)
        return self
    }

    @inline(__always) public func letError<NewFailure>(_ block: (Failure) -> NewFailure) -> Result<Success, NewFailure> {
        return self.mapError(block)
    }
}

