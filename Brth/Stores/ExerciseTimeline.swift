import Foundation

struct PhaseProgress {
    var phase: String = ""
    var elapsed: Double = 0
    var total: Double = 0
    // var exceeded: Bool = false
}

class ExerciseTimeline {
    
    // [Phase Start Second: (Phase, Phase Duration)]
    private var timeline: [Int: (String, Int)] = [:]
    private var totalDuration: Int = 0
    private var infiniteRepeat: Bool = false
    
    func progress(_ elapsed: TimeInterval) -> PhaseProgress {
        var elapsedS = Int(elapsed)
        
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
                return PhaseProgress()
            }
            
            if let p = self.timeline[elapsedS] {
                phase = p
                break
            } else {
                elapsedS = elapsedS - 1
            }
        }
        
        let elapsedOfPhase = elapsed - Double(elapsedS) - Double(fullCyclesPassedTime)
        let totalOfPhase = Double(phase.1)
        
        let p = PhaseProgress(
            phase: phase.0,
            elapsed: elapsedOfPhase,
            total: totalOfPhase
        //     exceeded: elapsedSecsOfPhase > totalSecsOfPhase
        )
        
        return p
    }
    
    static func forModel(_ e: ExerciseModel) -> ExerciseTimeline {
        switch e.track {
        case Tracks.constant:
            forConstant(e.constantTrack)
        default:
            ExerciseTimeline()
        }
    }
    
    private static func forConstant(_ t: ConstantTrackModel) -> ExerciseTimeline {
        var sec = 0
        
        var etl: ExerciseTimeline = .init()
        var tl: [Int: (String, Int)] = [:]
        
        for _ in 0..<t.repeatTimes {
            if t.in != 0 {
                tl[sec] = (Phases.in, t.in)
                sec += t.in
            }
            if t.inHold != 0 {
                tl[sec] = (Phases.inHold, t.inHold)
                sec += t.inHold
            }
            if t.out != 0 {
                tl[sec] = (Phases.out, t.out)
                sec += t.out
            }
            if t.outHold != 0 {
                tl[sec] = (Phases.outHold, t.outHold)
                sec += t.outHold
            }
            
            etl.totalDuration += t.in + t.inHold + t.out + t.outHold
            
            if t.repeatTimes == repeatTimesInfinity {
                etl.infiniteRepeat = true
                break
            }
        }
        
        etl.timeline = tl
        
        return etl
    }
}
