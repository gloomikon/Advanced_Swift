import Foundation

/// A type that can encode values into a native format for external representation.
public protocol Encoder {
    /// The path of coding keys taken to get to this point in encoding.
    var codingPath: [CodingKey] { get }
    /// Any contextual information set by the user for encoding.
    var userInfo: [CodingUserInfoKey : Any] { get }
    /// Returns an encoding container appropriate for holding
    /// multiple values keyed by the given key type.
    func container<Key: CodingKey>(keyedBy type: Key.Type)
    -> KeyedEncodingContainer<Key>
    /// Returns an encoding container appropriate for holding
    /// multiple unkeyed values.
    func unkeyedContainer() -> UnkeyedEncodingContainer
    /// Returns an encoding container appropriate for holding
    /// a single primitive value.
    func singleValueContainer() -> SingleValueEncodingContainer
}


// MARK: - Custom encode(to:) and init(from:)

struct Coordinate: Codable {
    let lat: Double
    let long: Double
}

struct Placemark: Codable {
    let name: String
    let coordinate: Coordinate?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        do {
            self.coordinate = try container.decodeIfPresent(Coordinate.self, forKey: .coordinate)
        }
        catch DecodingError.keyNotFound {
            self.coordinate = nil
        }
    }
}

let validJSON = """
[
    { "name": "Berlin" },
    { "name": "Cape Town" }
]
"""

let invalidJSONInput = """
[
    { "name": "Berlin", "coordinate": {} }
]
"""

do {
    let inputData = invalidJSONInput.data(using: .utf8)!
    let decoder = JSONDecoder()
    let decoded = try decoder.decode([Placemark].self, from: inputData)
    print(decoded)
} catch {
    print(error.localizedDescription)
    // The data couldn’t be read because it is missing.
}
