struct ConstantTrackModel: Equatable, Codable {
    var `in`: Int
    var inHold: Int
    var out: Int
    var outHold: Int
    
    var repeatTimes: Int
}

extension ConstantTrackModel {
    static func `default`() -> ConstantTrackModel {
        return ConstantTrackModel(in: 5, inHold: 0, out: 5, outHold: 0, repeatTimes: 10)
    }
}
