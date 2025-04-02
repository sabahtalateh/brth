enum ExerciseDuration: Equatable {
    case infinity
    case seconds(Int)
}

extension ConstantTrackModel {
    func duration() -> ExerciseDuration {
        if repeatTimes.isInfiniteRepeatTimes() {
            return .infinity
        }
        
        let cycleDur = `in` + inHold + out + outHold
        return .seconds(cycleDur * repeatTimes)
    }
}

extension DynamicTrackModel {
    func dynPhaseDuration() -> Int {
        switch dynPhase {
        case .in:
            `in`
        case .inHold:
            inHold
        case .out:
            out
        case .outHold:
            outHold
        }
    }
    
    mutating func addToDynPhaseDuration(_ add: Int) {
        switch dynPhase {
        case .in:
            if add > 0 {
                `in` = min(`in` + add, limit)
            } else {
                `in` = max(`in` + add, limit)
            }
        case .inHold:
            if add > 0 {
                inHold = min(inHold + add, limit)
            } else {
                inHold = max(inHold + add, limit)
            }
        case .out:
            if add > 0 {
                out = min(out + add, limit)
            } else {
                out = max(out + add, limit)
            }
        case .outHold:
            if add > 0 {
                outHold = min(outHold + add, limit)
            } else {
                outHold = max(outHold + add, limit)
            }
        }
    }
    
    func limitReached() -> Bool {
        return dynPhaseDuration() == limit
    }
    
    func playable() -> Bool {
        if add == 0 {
            return false
        }
        
        if limitReached() {
            return false
        }
        
        if add > 0 && dynPhaseDuration() > limit {
            return false
        }
        
        if add < 0 && dynPhaseDuration() < limit {
            return false
        }
        
        return true
    }
    
    func duration() -> ExerciseDuration {
        
        if !playable() {
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

extension CustomTrackModel {
    func duration() -> ExerciseDuration {
        var dur = 0
        
        for s in self.steps {
            dur += s.in + s.inHold + s.out + s.outHold
        }
        
        return .seconds(dur)
    }
}
