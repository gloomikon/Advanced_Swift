let singleDigitNumbers = 0..<10
print(Array(singleDigitNumbers)) // [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

let fromA = Character("a")...
print(type(of: fromA)) // PartialRangeFrom<Character>
let throughZ = ...Character("z")
print(type(of: throughZ)) //PartialRangeThrough<Character>
let uptoTen = ..<10
print(type(of: uptoTen)) // PartialRangeUpTo<Int>
let fromFive = 5...
print(type(of: fromFive)) // PartialRangeFrom<Int>
