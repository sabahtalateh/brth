struct IncreasingTrackModel: Codable, Equatable {
    var `in`: Int
    var inHold: Int
    var out: Int
    var outHold: Int

    var increasePhase: String
    var increaseTo: Int
    var increaseBy: Int
}

extension IncreasingTrackModel {
    static func `default`() -> IncreasingTrackModel {
        IncreasingTrackModel(
            in: 1,
            inHold: 0,
            out: 1,
            outHold: 0,
            increasePhase: Phases.in,
            increaseTo: 10,
            increaseBy: 1
        )
    }
}
