import Foundation
import Swift_FP

public protocol ProviderProtocol {
    associatedtype Element

    init<P: ProviderProtocol>(other: P) where P.Element == Element
    init(value: Element)
    init(getter: @escaping () -> Element)

    func get() -> Element
}

public extension ProviderProtocol {
    init(value: Element) {
        self.init(getter: { value })
    }

    init<P: ProviderProtocol>(other: P) where P.Element == Element {
        self.init(getter: other.get)
    }
}

public class Provider<Element>: ProviderProtocol {

    private typealias ClosureType = () -> Element

    private let getter: ClosureType

    deinit {
    }

    required
    public init(getter: @escaping () -> Element) {
        self.getter = getter
    }

    public func get() -> Element {
        return getter()
    }
}

final class ProviderFP<_A, _B>: Functor, Applicative, Monad {

    typealias _KA = Provider<_A>
    typealias _KB = Provider<_B>
    typealias _KA2B = Provider<A2B<_A, _B>>

    static func fmap(_ transform: @escaping A2B<_A, _B>, _ ka: _KA) -> _KB {
        return Provider<_B> {
            transform(ka.get())
        }
    }

    static func pure(_ a: _A) -> _KA {
        return Provider<_A> {
            a
        }
    }

    static func apply(_ ka2b: _KA2B, _ ka: _KA) -> _KB {
        let a2b: A2B<_A, _B> = ka2b.get()
        return Provider<_B> {
            a2b(ka.get())
        }
    }

    static func `return`(_ a: _A) -> _KA {
        return pure(a)
    }

    static func bind(_ ka: _KA, _ a2KB: @escaping (_A) -> _KB) -> _KB {
        return Provider<_B> {
            a2KB(ka.get()).get()
        }
    }
}

extension Provider: Kind {

    public typealias _A = Element

    public func fmap<U>(_ transform: @escaping (_A) -> U) -> Provider<U> {
        return ProviderFP.fmap(transform, self)
    }

    public static func pure(_ a: _A) -> Provider<_A> {
        return ProviderFP<_A, Any>.pure(a)
    }

    public func apply<U>(_ ka2b: Provider<A2B<_A, U>>) -> Provider<U> {
        return ProviderFP.apply(ka2b, self)
    }

    public static func <*><U>(_ ka2b: Provider<A2B<_A, U>>, _ ka: Provider<_A>) -> Provider<U> {
        return ProviderFP.apply(ka2b, ka)
    }

    public static func `return`(_ a: _A) -> Provider<_A> {
        return ProviderFP<_A, Any>.return(a)
    }

    public func bind<U>(_ a2KB: @escaping (_A) -> Provider<U>) -> Provider<U> {
        return ProviderFP.bind(self, a2KB)
    }

    public static func >>>=<U>(_ ka: Provider<_A>, _ a2KB: @escaping (_A) -> Provider<U>) -> Provider<U> {
        return ProviderFP.bind(ka, a2KB)
    }
}

public class ScopeProvider<Element>: Provider<Element> {

    private let lock: DispatchSemaphore
    private var cachedValue: Element?

    deinit {
        cachedValue = nil
    }

    required
    public init(getter: @escaping () -> Element) {
        lock = DispatchSemaphore(value: 1)
        self.cachedValue = nil
        super.init(getter: getter)
    }

    override
    public func get() -> Element {
        if let cachedValue = cachedValue {
            return cachedValue
        }

        lock.wait()
        defer {
            lock.signal()
        }
        let newValue = super.get()
        self.cachedValue = newValue
        return newValue
    }
}
