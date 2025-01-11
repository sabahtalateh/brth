import SwiftUI

struct PhaseTitles {
    static var `in`: String = "breathe in"
    static var inHold: String = "breathe in hold"
    static var out: String = "breathe out"
    static var outHold: String = "breathe out hold"
    
    static func title(for phase: Phase) -> String {
        switch phase {
        case .in: `in`
        case .inHold: inHold
        case .out: out
        case .outHold: outHold
        }
    }
}

struct PhaseIcons {
    static let `in`: Image = Image("custom.circle.circle.2")
    static let inHold: Image = Image(systemName: "circle.fill")
    static let out: Image = Image("custom.circle.circle.fill")
    static let outHold: Image = Image(systemName: "circle")
    
    static func icon(for phase: Phase) -> Image {
        switch phase {
        case .in: `in`
        case .inHold: inHold
        case .out: out
        case .outHold: outHold
        }
    }
}

enum ExerciseDuration: Equatable {
    case infinity
    case seconds(Int)
}

extension ConstantTrackModel {
    func duration() -> ExerciseDuration {
        if self.repeatTimes.isInfiniteRepeatTimes() {
            return .infinity
        }
        
        let cycleDur = self.in + self.inHold + self.out + self.outHold
        return .seconds(cycleDur * self.repeatTimes)
    }
}

extension DynamicTrackModel {
    func dynPhaseDuration() -> Int {
        switch self.dynPhase {
        case .in:
            self.in
        case .inHold:
            self.inHold
        case .out:
            self.out
        case .outHold:
            self.outHold
        }
    }
    
    mutating func addToDynPhaseDuration(_ add: Int) {
        switch self.dynPhase {
        case .in:
            if add > 0 {
                self.in = min(self.in + add, self.limit)
            } else {
                self.in = max(self.in + add, self.limit)
            }
        case .inHold:
            if add > 0 {
                self.inHold = min(self.inHold + add, self.limit)
            } else {
                self.inHold = max(self.inHold + add, self.limit)
            }
        case .out:
            if add > 0 {
                self.out = min(self.out + add, self.limit)
            } else {
                self.out = max(self.out + add, self.limit)
            }
        case .outHold:
            if add > 0 {
                self.outHold = min(self.outHold + add, self.limit)
            } else {
                self.outHold = max(self.outHold + add, self.limit)
            }
        }
    }
    
    func limitReached() -> Bool {
        return self.dynPhaseDuration() == limit
    }
    
    func needToIterate() -> Bool {
        if self.add == 0 {
            return false
        }
        
        if self.limitReached() {
            return false
        }
        
        if self.add > 0 && self.dynPhaseDuration() > self.limit {
            return false
        }
        
        if self.add < 0 && self.dynPhaseDuration() < self.limit {
            return false
        }
        
        return true
    }
    
    func duration() -> ExerciseDuration {
        if !self.needToIterate() {
            return .seconds(0)
        }
        
        var sum: Int = 0
        var copy = self
        
        while true {
            sum += copy.in
            sum += copy.inHold
            sum += copy.out
            sum += copy.outHold
            
            if copy.limitReached() {
                break
            }
            
            copy.addToDynPhaseDuration(copy.add)
        }
        
        return .seconds(sum)
    }
}

// extension IncreasingTrackModel {
//     func increasingPhaseDuration() -> Int {
//         return switch self.increasePhase {
//         case .in:
//             self.in
//         case .inHold:
//             self.inHold
//         case .out:
//             self.out
//         case .outHold:
//             self.outHold
//         }
//     }
//     
//     func increasedPhaseDuration(_ incBy: Int) -> Int {
//         min(self.increaseTo, increasingPhaseDuration() + incBy)
//     }
//     
//     mutating func increasePhaseDuration(_ incBy: Int) {
//         switch self.increasePhase {
//         case .in:
//             self.in = min(self.in + incBy, self.increaseTo)
//         case .inHold:
//             self.inHold = min(self.inHold + incBy, self.increaseTo)
//         case .out:
//             self.out = min(self.out + incBy, self.increaseTo)
//         case .outHold:
//             self.outHold = min(self.outHold + incBy, self.increaseTo)
//         }
//     }
//     
//     func duration() -> ExerciseDuration {
//         let initial = self.increasingPhaseDuration()
//         let diff = self.increaseTo - initial
//         
//         if diff <= 0 {
//             return .seconds(0)
//         }
//         
//         let cycles = Int(ceil(Double(diff) / Double(self.increaseBy))) + 1
//         
//         var dur: Int = 0
//         for i in 0..<cycles {
//             let incBy = i * increaseBy
//             let increased = increasedPhaseDuration(incBy)
//             
//             let rest = switch self.increasePhase {
//             case .in:
//                 inHold + out + outHold
//             case .inHold:
//                 `in` + out + outHold
//             case .out:
//                 `in` + inHold + outHold
//             case .outHold:
//                 `in` + inHold + out
//             }
//             
//             dur += increased + rest
//         }
//         
//         return .seconds(dur)
//     }
// }

// extension DecreasingTrackModel {
//     
//     func decreasingPhaseDuration() -> Int {
//         return switch self.decreasePhase {
//         case .in:
//             self.in
//         case .inHold:
//             self.inHold
//         case .out:
//             self.out
//         case .outHold:
//             self.outHold
//         }
//     }
//     
//     func decreasedPhaseDuration(_ decBy: Int) -> Int {
//         min(self.decreaseTo, decreasingPhaseDuration() - decBy)
//     }
//     
//     mutating func decreasePhaseDuration(_ decBy: Int) {
//         switch self.decreasePhase {
//         case .in:
//             self.in = max(self.in - decBy, self.decreaseTo)
//         case .inHold:
//             self.inHold = max(self.inHold - decBy, self.decreaseTo)
//         case .out:
//             self.out = max(self.out - decBy, self.decreaseTo)
//         case .outHold:
//             self.outHold = max(self.outHold - decBy, self.decreaseTo)
//         }
//     }
//     
//     func duration() -> ExerciseDuration {
//         let initial = self.decreasingPhaseDuration()
//         let diff = initial - self.decreaseTo
//         
//         if diff <= 0 {
//             return .seconds(0)
//         }
//         
//         let cycles = Int(ceil(Double(diff) / Double(self.decreaseBy))) + 1
//         
//         var dur: Int = 0
//         for i in 0..<cycles {
//             let decBy = i * decreaseBy
//             let decreased = self.decreasedPhaseDuration(decBy)
//             
//             let rest = switch self.decreasePhase {
//             case .in:
//                 inHold + out + outHold
//             case .inHold:
//                 `in` + out + outHold
//             case .out:
//                 `in` + inHold + outHold
//             case .outHold:
//                 `in` + inHold + out
//             }
//             
//             dur += decreased + rest
//         }
//         
//         return .seconds(dur)
//     }
// }

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
        case .constant:
            self.constantTrack.duration()
        case .increasing:
                .seconds(999)
            // self.increasingTrack.duration()
        case .decreasing:
            // self.decreasingTrack.duration()
                .seconds(999)
        case .custom:
            self.customTrack.duration()
        }
    }
}
