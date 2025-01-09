import Testing
import Foundation

@testable import Brth

extension ExerciseProgress: @retroactive Equatable {
    public static func == (lhs: ExerciseProgress, rhs: ExerciseProgress) -> Bool {
        return lhs.phase == rhs.phase &&
        lhs.phaseElapsed.isAlmostEqual(to: rhs.phaseElapsed) &&
        lhs.phaseTotal.isAlmostEqual(to: rhs.phaseTotal)
    }
}

func prog(_ p: String, _ pe: Double, _ pt: Double, _ d: Bool = false) -> ExerciseProgress {
    ExerciseProgress(phase: p, phaseElapsed: pe, phaseTotal: pt, done: d)
}

struct ExerciseTimelineTests {
    
    @Test func testConstant() async throws {
        let m = ExerciseModel(
            id: UUID().uuidString,
            title: "", track: Tracks.constant,
            constantTrack: ConstantTrackModel(
                in: 3,
                inHold: 0,
                out: 2,
                outHold: 0,
                repeatTimes: 2
            ),
            increasingTrack: .default(),
            decreasingTrack: .default(),
            customTrack: .default()
        )
        
        let timeline: ExerciseTimeline = .forModel(m)
        
        // First cycle
        #expect(timeline.progress(0) == prog(Phases.in, 0, 3))
        #expect(timeline.progress(0.5) == prog(Phases.in, 0.5, 3))
        #expect(timeline.progress(1) == prog(Phases.in, 1, 3))
        #expect(timeline.progress(2) == prog(Phases.in, 2, 3))
        
        #expect(timeline.progress(3) == prog(Phases.out, 0, 2))
        #expect(timeline.progress(3.1) == prog(Phases.out, 0.1, 2))
        #expect(timeline.progress(3.5) == prog(Phases.out, 0.5, 2))
        #expect(timeline.progress(4) == prog(Phases.out, 1, 2))
        #expect(timeline.progress(4.999) == prog(Phases.out, 1.999, 2))
        
        // Repeats every 5 second
        #expect(timeline.progress(5) == prog(Phases.in, 0, 3))
        #expect(timeline.progress(5.5) == prog(Phases.in, 0.5, 3))
        #expect(timeline.progress(6) == prog(Phases.in, 1, 3))
        #expect(timeline.progress(7) == prog(Phases.in, 2, 3))
        
        #expect(timeline.progress(8) == prog(Phases.out, 0, 2))
        #expect(timeline.progress(8.1) == prog(Phases.out, 0.1, 2))
        #expect(timeline.progress(8.5) == prog(Phases.out, 0.5, 2))
        #expect(timeline.progress(9) == prog(Phases.out, 1, 2))
        #expect(timeline.progress(9.999) == prog(Phases.out, 1.999, 2))
        
        #expect(timeline.progress(10) == prog("", 0, 0, true))
    }
    
    @Test func testInfinite() async throws {
        let m = ExerciseModel(
            id: UUID().uuidString,
            title: "", track: Tracks.constant,
            constantTrack: ConstantTrackModel(
                in: 3,
                inHold: 0,
                out: 2,
                outHold: 0,
                repeatTimes: repeatTimesInfinity // <-- infinite repeat
            ),
            increasingTrack: .default(),
            decreasingTrack: .default(),
            customTrack: .default()
        )
        
        let timeline: ExerciseTimeline = .forModel(m)
        
        // First cycle
        #expect(timeline.progress(0) == prog(Phases.in, 0, 3))
        #expect(timeline.progress(0.5) == prog(Phases.in, 0.5, 3))
        #expect(timeline.progress(1) == prog(Phases.in, 1, 3))
        #expect(timeline.progress(2) == prog(Phases.in, 2, 3))
        
        #expect(timeline.progress(3) == prog(Phases.out, 0, 2))
        #expect(timeline.progress(3.1) == prog(Phases.out, 0.1, 2))
        #expect(timeline.progress(3.5) == prog(Phases.out, 0.5, 2))
        #expect(timeline.progress(4) == prog(Phases.out, 1, 2))
        #expect(timeline.progress(4.999) == prog(Phases.out, 1.999, 2))
        
        // Repeats every 5 second
        #expect(timeline.progress(5) == prog(Phases.in, 0, 3))
        #expect(timeline.progress(5.5) == prog(Phases.in, 0.5, 3))
        #expect(timeline.progress(6) == prog(Phases.in, 1, 3))
        #expect(timeline.progress(7) == prog(Phases.in, 2, 3))
        
        #expect(timeline.progress(8) == prog(Phases.out, 0, 2))
        #expect(timeline.progress(8.1) == prog(Phases.out, 0.1, 2))
        #expect(timeline.progress(8.5) == prog(Phases.out, 0.5, 2))
        #expect(timeline.progress(9) == prog(Phases.out, 1, 2))
        #expect(timeline.progress(9.999) == prog(Phases.out, 1.999, 2))
        
        // Repeats every 5 second
        #expect(timeline.progress(10) == prog(Phases.in, 0, 3))
        #expect(timeline.progress(10.5) == prog(Phases.in, 0.5, 3))
        #expect(timeline.progress(11) == prog(Phases.in, 1, 3))
        #expect(timeline.progress(12) == prog(Phases.in, 2, 3))
        
        #expect(timeline.progress(13) == prog(Phases.out, 0, 2))
        #expect(timeline.progress(13.1) == prog(Phases.out, 0.1, 2))
        #expect(timeline.progress(13.5) == prog(Phases.out, 0.5, 2))
        #expect(timeline.progress(14) == prog(Phases.out, 1, 2))
        #expect(timeline.progress(14.999) == prog(Phases.out, 1.999, 2))
    }
    
    @Test func testIncreasing() async throws {
        let m = ExerciseModel(
            id: UUID().uuidString,
            title: "",
            track: Tracks.increasing,
            constantTrack: .default(),
            increasingTrack: IncreasingTrackModel(
                in: 1,
                inHold: 0,
                out: 1,
                outHold: 0,
                increasePhase: Phases.in,
                increaseTo: 8,
                increaseBy: 3
            ),
            decreasingTrack: .default(),
            customTrack: .default()
        )
        
        let timeline: ExerciseTimeline = .forModel(m)
        
        #expect(timeline.progress(0) == prog(Phases.in, 0, 1))
        #expect(timeline.progress(0.5) == prog(Phases.in, 0.5, 1))
        
        #expect(timeline.progress(1) == prog(Phases.out, 0, 1))
        #expect(timeline.progress(1.999) == prog(Phases.out, 0.999, 1))
        
        #expect(timeline.progress(2) == prog(Phases.in, 0, 4))
        #expect(timeline.progress(4) == prog(Phases.in, 2, 4))
        #expect(timeline.progress(5.999) == prog(Phases.in, 3.999, 4))
        
        #expect(timeline.progress(6) == prog(Phases.out, 0, 1))
        #expect(timeline.progress(6.999) == prog(Phases.out, 0.999, 1))
        
        #expect(timeline.progress(7) == prog(Phases.in, 0, 7))
        #expect(timeline.progress(10) == prog(Phases.in, 3, 7))
        #expect(timeline.progress(13) == prog(Phases.in, 6, 7))
        #expect(timeline.progress(13.999) == prog(Phases.in, 6.999, 7))
        
        #expect(timeline.progress(14) == prog(Phases.out, 0, 1))
        #expect(timeline.progress(14.999) == prog(Phases.out, 0.999, 1))
        
        #expect(timeline.progress(15) == prog(Phases.in, 0, 8))
        #expect(timeline.progress(20) == prog(Phases.in, 5, 8))
        #expect(timeline.progress(22.999) == prog(Phases.in, 7.999, 8))
        
        #expect(timeline.progress(23) == prog(Phases.out, 0, 1))
        #expect(timeline.progress(23.999) == prog(Phases.out, 0.999, 1))
        
        #expect(timeline.progress(24) == prog(Phases.in, 0, 0, true))
        #expect(timeline.progress(34) == prog(Phases.in, 0, 0, true))
    }
    
    @Test func testIncreasing2() async throws {
        let m = ExerciseModel(
            id: UUID().uuidString,
            title: "",
            track: Tracks.increasing,
            constantTrack: .default(),
            increasingTrack: IncreasingTrackModel(
                in: 1,
                inHold: 0,
                out: 1,
                outHold: 0,
                increasePhase: Phases.in,
                increaseTo: 2,
                increaseBy: 1
            ),
            decreasingTrack: .default(),
            customTrack: .default()
        )
        
        let timeline: ExerciseTimeline = .forModel(m)
        
        #expect(timeline.progress(0) == prog(Phases.in, 0, 1))
        #expect(timeline.progress(0.999) == prog(Phases.in, 0.999, 1))
        
        #expect(timeline.progress(1) == prog(Phases.out, 0, 1))
        #expect(timeline.progress(1.999) == prog(Phases.out, 0.999, 1))
        
        #expect(timeline.progress(2) == prog(Phases.in, 0, 2))
        #expect(timeline.progress(2.999) == prog(Phases.in, 0.999, 2))
        #expect(timeline.progress(3.999) == prog(Phases.in, 1.999, 2))
        
        #expect(timeline.progress(4) == prog(Phases.out, 0, 1))
        #expect(timeline.progress(4.999) == prog(Phases.out, 0.999, 1))
        
        #expect(timeline.progress(5) == prog(Phases.in, 0, 0, true))
        #expect(timeline.progress(555) == prog(Phases.in, 0, 0, true))
    }
    
    @Test func testIncreasing3() async throws {
        let m = ExerciseModel(
            id: UUID().uuidString,
            title: "",
            track: Tracks.increasing,
            constantTrack: .default(),
            increasingTrack: IncreasingTrackModel(
                in: 1,
                inHold: 0,
                out: 1,
                outHold: 0,
                increasePhase: Phases.in,
                increaseTo: 3,
                increaseBy: 100
            ),
            decreasingTrack: .default(),
            customTrack: .default()
        )
        
        let timeline: ExerciseTimeline = .forModel(m)
        
        #expect(timeline.progress(0) == prog(Phases.in, 0, 1))
        #expect(timeline.progress(0.999) == prog(Phases.in, 0.999, 1))
        
        #expect(timeline.progress(1) == prog(Phases.out, 0, 1))
        #expect(timeline.progress(1.999) == prog(Phases.out, 0.999, 1))
        
        #expect(timeline.progress(2) == prog(Phases.in, 0, 3))
        #expect(timeline.progress(2.999) == prog(Phases.in, 0.999, 3))
        #expect(timeline.progress(3.999) == prog(Phases.in, 1.999, 3))
        #expect(timeline.progress(4.999) == prog(Phases.in, 2.999, 3))
        
        #expect(timeline.progress(5) == prog(Phases.out, 0, 1))
        #expect(timeline.progress(5.999) == prog(Phases.out, 0.999, 1))
        
        #expect(timeline.progress(6) == prog(Phases.in, 0, 0, true))
        #expect(timeline.progress(999) == prog(Phases.in, 0, 0, true))
    }
}
