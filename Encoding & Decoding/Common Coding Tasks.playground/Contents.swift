import Foundation
import UIKit
import CoreLocation

// extension CLLocationCoordinate2D: Codable { } ERROR

/*
    We’ll provide our own Codable implementation for Placemark, where we
    encode the latitude and longitude values directly. This effectively
    hides the existence of the CLLocationCoordinate2D type from the encoders
    and decoders; from their perspective, it looks as if the latitude and longitude
    properties were defined directly on Placemark
 */

struct Placemark: Codable {
    let name: String
    let coordinate: CLLocationCoordinate2D

    private enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longitude = "lon"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.coordinate = .init(
            latitude: try container.decode(Double.self, forKey: .latitude),
            longitude: try container.decode(Double.self, forKey: .longitude)
        )
    }
}

// Same thing using nested containers

/*
    With this approach, we would have effectively recreated the way the Coordinate
    type encodes itself inside our original Placemark struct, but without exposing
    the nested type to the Codable system at all.
     The resulting JSON is identical in both cases.
 */

struct _Placemark: Encodable {
    let name: String
    let coordinate: CLLocationCoordinate2D

    private enum CodingKeys: CodingKey {
        case name
        case coordinate
    }

    private enum CoordinateCodingKeys: CodingKey {
        case latitude
        case longitude
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)

        var coordinateContainer = container.nestedContainer(keyedBy: CoordinateCodingKeys.self, forKey: .coordinate)
        try coordinateContainer.encode(coordinate.latitude, forKey: .latitude)
        try coordinateContainer.encode(coordinate.longitude, forKey: .longitude)
    }
}

// The Computed Property Workaround

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
}

struct __Placemark: Codable {
    let name: String
    private let _coordinate: Coordinate
    var coordinate: CLLocationCoordinate2D {
        return .init(latitude: _coordinate.latitude, longitude: _coordinate.longitude)
    }

    private enum CodingKeys: String, CodingKey {
        case name
        case _coordinate = "coordinate"
    }
}

// Making subclasses Codable

extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red: red, green: green, blue: blue, alpha: alpha)
        }
        else {
            return nil
        }
    }
}

extension UIColor {
    struct CodableWrapper: Codable {
        let value: UIColor

        init(_ value: UIColor) {
            self.value = value
        }

        private enum CodingKeys: CodingKey {
            case red
            case green
            case blue
            case alpha
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            guard let (red, green, blue, alpha) = value.rgba else {
                let errorContext = EncodingError.Context(
                    codingPath: encoder.codingPath,
                    debugDescription: "Unsupported color format: \(value)"
                )
                throw EncodingError.invalidValue(value, errorContext)
            }
            try container.encode(red, forKey: .red)
            try container.encode(green, forKey: .green)
            try container.encode(blue, forKey: .blue)
            try container.encode(alpha, forKey: .alpha)
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.value = UIColor(
                red: try container.decode(CGFloat.self, forKey: .red),
                green: try container.decode(CGFloat.self, forKey: .green),
                blue: try container.decode(CGFloat.self, forKey: .blue),
                alpha: try container.decode(CGFloat.self, forKey: .alpha)
            )
        }
    }
}

// error: cannot automatically synthesize 'Encodable'/'Decodable'
/*
 struct ColoredRect: Codable {
    let rect: CGRect
    let color: UIColor
}
 */

struct ColoredRect: Codable {
    let rect: CGRect
    private let _color: UIColor.CodableWrapper
    var color: UIColor {
        return _color.value
    }

    init(rect: CGRect, color: UIColor) {
        self.rect = rect
        self._color = UIColor.CodableWrapper(color)
    }

    private enum CodingKeys: String, CodingKey {
        case rect
        case _color = "color"
    }


}
