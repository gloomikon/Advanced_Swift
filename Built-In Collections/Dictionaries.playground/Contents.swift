enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}

let defaultSettings: [String: Setting] = [
    "Airplane mode": .bool(false),
    "Name": .text("iPhone (КолумбиЯ)")
]

print(defaultSettings["Name"]!) // text("iPhone (КолумбиЯ)")

// MARK: - Removing & Updating
var userSettings = defaultSettings
userSettings.removeValue(forKey: "Airplane mode")
userSettings.updateValue(.text("My iPhone"), forKey: "Name")
print(userSettings) // ["Name": Setting.text("My iPhone")]

// MARK: - Merging
var settings = defaultSettings
let overriddenSettings: [String: Setting] = ["Name": .text("Jane's iPhone")]
settings.merge(overriddenSettings, uniquingKeysWith: { $1 })
print(settings) // ["Airplane mode": Setting.bool(false), "Name": Setting.text("Jane\'s iPhone")]

extension Sequence where Element: Hashable {
    var frequencies: [Element: Int] {
        let freqencyPairs = self.map { ($0, 1) }
        return Dictionary(freqencyPairs, uniquingKeysWith: +)
    }
}

let frequencies = "Bethany Tusen".frequencies
print(frequencies) // ["y": 1, "s": 1, "n": 2, "e": 2, "B": 1, "T": 1, "a": 1, "u": 1, "t": 1, "h": 1, " ": 1]

// MARK: - Mapping through dictionary
let settingsAsStrings = settings.mapValues { setting -> String in
    switch setting {
    case .bool(let value):
        return String(value)
    case .int(let value):
        return String(value)
    case .text(let value):
        return value
    }
}

print(settingsAsStrings) // ["Airplane mode": "false", "Name": "Jane\'s iPhone"]

