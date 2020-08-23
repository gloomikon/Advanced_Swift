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

// MARK: - Subsequnces

/**
protocol Sequence {
    associatedtype Element
    associatedtype Iterator: IteratorProtocol
        where Iterator.Element == Element
    associatedtype SubSequence
    // ...
}
*/
extension Sequence where Element: Equatable {
    func headMirrorsTails(_ n: Int) -> Bool {
        let head = prefix(n)
        let tail = suffix(n).reversed()
        return head.elementsEqual(tail)
    }
}

print([1, 2, 3, 4, 2, 1].headMirrorsTails(2)) // true

// MARK: - A Linked List

enum List<Element> {
    case end
    indirect case node(Element, next: List<Element>)
}

let emptyList = List<Int>.end
let oneElementList = List.node(17, next: emptyList)

extension List {
    // construct
    func cons(_ x: Element) -> List {
        return .node(x, next: self)
    }
}
// A 3-elements list of (3, 2, 1)

let list = List<Int>.end.cons(1).cons(2).cons(3) // pretty ugly though

extension List: ExpressibleByArrayLiteral {
    typealias ArrayLiteralElement = Element

    init(arrayLiteral elements: Element...) {
        self = elements.reversed().reduce(.end) { particialResult, element in
            return particialResult.cons(element)
        }
    }
}

var listFromArray: List = [3, 2, 1]

extension List {
    mutating func push(_ x: Element) {
        self = self.cons(x)
    }

    mutating func pop() -> Element? {
        switch self {
        case .end:
            return nil
        case let .node(element, next: tail):
            self = tail
            return element
        }
    }
}

listFromArray.push(5)
print(listFromArray)
print(listFromArray.pop())

extension List: IteratorProtocol, Sequence {
    mutating func next() -> Element? {
        return pop()
    }
}

let oneMoreList: List = ["1", "2", "3", "4", "5"]

for x in oneMoreList {
    print(x, terminator: " ") // 1 2 3 4 5
}

print()

print(oneMoreList.joined(separator: ", ")) // 1, 2, 3, 4, 5
print(oneMoreList.contains("2")) // true
print(oneMoreList.compactMap { Int($0) }) // [1, 2, 3, 4, 5]
