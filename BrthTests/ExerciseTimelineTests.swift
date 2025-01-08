import Testing
import Foundation

@testable import Brth

extension PhaseProgress: @retroactive Equatable {
    public static func == (lhs: PhaseProgress, rhs: PhaseProgress) -> Bool {
        return lhs.phase == rhs.phase &&
        lhs.elapsed.isAlmostEqual(to: rhs.elapsed) &&
        lhs.total.isAlmostEqual(to: rhs.total)
    }
}

struct ExerciseTimelineTests {
    
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
        #expect(timeline.progress(0) == PhaseProgress(phase: Phases.in, elapsed: 0, total: 3))
        #expect(timeline.progress(0.5) == PhaseProgress(phase: Phases.in, elapsed: 0.5, total: 3))
        #expect(timeline.progress(1) == PhaseProgress(phase: Phases.in, elapsed: 1, total: 3))
        #expect(timeline.progress(2) == PhaseProgress(phase: Phases.in, elapsed: 2, total: 3))
        
        #expect(timeline.progress(3) == PhaseProgress(phase: Phases.out, elapsed: 0, total: 2))
        #expect(timeline.progress(3.1) == PhaseProgress(phase: Phases.out, elapsed: 0.1, total: 2))
        #expect(timeline.progress(3.5) == PhaseProgress(phase: Phases.out, elapsed: 0.5, total: 2))
        #expect(timeline.progress(4) == PhaseProgress(phase: Phases.out, elapsed: 1, total: 2))
        #expect(timeline.progress(4.999) == PhaseProgress(phase: Phases.out, elapsed: 1.999, total: 2))
        
        // Repeats every 5 second
        #expect(timeline.progress(5) == PhaseProgress(phase: Phases.in, elapsed: 0, total: 3))
        #expect(timeline.progress(5.5) == PhaseProgress(phase: Phases.in, elapsed: 0.5, total: 3))
        #expect(timeline.progress(6) == PhaseProgress(phase: Phases.in, elapsed: 1, total: 3))
        #expect(timeline.progress(7) == PhaseProgress(phase: Phases.in, elapsed: 2, total: 3))
        
        #expect(timeline.progress(8) == PhaseProgress(phase: Phases.out, elapsed: 0, total: 2))
        #expect(timeline.progress(8.1) == PhaseProgress(phase: Phases.out, elapsed: 0.1, total: 2))
        #expect(timeline.progress(8.5) == PhaseProgress(phase: Phases.out, elapsed: 0.5, total: 2))
        #expect(timeline.progress(9) == PhaseProgress(phase: Phases.out, elapsed: 1, total: 2))
        #expect(timeline.progress(9.999) == PhaseProgress(phase: Phases.out, elapsed: 1.999, total: 2))
        
        // Repeats every 5 second
        #expect(timeline.progress(10) == PhaseProgress(phase: Phases.in, elapsed: 0, total: 3))
        #expect(timeline.progress(10.5) == PhaseProgress(phase: Phases.in, elapsed: 0.5, total: 3))
        #expect(timeline.progress(11) == PhaseProgress(phase: Phases.in, elapsed: 1, total: 3))
        #expect(timeline.progress(12) == PhaseProgress(phase: Phases.in, elapsed: 2, total: 3))
        
        #expect(timeline.progress(13) == PhaseProgress(phase: Phases.out, elapsed: 0, total: 2))
        #expect(timeline.progress(13.1) == PhaseProgress(phase: Phases.out, elapsed: 0.1, total: 2))
        #expect(timeline.progress(13.5) == PhaseProgress(phase: Phases.out, elapsed: 0.5, total: 2))
        #expect(timeline.progress(14) == PhaseProgress(phase: Phases.out, elapsed: 1, total: 2))
        #expect(timeline.progress(14.999) == PhaseProgress(phase: Phases.out, elapsed: 1.999, total: 2))
    }
}
