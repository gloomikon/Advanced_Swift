import Foundation

var nsData = NSData()
isKnownUniquelyReferenced(&nsData) // false as doesn't work for obj-C classes

class Box<A> {
    var unbox: A
    init(_ value: A) {
        unbox = value
    }
}

var unboxedNSData = Box(nsData)
isKnownUniquelyReferenced(&unboxedNSData) // true
var y = unboxedNSData
isKnownUniquelyReferenced(&unboxedNSData) // false

// ***

// struct with copy-on-write semantics
struct MyData {
    private var _data: Box<NSMutableData>
    var _dataForWriting: NSMutableData {
        mutating get {
            if !isKnownUniquelyReferenced(&_data) {                         // if two instances share the same data
                _data = Box(_data.unbox.mutableCopy() as! NSMutableData)    // then current strucy copies the content
                print("Making a copy")
            }
            return _data.unbox
        }
    }

    init() {
        _data = Box(NSMutableData())
    }

    init(_ data: NSData) {
        _data = Box(data.mutableCopy() as! NSMutableData)
    }
}

extension MyData {
    mutating func append(_ byte: UInt8) {
        var mutableByte = byte
        _dataForWriting.append(&mutableByte, length: 1)
    }
}

var bytes = MyData()
var copy = bytes

for byte in 0..<5 as CountableRange<UInt8> {
    print("Appending 0x\(String(byte, radix: 16))")
    bytes.append(byte)
}

//Appending 0x0
//Making a copy
//Appending 0x1
//Appending 0x2
//Appending 0x3
//Appending 0x4

print(bytes._dataForWriting) // {length = 5, bytes = 0x0001020304}
print(copy._dataForWriting) // {length = 0, bytes = 0x}
