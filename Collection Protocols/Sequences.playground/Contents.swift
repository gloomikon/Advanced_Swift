import Foundation

/**
public protocol Sequence {
    associatedtype Element where Self.Element == Self.Iterator.Element
    associatedtype Iterator : IteratorProtocol
    func makeIterator() -> Self.Iterator
}
*/

// MARK: - Iteratos

struct ConstantIterator: IteratorProtocol {
    typealias Element = Int // it's optional to make an explicit typealias for Element, but is good for documentation purpose

    mutating func next() -> Int? {
        return 17
    }
}

struct FibsIterator: IteratorProtocol {
    private var state = (0, 1)

    mutating func next() -> Int? {
        let nextNumber = state.0

        state = (state.1, state.0 + state.1)
        return nextNumber
    }
}

var fibsIterator = FibsIterator()

while let number = fibsIterator.next(), number < 100 {
    print(number, terminator: " ") // 0 1 1 2 3 5 8 13 21 34 55 89
}

print()

struct PrefixIterator: IteratorProtocol {
    typealias Element = Substring

    private let string: String
    private var offset: String.Index

    init(string: String) {
        self.string = string
        self.offset = string.startIndex
    }

    mutating func next() -> Substring? {
        guard offset < string.endIndex else {
            return nil
        }
        offset = string.index(after: offset)
        return string[..<offset]
    }
}

struct PrefixSequnce: Sequence {
    let string: String
    func makeIterator() -> PrefixIterator {
        return .init(string: string)
    }
}



for prefix in PrefixSequnce(string: "BethanyTusen") {
    print(prefix)
//    B
//    Be
//    Bet
//    Beth
//    Betha
//    Bethan
//    Bethany
//    BethanyT
//    BethanyTu
//    BethanyTus
//    BethanyTuse
//    BethanyTusen
}

// MARK: - Iterators and value semantics

let seq = stride(from: 0, to: 10, by: 1)
var iterator1 = seq.makeIterator()
print(iterator1.next()) // Optional(0)
print(iterator1.next()) // Optional(1)

var iterator2 = iterator1 // Copied
print(iterator1.next()) // Optional(2)
print(iterator1.next()) // Optional(3)
print(iterator2.next()) // Optional(2)
print(iterator2.next()) // Optional(3)

var iterator3 = AnyIterator(iterator1)
var iterator4 = iterator3
print(iterator3.next()) // Optional(4)
print(iterator4.next()) // Optional(5)
print(iterator3.next()) // Optional(6)
print(iterator4.next()) // Optional(7)

// MARK: - Function-Based Iterators and Sequences

func fibsIterator2() -> AnyIterator<Int> {
    var state = (0, 1)
    return AnyIterator {
        let nextNumber = state.0

        state = (state.1, state.0 + state.1)
        return nextNumber
    }
}

let fibsSequnce = AnySequence(fibsIterator2)
print(Array(fibsSequnce.prefix(10))) // [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]
