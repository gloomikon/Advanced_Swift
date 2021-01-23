import Foundation

struct Coordinate: Codable, Equatable {
    var latitude: Double
    var longitude: Double
    // Nothing to implement here
}

struct Placemark: Codable, Equatable {
    var name: String
    var coordinate: Coordinate // already codable
}

let placemarks: [Placemark] = [
    .init(name: "Berlin", coordinate: .init(latitude: 52, longitude: 13)),
    .init(name: "Cape Town", coordinate: .init(latitude: -34, longitude: 18))
]

do {
    let encoder = JSONEncoder()
    let jsonData = try encoder.encode(placemarks)
    let jsonString = String(decoding: jsonData, as: UTF8.self)
    print(jsonString)
    /* [{"name":"Berlin","coordinate":{"longitude":13,"latitude":52}},{"name":"Cape Town","coordinate":{"longitude":18,"latitude":-34}}] */

    do {
        let decoder = JSONDecoder()
        let decoded = try decoder.decode([Placemark].self, from: jsonData)
        print(decoded == placemarks) // true
    }
    catch {
        print(error.localizedDescription)
    }
}
catch {
    print(error.localizedDescription)
}
