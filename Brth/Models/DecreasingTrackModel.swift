struct DecreasingTrackModel: Codable, Equatable {
    var `in`: Int
    var inHold: Int
    var out: Int
    var outHold: Int

    var decreasePhase: String
    var decreaseTo: Int
    var decreaseBy: Int
}

extension DecreasingTrackModel {
    static func `default`() -> DecreasingTrackModel {
        DecreasingTrackModel(
            in: 10,
            inHold: 0,
            out: 1,
            outHold: 0,
            decreasePhase: Phases.in,
            decreaseTo: 1,
            decreaseBy: 1
        )
    }
}
