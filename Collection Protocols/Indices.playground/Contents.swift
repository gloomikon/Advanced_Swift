import Foundation

extension Substring {
    func nextWordAfter(separator: Character) -> Range<Index> {
        let start = drop(while: { $0 == separator })
        let end = start.firstIndex(where: { $0 == separator}) ?? endIndex
        return start.startIndex..<end
    }
}

struct WordsIndex: Comparable {
    fileprivate let range: Range<Substring.Index>
    fileprivate init(_ range: Range<Substring.Index>) {
        self.range = range
    }

    static func <(lhs: WordsIndex, rhs: WordsIndex) -> Bool {
        return lhs.range.lowerBound < rhs.range.lowerBound
    }

    static func ==(lhs: WordsIndex, rhs: WordsIndex) -> Bool {
        return lhs.range == rhs.range
    }
}

struct Words: Collection {
    let string: Substring
    let startIndex: WordsIndex

    init(_ string: String) {
        self.init(string[...])
    }

    private init(_ s: Substring) {
        self.string = s
        self.startIndex = WordsIndex(string.nextWordAfter(separator: " "))
    }

    var endIndex: WordsIndex {
        let e = string.endIndex
        return WordsIndex(e..<e)
    }

    subscript(index: WordsIndex) -> Substring {
        return string[index.range]
    }

    func index(after i: WordsIndex) -> WordsIndex {
        guard i.range.upperBound < string.endIndex else {
            return endIndex
        }

        let remainder = string[i.range.upperBound...]
        return WordsIndex(remainder.nextWordAfter(separator: " "))
    }
}

print(Array(Words("Hello Bethany Tusen"))) // ["Hello", "Bethany", "Tusen"]

