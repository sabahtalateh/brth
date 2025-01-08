import Foundation

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
    // var viewIdx: Int

    var `in`: Int
    var inHold: Int
    var out: Int
    var outHold: Int
}

extension CustomTrackModel {
    static func `default`() -> CustomTrackModel {
        CustomTrackModel(steps: [
            TrackStepModel(id: UUID().uuidString, in: 1, inHold: 0, out: 1, outHold: 0)
        ])
    }
}
