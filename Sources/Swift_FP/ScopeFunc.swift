import Foundation

@inline(__always) func with<T, R>(_ receiver: T, _ block: (T) -> R) -> R {
    return block(receiver)
}

public protocol ScopeFunc {
    // Must comment below
    // -------------------
    //func apply(_ block: (Self) -> ()) -> Self
    //func `let`<R>(_ block: (Self) -> R) -> R
}

extension ScopeFunc {
    @inline(__always) public func apply(_ block: (Self) -> ()) -> Self {
        block(self)
        return self
    }

    @inline(__always) public func `let`<R>(_ block: (Self) -> R) -> R {
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

    @inline(__always) public func `let`<R>(_ block: (Wrapped) throws -> R) rethrows -> R? {
        return try self.map(block)
    }

    static public func combine<T1, T2, R>(
            _ t1: @autoclosure () -> T1?,
            _ t2: @autoclosure () -> T2?,
            _ block: (T1, T2) -> R
    ) -> R? {
        guard let t1 = t1(), let t2 = t2() else {
            return nil
        }

        return block(t1, t2)
    }

    static public func combine<T1, T2, T3, R>(
            _ t1: @autoclosure () -> T1?,
            _ t2: @autoclosure () -> T2?,
            _ t3: @autoclosure () -> T3?,
            _ block: (T1, T2, T3) -> R
    ) -> R? {
        guard let t1 = t1(), let t2 = t2(), let t3 = t3() else {
            return nil
        }

        return block(t1, t2, t3)
    }

    static public func combine<T1, T2, T3, T4, R>(
            _ t1: @autoclosure () -> T1?,
            _ t2: @autoclosure () -> T2?,
            _ t3: @autoclosure () -> T3?,
            _ t4: @autoclosure () -> T4?,
            _ block: (T1, T2, T3, T4) -> R
    ) -> R? {
        guard let t1 = t1(), let t2 = t2(), let t3 = t3(), let t4 = t4() else {
            return nil
        }

        return block(t1, t2, t3, t4)
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

    public func combineWith<T, R>(
            _ other: @autoclosure () throws -> T,
            _ block: (Success, T) -> R
    ) throws -> R {
        let r1 = try self.get()
        let r2 = try other()
        return block(r1, r2)
    }

    public func combineWith<T, R>(
            _ other: @autoclosure () -> Result<T, Error>,
            _ block: (Success, T) -> R
    ) throws -> R {
        let r1 = try self.get()
        let r2 = try other().get()
        return block(r1, r2)
    }

    public func combineWith<T, R>(
            _ other: @autoclosure () throws -> T,
            _ block: (Success, T) -> R
    ) -> Result<R, Error> {
        return Result<R, Error> {
            let r1 = try self.get()
            let r2 = try other()
            return block(r1, r2)
        }
    }

    public func combineWith<T, R>(
            _ other: @autoclosure () -> Result<T, Error>,
            _ block: (Success, T) -> R
    ) -> Result<R, Error> {
        return Result<R, Error> {
            let r1 = try self.get()
            let r2 = try other().get()
            return block(r1, r2)
        }
    }

    static public func combine<T1, T2, R>(
            _ t1: @autoclosure () throws -> T1,
            _ t2: @autoclosure () throws -> T2,
            _ block: (T1, T2) -> R
    ) throws -> R {
        let r1: T1 = try t1()
        let r2: T2 = try t2()
        return block(r1, r2)
    }

    static public func combine<T1, T2, T3, R>(
            _ t1: @autoclosure () throws -> T1,
            _ t2: @autoclosure () throws -> T2,
            _ t3: @autoclosure () throws -> T3,
            _ block: (T1, T2, T3) -> R
    ) throws -> R {
        let r1: T1 = try t1()
        let r2: T2 = try t2()
        let r3: T3 = try t3()
        return block(r1, r2, r3)
    }

    static public func combine<T1, T2, T3, T4, R>(
            _ t1: @autoclosure () throws -> T1,
            _ t2: @autoclosure () throws -> T2,
            _ t3: @autoclosure () throws -> T3,
            _ t4: @autoclosure () throws -> T4,
            _ block: (T1, T2, T3, T4) -> R
    ) throws -> R {
        let r1: T1 = try t1()
        let r2: T2 = try t2()
        let r3: T3 = try t3()
        let r4: T4 = try t4()
        return block(r1, r2, r3, r4)
    }

    static public func combine<T1, T2, R>(
            _ t1: @autoclosure () -> Result<T1, Error>,
            _ t2: @autoclosure () -> Result<T2, Error>,
            _ block: (T1, T2) -> R
    ) -> Result<R, Error> {
        return Result<R, Error> {
            let r1: T1 = try t1().get()
            let r2: T2 = try t2().get()
            return block(r1, r2)
        }
    }

    static public func combine<T1, T2, T3, R>(
            _ t1: @autoclosure () -> Result<T1, Error>,
            _ t2: @autoclosure () -> Result<T2, Error>,
            _ t3: @autoclosure () -> Result<T3, Error>,
            _ block: (T1, T2, T3) -> R
    ) -> Result<R, Error> {
        return Result<R, Error> {
            let r1: T1 = try t1().get()
            let r2: T2 = try t2().get()
            let r3: T3 = try t3().get()
            return block(r1, r2, r3)
        }
    }

    static public func combine<T1, T2, T3, T4, R>(
            _ t1: @autoclosure () -> Result<T1, Error>,
            _ t2: @autoclosure () -> Result<T2, Error>,
            _ t3: @autoclosure () -> Result<T3, Error>,
            _ t4: @autoclosure () -> Result<T4, Error>,
            _ block: (T1, T2, T3, T4) -> R
    ) -> Result<R, Error> {
        return Result<R, Error> {
            let r1: T1 = try t1().get()
            let r2: T2 = try t2().get()
            let r3: T3 = try t3().get()
            let r4: T4 = try t4().get()
            return block(r1, r2, r3, r4)
        }
    }
}

