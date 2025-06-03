import Foundation

// To enhance the performance test, adjust the number of models.
// A higher number will result in a longer execution time.

import Foundation

// MARK: - Complex Model Definition

// A deeply nested and complex struct to simulate a real-world scenario
struct InnerMostDetail: Codable {
    let id: UUID
    let value1: Int
    let value2: Double
    let description: String
    let isActive: Bool
    let timestamp: Date

    init() {
        self.id = UUID()
        self.value1 = Int.random(in: 0...1000)
        self.value2 = Double.random(in: 0...1.0)
        self.description = "Detail \(UUID().uuidString)"
        self.isActive = Bool.random()
        self.timestamp = Date()
    }
}

struct InnerDetail: Codable {
    let name: String
    let code: String
    let quantity: Int
    let price: Double
    let details: [InnerMostDetail]
    let notes: String?
    let isValid: Bool

    init() {
        self.name = "Inner Detail \(UUID().uuidString)"
        self.code = UUID().uuidString.prefix(8).uppercased()
        self.quantity = Int.random(in: 1...100)
        self.price = Double.random(in: 10.0...1000.0)
        self.details = (0..<5).map { _ in InnerMostDetail() } // 5 nested details
        self.notes = Bool.random() ? "Some notes here." : nil
        self.isValid = Bool.random()
    }
}

struct IntermediateDetail: Codable {
    let identifier: UUID
    let type: String
    let version: String
    let configuration: [String: String]
    let items: [InnerDetail]
    let creationDate: Date
    let lastModified: Date
    let status: String

    init() {
        self.identifier = UUID()
        self.type = "Type \(Int.random(in: 1...10))"
        self.version = "1.\(Int.random(in: 0...9)).\(Int.random(in: 0...9))"
        self.configuration = ["key1": "value1", "key2": "value2", "key3": "value3"]
        self.items = (0..<10).map { _ in InnerDetail() } // 10 inner details
        self.creationDate = Date().addingTimeInterval(TimeInterval.random(in: -3600*24*365...0))
        self.lastModified = Date()
        self.status = ["Active", "Inactive", "Pending"].randomElement()!
    }
}

struct BigAndComplexModel: Codable {
    let mainID: UUID
    let title: String
    let description: String
    let priority: Int
    let isCompleted: Bool
    let properties: [String: AnyCodable] // Using AnyCodable for dynamic properties
    let subModels: [IntermediateDetail]
    let relatedIDs: [UUID]
    let settings: [String: Bool]
    let auditTrail: [Date: String]
    let tags: Set<String>

    init() {
        self.mainID = UUID()
        self.title = "Complex Model \(UUID().uuidString)"
        self.description = "This is a very detailed description of a complex model instance."
        self.priority = Int.random(in: 1...5)
        self.isCompleted = Bool.random()
        // Simulate dynamic properties using AnyCodable
        var dynamicProperties: [String: AnyCodable] = [:]
        for i in 0..<5 {
            dynamicProperties["dynamicKey\(i)"] = AnyCodable(Int.random(in: 0...100))
        }
        dynamicProperties["dynamicString"] = AnyCodable("A dynamic string value.")
        self.properties = dynamicProperties
        self.subModels = (0..<20).map { _ in IntermediateDetail() } // 20 intermediate details
        self.relatedIDs = (0..<10).map { _ in UUID() }
        self.settings = ["setting1": true, "setting2": false, "setting3": true]
        var trail: [Date: String] = [:]
        for _ in 0..<3 {
            trail[Date().addingTimeInterval(TimeInterval.random(in: -3600*24*30...0))] = "Event \(UUID().uuidString.prefix(5))"
        }
        self.auditTrail = trail
        self.tags = ["tagA", "tagB", "tagC", "tagD", "tagE"]
    }
}

// MARK: - AnyCodable Helper (for dynamic properties)
// This is a standard way to handle heterogeneous types in Codable.
// You might include this in your actual project or simplify if your model is strictly defined.
struct AnyCodable: Codable {
    let value: Any

    init<T>(_ value: T) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            value = intValue
        } else if let doubleValue = try? container.decode(Double.self) {
            value = doubleValue
        } else if let stringValue = try? container.decode(String.self) {
            value = stringValue
        } else if let boolValue = try? container.decode(Bool.self) {
            value = boolValue
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "AnyCodable cannot decode value")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let intValue = value as? Int {
            try container.encode(intValue)
        } else if let doubleValue = value as? Double {
            try container.encode(doubleValue)
        } else if let stringValue = value as? String {
            try container.encode(stringValue)
        } else if let boolValue = value as? Bool {
            try container.encode(boolValue)
        } else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "AnyCodable cannot encode value"))
        }
    }
}


// MARK: - Performance Test Functions

func measureTime(block: () -> Void) -> TimeInterval {
    let startTime = CFAbsoluteTimeGetCurrent()
    block()
    let endTime = CFAbsoluteTimeGetCurrent()
    return endTime - startTime
}

// MARK: - Test Execution

let numberOfModelsToGenerate = 100 // Adjust this number for deeper testing

print("Starting performance test with \(numberOfModelsToGenerate) complex models...")

// --- Implicit Declaration Test ---
print("\n--- Implicit Declaration ---")
let implicitTime = measureTime {
    var implicitModels = [BigAndComplexModel]()
    for _ in 0..<numberOfModelsToGenerate {
        // Here, `BigAndComplexModel()` is assigned without explicit type
        let model = BigAndComplexModel()
        implicitModels.append(model)
    }
    _ = implicitModels // Ensure the models are retained and not optimized away
}
print(String(format: "Implicit declaration time: %.4f seconds", implicitTime))


// --- Explicit Declaration Test ---
print("\n--- Explicit Declaration ---")
let explicitTime = measureTime {
    var explicitModels: [BigAndComplexModel] = [] // Explicit type for the array
    for _ in 0..<numberOfModelsToGenerate {
        // Here, `BigAndComplexModel()` is assigned to an explicitly typed constant
        let model: BigAndComplexModel = BigAndComplexModel()
        explicitModels.append(model)
    }
    _ = explicitModels // Ensure the models are retained and not optimized away
}
print(String(format: "Explicit declaration time: %.4f seconds", explicitTime))

print("\n--- Summary ---")
if implicitTime < explicitTime {
    print(String(format: "Implicit was %.4f seconds faster.", explicitTime - implicitTime))
} else if explicitTime < implicitTime {
    print(String(format: "Explicit was %.4f seconds faster.", implicitTime - explicitTime))
} else {
    print("Both implicit and explicit declarations took approximately the same time.")
}
