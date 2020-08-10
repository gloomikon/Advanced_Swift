import Foundation

// MARK: - ARRAYS

// MARK: - ARRAYS AND MUTABILITY

// Mutable array a
let a = NSMutableArray(array: [1, 3, 0, 1])

// Seems like immutable array b
let b: NSArray = a

// But nope!
a.insert(611, at: 4)
print(b) // 1, 3, 0, 1, 611

// To do it right
let c = a.copy() as! NSArray
a.insert(510, at: 5)
print(c) // 1, 3, 0, 1, 611


// MARK: - TRANSFORMING ARRAYS
let fibs = [1, 1, 2, 3, 5]

let squares = fibs.map {fib in fib * fib}

extension Array {
    func Kmap<T>(_ transform: (Element) -> T) -> [T] {
        var result: [T] = []
        result.reserveCapacity(count)
        for x in self {
            result.append(transform(x))
        }
        return result
    }
}

extension Sequence {
    func last(where predicate: (Element) -> Bool) -> Element? {
        for element in reversed() where predicate(element) {
            return element
        }
        return nil
    }
}

let names = ["Kolumbia", "Sebastian", "Nikolas"]

let match = names.last { $0.hasSuffix("an")}
print(match ?? "Nothing found") // Sebastian

extension Array {
    // works like reduce but for each element so we got an array as result
    func accumulate<Result>(_ initialResult: Result, _ nextParticialResult: (Result, Element) -> Result) -> [Result] {
        var running = initialResult
        return map { next in
            running = nextParticialResult(running, next)
            return running
        }
    }
}

let accumulated = [1, 2, 3, 4].accumulate(0, +)
print(accumulated) // [1, 3, 6, 10]

extension Array {
    func kfilter(_ condition: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for x in self where condition(x) {
            result.append(x)
        }

        return result
    }
}

let filtered = [1, 2, 3, 4, 5, 6].kfilter { $0 % 2 == 0}
print(filtered) // [2, 4, 6]

extension Sequence {
    public func all(matching predicate: (Element) -> Bool) -> Bool {
        return !contains { !predicate($0) }
    }
}

let evenNumbers = [2, 4, 6, 8, 10]
print(evenNumbers.all { $0 % 2 == 0}) // true

extension Array {
    func kreduce<Result>(_ initialResult: Result, _ nextParticialResult: (Result, Element) -> Result) -> Result {
        var result = initialResult
        for x in self {
            result = nextParticialResult(result, x)
        }
        return result
    }
}

let sumOfInts = [1, 2, 3, 4, 5].kreduce(0, +)
print(sumOfInts) // 15

extension Array {
    // map function using only reduce
    func mapWithReduce<T>(_ transform: (Element) -> T) -> [T] {
        return reduce([]) { $0 + [transform($1)] }
    }

    // filter function using only reduce
    func filterWithReduce(_ condition: (Element) -> Bool) -> [Element] {
        return reduce([]) { condition($1) ? $0 + [$1] : $0 }
    }

    // filter with reduce with inout parametr
    func filterReduceInout(_ condition: (Element) -> Bool) -> [Element] {
        return reduce(into: []) { result, element in
            if condition(element) {
                result.append(element)
            }
        }
    }
}

extension Array {
    func kflatMap<T>(_ transform: (Element) -> [T]) -> [T] {
        var result: [T] = []
        for x in self {
            result.append(contentsOf: transform(x))
        }
        return result
    }
}

let suits = ["♠︎", "♥︎", "♣︎", "♦︎"]
let ranks = ["J","Q","K","A"]
let result = suits.flatMap { suit in
    ranks.map { rank in
        (suit, rank)
    }
}

print(result)
