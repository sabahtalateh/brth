import Foundation

struct PhaseTiming {
    var phase: Phase
    var startSecond: Int
    var duration: Int
}

typealias PhaseTimings = [PhaseTiming]

extension PhaseTimings {
    mutating func add(phase: Phase, duration: Int) {
        let startS = self.endIndex
        for _ in 0..<duration {
            self.append(PhaseTiming(phase: phase, startSecond: startS, duration: duration))
        }
    }
}

struct ExerciseProgress {
    var phase: Phase = .in
    var phaseElapsed: Double = 0
    var phaseDuration: Double = 0
    var done: Bool = false
}

class ExerciseTimeline {
    
    private var timings: PhaseTimings = []
    private var infiniteRepeat: Bool = false
    
    func progress(_ elapsed: TimeInterval) -> ExerciseProgress {
        
        var elapsedS = Int(elapsed)
        
        // Will be set only for infinite exercises
        var fullCyclesPassedTime: Int = 0
        
        if !self.infiniteRepeat {
            if timings.count - 1 < elapsedS {
                return ExerciseProgress(done: true)
            }
        } else {
            let td = self.timings.endIndex
            if self.infiniteRepeat && td != 0 {
                fullCyclesPassedTime = elapsedS / td * td
                elapsedS = elapsedS % td
            }
        }
        
        let phaseT = timings[elapsedS]
        
        let elapsedOfPhase = elapsed - Double(phaseT.startSecond) - Double(fullCyclesPassedTime)
        
        let p = ExerciseProgress(
            phase: phaseT.phase,
            phaseElapsed: elapsedOfPhase,
            phaseDuration: Double(phaseT.duration)
        )
        
        return p
    }
    
    static func forModel(_ e: ExerciseModel) -> ExerciseTimeline {
        switch e.track {
        case .constant:
            forConstant(e.constantTrack)
        case .increasing:
            forDynamic(e.increasingTrack)
        case .decreasing:
            forDynamic(e.decreasingTrack)
        default:
            ExerciseTimeline()
        }
    }
    
    private static func forConstant(_ m: ConstantTrackModel) -> ExerciseTimeline {
        
        let etl: ExerciseTimeline = .init()
        
        var timings: PhaseTimings = []
        
        for _ in 0..<m.repeatTimes {
            timings.add(phase: .in, duration: m.in)
            timings.add(phase: .inHold, duration: m.inHold)
            timings.add(phase: .out, duration: m.out)
            timings.add(phase: .outHold, duration: m.outHold)
            
            if m.repeatTimes.isInfiniteRepeatTimes() {
                etl.infiniteRepeat = true
                break
            }
        }
        
        etl.timings = timings
        
        return etl
    }
    
    private static func forDynamic(_ mdl: DynamicTrackModel) -> ExerciseTimeline {
        if !mdl.needToIterate() {
            return ExerciseTimeline()
        }
        
        var m = mdl
        
        let etl: ExerciseTimeline = .init()
        var timings: PhaseTimings = []
        
        while true {
            timings.add(phase: .in, duration: m.in)
            timings.add(phase: .inHold, duration: m.inHold)
            timings.add(phase: .out, duration: m.out)
            timings.add(phase: .outHold, duration: m.outHold)
            
            if m.limitReached() {
                break
            }
            
            m.addToDynPhaseDuration(m.add)
        }
        
        etl.timings = timings
        
        return etl
    }
}
