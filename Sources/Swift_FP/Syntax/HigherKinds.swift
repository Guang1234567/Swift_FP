import Foundation

/*
 For example, we have mentioned that Array<Element> is of kind * -> *. If we provide a type, like Int or String, the new type becomes Array<Int> or Array<String>, which are of kind *. Similarly, Result<Value, Error> is of kind * -> * -> *, Result<Int, Error> is of kind * -> * (still has one type parameter that has not been fixed), and Result<Int, DivideError> is of kind *. This means that type constructors can be partially applied to obtain new type constructors.
*/

/// * -> *: is the kind of types that receive one type parameter.
/// That includes types which, given a type, can provide another one.
/// Examples of this are Array<Element> or Optional<Wrapped>;
/// these types, when provided an Element or Wrapped type, will create a new type in the system.
public protocol Kind {
    associatedtype _A
}

/// * -> * -> *: is the kind of types that receive two type parameters.
/// Similar to the case above, examples of this kind are Result<Value, Error> or Function1<Input, Output>;
/// when we provide two types to fill their two holes, we get a new type back.
public protocol Kind2 {
    associatedtype _A
    associatedtype _B
}

/// * -> * -> * -> *
public protocol Kind3 {
    associatedtype _A
    associatedtype _B
    associatedtype _C
}

/// * -> * -> * -> * -> *
public protocol Kind4 {
    associatedtype _A
    associatedtype _B
    associatedtype _C
    associatedtype _D
}