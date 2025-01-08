import SwiftUI

struct PhaseTitles {
    static var `in`: String = "breathe in"
    static var inHold: String = "breathe in hold"
    static var out: String = "breathe out"
    static var outHold: String = "breathe out hold"
    
    static func title(for phase: String) -> String {
        switch phase {
        case Phases.in: `in`
        case Phases.inHold: inHold
        case Phases.out: out
        case Phases.outHold: outHold
        default: `in`
        }
    }
}

struct PhaseIcons {
    static let `in`: Image = Image("custom.circle.circle.2")
    static let inHold: Image = Image(systemName: "circle.fill")
    static let out: Image = Image("custom.circle.circle.fill")
    static let outHold: Image = Image(systemName: "circle")
    
    static func icon(for phase: String) -> Image {
        switch phase {
        case Phases.in: `in`
        case Phases.inHold: inHold
        case Phases.out: out
        case Phases.outHold: outHold
        default: `in`
        }
    }
}

enum ExerciseDuration: Equatable {
    case infinity
    case seconds(Int)
}

extension ConstantTrackModel {
    func duration() -> ExerciseDuration {
        if self.repeatTimes == repeatTimesInfinity {
            return .infinity
        }
        
        let cycleDur = self.in + self.inHold + self.out + self.outHold
        return .seconds(cycleDur * self.repeatTimes)
    }
}

extension IncreasingTrackModel {
    func initialDuration() -> Int {
        return switch self.increasePhase {
        case Phases.in:
            self.in
        case Phases.inHold:
            self.inHold
        case Phases.out:
            self.out
        case Phases.outHold:
            self.outHold
        default:
            0
        }
    }
    
    func duration() -> ExerciseDuration {
        let initial = self.initialDuration()
        let diff = self.increaseTo - initial
        
        if diff <= 0 {
            return .seconds(0)
        }
        
        let cycles = Int(ceil(Double(diff) / Double(self.increaseBy))) + 1
        
        var dur: Int = 0
        for i in 0..<cycles {
            let incBy = i * increaseBy
            
            let increased = switch self.increasePhase {
            case Phases.in:
                min(increaseTo, `in` + incBy)
            case Phases.inHold:
                min(increaseTo, inHold + incBy)
            case Phases.out:
                min(increaseTo, out + incBy)
            case Phases.outHold:
                min(increaseTo, outHold + incBy)
            default:
                0
            }
            
            let rest = switch self.increasePhase {
            case Phases.in:
                inHold + out + outHold
            case Phases.inHold:
                `in` + out + outHold
            case Phases.out:
                `in` + inHold + outHold
            case Phases.outHold:
                `in` + inHold + out
            default:
                0
            }
            
            dur += increased + rest
        }
        
        return .seconds(dur)
    }
}

extension DecreasingTrackModel {
    func initialDuration() -> Int {
        return switch self.decreasePhase {
        case Phases.in:
            self.in
        case Phases.inHold:
            self.inHold
        case Phases.out:
            self.out
        case Phases.outHold:
            self.outHold
        default:
            0
        }
    }
    
    func duration() -> ExerciseDuration {
        let initial = self.initialDuration()
        let diff = initial - self.decreaseTo
        
        if diff <= 0 {
            return .seconds(0)
        }
        
        let cycles = Int(ceil(Double(diff) / Double(self.decreaseBy))) + 1
        
        var dur: Int = 0
        for i in 0..<cycles {
            let decBy = i * decreaseBy
        
            let decreased = switch self.decreasePhase {
            case Phases.in:
                max(decreaseTo, `in` - decBy)
            case Phases.inHold:
                max(decreaseTo, inHold - decBy)
            case Phases.out:
                max(decreaseTo, out - decBy)
            case Phases.outHold:
                max(decreaseTo, outHold - decBy)
            default:
                0
            }
            
            let rest = switch self.decreasePhase {
            case Phases.in:
                inHold + out + outHold
            case Phases.inHold:
                `in` + out + outHold
            case Phases.out:
                `in` + inHold + outHold
            case Phases.outHold:
                `in` + inHold + out
            default:
                0
            }
            
            dur += decreased + rest
        }
        
        return .seconds(dur)
    }
}

extension CustomTrackModel {
    func duration() -> ExerciseDuration {
        var dur = 0
        
        for s in self.steps {
            dur += s.in + s.inHold + s.out + s.outHold
        }
        
        return .seconds(dur)
    }
}

extension ExerciseModel {
    func duration() -> ExerciseDuration {
        switch self.track {
        case Tracks.constant:
            self.constantTrack.duration()
        case Tracks.increasing:
            self.increasingTrack.duration()
        case Tracks.decreasing:
            self.decreasingTrack.duration()
        case Tracks.custom:
            self.customTrack.duration()
        default:
                .seconds(0)
        }
    }
}
