import Foundation

struct ExerciseProgress {
    var phase: String = Phases.in
    var phaseElapsed: Double = 0
    var phaseTotal: Double = 0
    var done: Bool = false
}

class ExerciseTimeline {
    
    // [Phase Start Second: (Phase, Phase Duration)]
    private var timeline: [Int: (String, Int)] = [:]
    private var totalDuration: Int = 0
    private var infiniteRepeat: Bool = false
    
    func progress(_ elapsed: TimeInterval) -> ExerciseProgress {
        var elapsedS = Int(elapsed)
        
        if elapsedS >= self.totalDuration {
            return ExerciseProgress(done: true)
        }
        
        // Will be set only for infinite exercises
        var fullCyclesPassedTime: Int = 0
        let td = self.totalDuration
        if self.infiniteRepeat && td != 0 {
            fullCyclesPassedTime = elapsedS / td * td
            elapsedS = elapsedS % td
        }
        
        var phase: (String, Int)
        while true {
            if elapsedS < 0 {
                return ExerciseProgress()
            }
            
            if let p = self.timeline[elapsedS] {
                phase = p
                break
            } else {
                elapsedS = elapsedS - 1
            }
        }
        
        let (phaseName, phaseStartS) = phase
        
        let elapsedOfPhase = elapsed - Double(elapsedS) - Double(fullCyclesPassedTime)
        let totalOfPhase = Double(phaseStartS)
        
        let p = ExerciseProgress(
            phase: phaseName,
            phaseElapsed: elapsedOfPhase,
            phaseTotal: totalOfPhase
        )
        
        return p
    }
    
    static func forModel(_ e: ExerciseModel) -> ExerciseTimeline {
        switch e.track {
        case Tracks.constant:
            forConstant(e.constantTrack)
        case Tracks.increasing:
            forIncreasing(e.increasingTrack)
        default:
            ExerciseTimeline()
        }
    }
    
    private static func forConstant(_ m: ConstantTrackModel) -> ExerciseTimeline {
        var sec = 0
        
        let etl: ExerciseTimeline = .init()
        var tl: [Int: (String, Int)] = [:]
        
        for _ in 0..<m.repeatTimes {
            if m.in != 0 {
                tl[sec] = (Phases.in, m.in)
                sec += m.in
            }
            if m.inHold != 0 {
                tl[sec] = (Phases.inHold, m.inHold)
                sec += m.inHold
            }
            if m.out != 0 {
                tl[sec] = (Phases.out, m.out)
                sec += m.out
            }
            if m.outHold != 0 {
                tl[sec] = (Phases.outHold, m.outHold)
                sec += m.outHold
            }
            
            etl.totalDuration += m.in + m.inHold + m.out + m.outHold
            
            if m.repeatTimes == repeatTimesInfinity {
                etl.infiniteRepeat = true
                break
            }
        }
        
        etl.timeline = tl
        
        return etl
    }
    
    private static func forIncreasing(_ mdl: IncreasingTrackModel) -> ExerciseTimeline {
        var m = mdl
        
        var sec = 0
        
        let etl: ExerciseTimeline = .init()
        var tl: [Int: (String, Int)] = [:]

    L:
        while true {
            let increased = switch m.increasePhase {
            case Phases.in:
                m.in
            case Phases.inHold:
                m.inHold
            case Phases.out:
                m.out
            case Phases.outHold:
                m.outHold
            default:
                0
            }
            
            if m.in != 0 {
                tl[sec] = (Phases.in, m.in)
                sec += m.in
            }
            if m.inHold != 0 {
                tl[sec] = (Phases.inHold, m.inHold)
                sec += m.inHold
            }
            if m.out != 0 {
                tl[sec] = (Phases.out, m.out)
                sec += m.out
            }
            if m.outHold != 0 {
                tl[sec] = (Phases.outHold, m.outHold)
                sec += m.outHold
            }
            
            etl.totalDuration += m.in + m.inHold + m.out + m.outHold
            
            if increased >= m.increaseTo {
                break L
            }
            
            switch m.increasePhase {
            case Phases.in:
                m.in = min(m.in + m.increaseBy, m.increaseTo)
            case Phases.inHold:
                m.inHold = min(m.inHold + m.increaseBy, m.increaseTo)
            case Phases.out:
                m.out = min(m.out + m.increaseBy, m.increaseTo)
            case Phases.outHold:
                m.outHold = min(m.outHold + m.increaseBy, m.increaseTo)
            default:
                ()
            }
        }
        
        etl.timeline = tl
        
        return etl
    }
}
