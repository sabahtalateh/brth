import Foundation

extension ConstantTrackModel {
    static func `default`() -> ConstantTrackModel {
        return ConstantTrackModel(in: 5, inHold: 0, out: 5, outHold: 0, repeatTimes: 10)
    }
}

extension DynamicTrackModel {
    static func defaultIncreasing() -> DynamicTrackModel {
        DynamicTrackModel(
            in: 1,
            inHold: 0,
            out: 1,
            outHold: 0,
            dynPhase: .in,
            add: 1,
            limit: 10
        )
    }
    
    static func defaultDecreasing() -> DynamicTrackModel {
        DynamicTrackModel(
            in: 10,
            inHold: 0,
            out: 1,
            outHold: 0,
            dynPhase: .in,
            add: -1,
            limit: 1
        )
    }
}

extension CustomTrackModel {
    static func `default`() -> CustomTrackModel {
        CustomTrackModel(steps: [
            TrackStepModel(id: UUID().uuidString, in: 1, inHold: 0, out: 1, outHold: 0)
        ])
    }
}
