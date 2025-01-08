import Foundation

let repeatTimesInfinity: Int = 100

struct Tracks {
    static let constant: String = "constant"
    static let increasing: String = "increasing"
    static let decreasing: String = "decreasing"
    static let custom: String = "custom"
}

struct Phases {
    static let `in`: String = "in"
    static let inHold: String = "inhold"
    static let out: String = "out"
    static let outHold: String = "outhold"
    
    static func list() -> [String] {
        [`in`, inHold, out, outHold]
    }
}

struct ExerciseModel: Equatable, Codable {
    var id: String
    var title: String
    
    var track: String
    
    var constantTrack: ConstantTrackModel
    var increasingTrack: IncreasingTrackModel
    var decreasingTrack: DecreasingTrackModel
    var customTrack: CustomTrackModel
}

// struct ExerciseCustomTrackModel: Codable, Equatable {
//     var steps: [ExerciseTrackStepModel] = [
//         .init(viewId: UUID().uuidString, viewIdx: 0, in: 1, inHold: 0, out: 1, outHold: 0)
//     ]
//     
//     mutating func appendStep(_ s: ExerciseTrackStepModel) {
//         steps.append(.init(viewId: UUID().uuidString, viewIdx: steps.count, in: s.in, inHold: s.inHold, out: s.out, outHold: s.outHold))
//     }
//     
//     mutating func removeStep(_ viewId: String) {
//         steps.removeAll { s in
//             s.viewId == viewId
//         }
//         
//         for i in steps.indices {
//             steps[i].viewIdx = i
//         }
//     }
//     
//     mutating func clearSteps() {
//         steps.removeAll()
//     }
// }
