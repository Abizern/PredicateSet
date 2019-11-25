public typealias PredicateSet<Element> = (Element) -> Bool

/// Returns a function that returns false for any input
///
/// The Empty Set
public func empty<Element>() -> PredicateSet<Element> {
    { _ in return false}
}

/// Returns a function that returns `true` or any input
///
/// The Universe Set
public func universe<Element>() -> PredicateSet<Element> {
    { _ in return true }
}

/// Lifts the value into a PredicateSet
/// - Parameter e: the value to lift
public func pure<Element: Equatable>(_ e: Element) -> PredicateSet<Element> {
    { x in x == e}
}

/// Creates a PredicateSet from the variadic values
public func elementSet<Element: Equatable>(_ elements: Element...) -> PredicateSet<Element> {
    { x in elements.contains(x)}
}

/// Creates a PredicateSet from the array of values
public func elementSet<Element: Equatable>(_ elements: [Element]) -> PredicateSet<Element> {
    { x in elements.contains(x)}
}

/// Creates an inverted PredicateSet
/// - Parameter set: The PredicateSet to invert
public func complement<Element>(_ set: @escaping PredicateSet<Element>) -> PredicateSet<Element> {
    { x in !set(x) }
}

/// A PredicateSet from the Union of the passed in sets
public func union<Element>(_ lhs: @escaping PredicateSet<Element>, _ rhs: @escaping PredicateSet<Element>) -> PredicateSet<Element> {
    { x in lhs(x) || rhs(x) }
}

/// A PredicateSet from the intersection of the passed in sets
public func intersection<Element>(_ lhs: @escaping PredicateSet<Element>, _ rhs: @escaping PredicateSet<Element>) -> PredicateSet<Element> {
    { x in lhs(x) && rhs(x) }
}

/// A PredicateSet that contains the elements from the first set that are not in the second set
public func difference<Element>(_ lhs: @escaping PredicateSet<Element>, _ rhs: @escaping PredicateSet<Element>) -> PredicateSet<Element> {
    { x in lhs(x) && complement(rhs)(x) }
}

/// A PredicateSet that contains the elements that are in one set or the other, but not in both
public func symmetricDifference<Element>(_ lhs: @escaping PredicateSet<Element>, _ rhs: @escaping PredicateSet<Element>) -> PredicateSet<Element> {
    { x in union(difference(lhs, rhs), difference(rhs, lhs))(x)}
}

/// A PredicateSet of tuples created from combining every element of the first set with every element of the second
public func cartesianProduct<T, V>(_ lhs: @escaping PredicateSet<T>, _ rhs: @escaping PredicateSet<V>) -> PredicateSet<(T, V)> {
    { (arg) -> Bool in
        let (x, y) = arg
        return lhs(x) && rhs(y)
    }
}

/// A contramap that allows an existing PredicateSet to be used with elements provided by the transform
/// - Parameters:
///   - set: The original PredicateSet
///   - transform: A transform to convert an input type to the type of the original PredicateSet
public func contramap<T, V>(_ set: @escaping PredicateSet<T>, _ transform: @escaping (V) -> T) -> PredicateSet<V> {
    { x in
        return set(transform(x))
    }
}

