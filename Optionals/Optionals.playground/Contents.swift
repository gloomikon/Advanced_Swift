import UIKit

var a: Int? = 10
a? = 5 // 5

var b: Int? = nil
b? = 5 // nil


let s1: String?? = nil
(s1 ?? "inner") ?? "outer" // "inner"

let s2: String?? = .some(nil)
(s2 ?? "inner") ?? "outer" // "outer"

let arr1: [Int?] = [1, 2, nil]
let arr2: [Int?] = [1, 2, nil]
arr1 == arr2
