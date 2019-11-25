public typealias PredicateSet<Element> = (Element) -> Bool

public func empty<Element>() -> PredicateSet<Element> {
    { _ in return false}
}

public func universe<Element>() -> PredicateSet<Element> {
    { _ in return true }
}

public func pure<Element: Equatable>(_ e: Element) -> PredicateSet<Element> {
    { x in x == e}
}

public func elementSet<Element: Equatable>(_ elements: Element...) -> PredicateSet<Element> {
    { x in elements.contains(x)}
}

public func elementSet<Element: Equatable>(_ elements: [Element]) -> PredicateSet<Element> {
    { x in elements.contains(x)}
}

public func complement<Element>(_ set: @escaping PredicateSet<Element>) -> PredicateSet<Element> {
    { x in !set(x) }
}

public func union<Element>(_ lhs: @escaping PredicateSet<Element>, _ rhs: @escaping PredicateSet<Element>) -> PredicateSet<Element> {
    { x in lhs(x) || rhs(x) }
}

public func intersection<Element>(_ lhs: @escaping PredicateSet<Element>, _ rhs: @escaping PredicateSet<Element>) -> PredicateSet<Element> {
    { x in lhs(x) && rhs(x) }
}

public func difference<Element>(_ lhs: @escaping PredicateSet<Element>, _ rhs: @escaping PredicateSet<Element>) -> PredicateSet<Element> {
    { x in lhs(x) && complement(rhs)(x) }
}

public func symmetricDifference<Element>(_ lhs: @escaping PredicateSet<Element>, _ rhs: @escaping PredicateSet<Element>) -> PredicateSet<Element> {
    { x in union(difference(lhs, rhs), difference(rhs, lhs))(x)}
}

public func cartesianProduct<T, V>(_ lhs: @escaping PredicateSet<T>, _ rhs: @escaping PredicateSet<V>) -> PredicateSet<(T, V)> {
    { (arg) -> Bool in
        let (x, y) = arg
        return lhs(x) && rhs(y)
    }
}

public func contramap<T, V>(_ set: @escaping PredicateSet<T>, _ transform: @escaping (V) -> T) -> PredicateSet<V> {
    { x in
        return set(transform(x))
    }
}

