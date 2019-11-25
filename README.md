# PredicateSet

This is a Set type that is created by Predicate

```swift
public typealias PredicateSet<Element> = (Element) -> Bool
```
    
Rather than creating a set by adding items and then later seeing if the item is in the set, this works by providing a Predicate, a function that returns true or false.

