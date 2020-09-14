import Foundation

/// A type that can `enqueue` and `dequeue` elements

protocol Queue {
    /// A type of element held is `self`
    associatedtype Element
    /// Enqueue `element` to `self`
    mutating func enqueue(_ element: Element)
    /// Dequeue an element from `self`
    mutating func dequeue() -> Element?
}

struct FIFOQueue<Element>: Queue {
    private var left: [Element] = []
    private var right: [Element] = []

    /// Add an element to the back of the queue
    /// - Complexity: O(1)
    mutating func enqueue(_ element: Element) {
        right.append(element)
    }

    /// Removes front of the queue
    /// Returns `nil` in case of the empty queue
    /// - Complexity: Amortized O(1)
    mutating func dequeue() -> Element? {
        if left.isEmpty {
            left = right.reversed()
            right.removeAll()
        }
        return left.popLast()
    }
}

// MARK: - Conforming to Collection

extension FIFOQueue: MutableCollection {
    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return left.count + right.count
    }

    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }

    public subscript(position: Int) -> Element {
        get {
            precondition((0..<endIndex).contains(position), "Index out of bounds")
            if position < left.endIndex {
                return left[left.count - position - 1]
            }
            else {
                return right[position - left.count]
            }
        }
        set {
            precondition((0..<endIndex).contains(position), "Index out of bounds")
            if position < left.endIndex {
                left[left.count - position - 1] = newValue
            }
            else {
                right[position - left.count] = newValue
            }
        }
    }
}

var q = FIFOQueue<String>()
for x in ["1", "2", "foo", "3"] {
    q.enqueue(x)
}
for s in q {
    print(s, terminator: " ")
} // 1 2 foo 3
print()

var a = Array(q) // ["1", "2", "foo", "3"]
a.append(contentsOf: q[2...3])
print(a) // ["1", "2", "foo", "3", "foo", "3"]

// MARK: - Conforming to ExpressibleByArrayLiteral

extension FIFOQueue: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: Element...) {
        self.left = elements.reversed()
        self.right = []
    }
}

let queue: FIFOQueue = [1, 2, 3] // FIFOQueue<Int>(left: [3, 2, 1], right: [])”

let byteQueue: FIFOQueue<UInt8> = [1, 2, 3] // FIFOQueue<UInt8>(left: [3, 2, 1], right: [])

extension FIFOQueue {
    typealias Indices = CountableRange<Int>

    var indices: CountableRange<Int> {
        return startIndex..<endIndex
    }
}

// Mutable collection example
var peopleIHate: FIFOQueue = ["bt", "BT", "bT", "BT"]
print(peopleIHate.first)
peopleIHate[0] = "BT"
print(peopleIHate.first)

// RangeReplaceableCollection

extension FIFOQueue: RangeReplaceableCollection {
    mutating func replaceSubrange<C: Collection>(_ subrange: Range<Int>, with newElements: C) where C.Element == Element {
        right = left.reversed() + right
        left.removeAll()
        right.replaceSubrange(subrange, with: newElements)
    }
}


