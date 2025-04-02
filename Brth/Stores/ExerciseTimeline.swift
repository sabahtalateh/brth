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

struct ProgressIcon: Equatable, Identifiable {
    var id: Int
    var phase: Phase
}

struct ExerciseProgress {
    var phase: Phase = .in
    var phaseElapsed: Double = 0
    var phaseDuration: Double = 0
    var phaseProgress: Double = 0
    
    var elapsed: Double = 0
    var duration: ExerciseDuration = .seconds(0)
    
    var icons: [ProgressIcon] = []
}

class ExerciseTimeline {
    
    private var exercise: ExerciseModel = .empty()
    private var timings: PhaseTimings = []
    private var icons: [[ProgressIcon]] = []
    private var infiniteRepeat: Bool = false
    
    /// Second return value indicates if exercise done
    func progressOn(_ elapsed: TimeInterval) -> (ExerciseProgress, Bool) {
        
        var elapsedS = Int(elapsed)
        if elapsedS < 0 {
            elapsedS = 0
        }
        
        // Will be set only for infinite exercises
        var fullCyclesPassedTime: Int = 0
        
        if !self.infiniteRepeat {
            if timings.count - 1 < elapsedS {
                return (.init(elapsed: elapsed, duration: self.exercise.duration), true)
            }
        } else {
            let lastSecond = self.timings.endIndex
            if self.infiniteRepeat && lastSecond != 0 {
                fullCyclesPassedTime = elapsedS / lastSecond * lastSecond
                elapsedS = elapsedS % lastSecond
            }
        }
        
        let phaseT = timings[elapsedS]
        
        let elapsedOfPhase = elapsed - Double(phaseT.startSecond) - Double(fullCyclesPassedTime)
        
        let p = ExerciseProgress(
            phase: phaseT.phase,
            phaseElapsed: elapsedOfPhase,
            phaseDuration: Double(phaseT.duration),
            phaseProgress: elapsedOfPhase / Double(phaseT.duration),
            elapsed: elapsed,
            duration: self.exercise.duration,
            icons: getIcons(Int(elapsed))
        )
        
        return (p, false)
    }
    
    func progressOnEnd() -> ExerciseProgress {
        switch self.exercise.duration {
        case .infinity:
                .init(elapsed: 0, duration: .infinity, icons: getIcons(0))
        case .seconds(let secs):
                .init(elapsed: Double(secs), duration: .seconds(secs), icons: getIcons(secs))
        }
    }
    
    static func forExercise(_ e: ExerciseModel) -> ExerciseTimeline {
        let timeline = switch e.track {
        case .constant:
            forConstant(e.constantTrack)
        case .increasing:
            forDynamic(e.increasingTrack)
        case .decreasing:
            forDynamic(e.decreasingTrack)
        case .custom:
            forCustom(e.customTrack)
        }
        
        timeline.exercise = e
        timeline.populateIcons()
        
        return timeline
    }
    
    private func populateIcons() {
        // [(phase duration, phase name)]
        var phasesTimings: [(Int, Phase)] = []
        var lastPhase: Phase?
        
        for i in 0..<timings.count {
            let t = timings[i]
            
            if t.phase == lastPhase {
                continue
            }
            
            phasesTimings.append((i, t.phase))
            lastPhase = t.phase
        }
        
        var lastId = 0
        for i in 0..<phasesTimings.count {
            let phase = phasesTimings[i]
            lastId = i
            
            var phases: [ProgressIcon] = [ProgressIcon(id: i, phase: phase.1)]
            
            for ii in 1..<4 {
                var nextPhaseIndex = i + ii
                if exercise.duration == .infinity {
                    nextPhaseIndex = nextPhaseIndex % phasesTimings.count
                }
                
                if phasesTimings.count > nextPhaseIndex {
                    phases.append(ProgressIcon(id: lastId + ii, phase: phasesTimings[nextPhaseIndex].1))
                }
            }
            
            var elems = 0
            if phasesTimings.count > i + 1 {
                let nextPhase = phasesTimings[i+1]
                elems = nextPhase.0 - phase.0
            } else {
                elems = self.timings.count - phase.0
            }
            
            for _ in 0..<elems {
                icons.append(phases)
            }
        }
    }
    
    private func getIcons(_ elapsedS: Int) -> [ProgressIcon] {
        if icons.count > elapsedS {
            return icons[elapsedS]
        }
        return []
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
        
        if !mdl.playable() {
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
    
    private static func forCustom(_ m: CustomTrackModel) -> ExerciseTimeline {
        let etl: ExerciseTimeline = .init()
        var timings: PhaseTimings = []
        
        for s in m.steps {
            timings.add(phase: .in, duration: s.in)
            timings.add(phase: .inHold, duration: s.inHold)
            timings.add(phase: .out, duration: s.out)
            timings.add(phase: .outHold, duration: s.outHold)
        }
        
        etl.timings = timings
        
        return etl
    }
}
