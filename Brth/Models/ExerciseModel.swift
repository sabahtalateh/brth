import Foundation

extension Int {
    static func infiniteRepeatTimes() -> Self {
        return 100
    }
    
    func isInfiniteRepeatTimes() -> Bool {
        return self == 100
    }
}

enum Track: Decodable, Encodable {
    case constant
    case increasing
    case decreasing
    case custom
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let val = try container.decode(String.self)
        
        switch val {
        case "constant":
            self = .constant
        case "increasing":
            self = .increasing
        case "decreasing":
            self = .decreasing
        case "custom":
            self = .custom
        default:
            self = .constant
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .constant:
            try container.encode("constant")
        case .increasing:
            try container.encode("increasing")
        case .decreasing:
            try container.encode("decreasing")
        case .custom:
            try container.encode("custom")
        }
    }
}

enum Phase: Decodable, Encodable, CaseIterable {
    case `in`
    case inHold
    case out
    case outHold
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let val = try container.decode(String.self)
        
        switch val {
        case "in":
            self = .in
        case "in_hold":
            self = .inHold
        case "out":
            self = .out
        case "out_hold":
            self = .outHold
        default:
            self = .in
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .in:
            try container.encode("in")
        case .inHold:
            try container.encode("in_hold")
        case .out:
            try container.encode("out")
        case .outHold:
            try container.encode("out_hold")
        }
    }
}

struct ConstantTrackModel: Equatable, Codable {
    var `in`: Int
    var inHold: Int
    var out: Int
    var outHold: Int
    
    var repeatTimes: Int
}

struct DynamicTrackModel: Codable, Equatable {
    var `in`: Int
    var inHold: Int
    var out: Int
    var outHold: Int

    var dynPhase: Phase
    var add: Int
    var limit: Int
}

struct CustomTrackModel: Codable, Equatable {
    var steps: [TrackStepModel]
    
    mutating func addStep() {
        steps.append(TrackStepModel(
            id: UUID().uuidString,
            in: 1,
            inHold: 0,
            out: 1,
            outHold: 0
        ))
    }
    
    mutating func removeStep(_ id: String) {
        steps.removeAll { m in m.id == id }
    }
}

struct TrackStepModel: Codable, Equatable {
    var id: String

    var `in`: Int
    var inHold: Int
    var out: Int
    var outHold: Int
}

struct ExerciseModel: Equatable, Codable {
    var id: String
    var title: String
    
    var track: Track
    
    var constantTrack: ConstantTrackModel
    var increasingTrack: DynamicTrackModel
    var decreasingTrack: DynamicTrackModel
    var customTrack: CustomTrackModel
}
