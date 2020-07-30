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
