import Testing
import Foundation

@testable import Brth

extension ExerciseProgress: @retroactive Equatable {
    public static func == (lhs: ExerciseProgress, rhs: ExerciseProgress) -> Bool {
        return lhs.phase == rhs.phase &&
        lhs.phaseElapsed.isAlmostEqual(to: rhs.phaseElapsed) &&
        lhs.phaseDuration.isAlmostEqual(to: rhs.phaseDuration)
    }
}

func prog(_ p: Phase, _ pe: Double, _ pd: Double, _ d: Bool = false) -> ExerciseProgress {
    ExerciseProgress(phase: p, phaseElapsed: pe, phaseDuration: pd, done: d)
}

struct TimelineTests {
    
    @Test func testConstant() async throws {
        let m = ExerciseModel(
            id: UUID().uuidString,
            title: "",
            track: .constant,
            constantTrack: ConstantTrackModel(
                in: 3,
                inHold: 0,
                out: 2,
                outHold: 0,
                repeatTimes: 2
            ),
            increasingTrack: .defaultIncreasing(),
            decreasingTrack: .defaultDecreasing(),
            customTrack: .default()
        )
        
        let timeline: ExerciseTimeline = .forModel(m)
        
        // First cycle
        #expect(timeline.progress(0) == prog(.in, 0, 3))
        #expect(timeline.progress(0.5) == prog(.in, 0.5, 3))
        #expect(timeline.progress(1) == prog(.in, 1, 3))
        #expect(timeline.progress(2) == prog(.in, 2, 3))
        
        #expect(timeline.progress(3) == prog(.out, 0, 2))
        #expect(timeline.progress(3.1) == prog(.out, 0.1, 2))
        #expect(timeline.progress(3.5) == prog(.out, 0.5, 2))
        #expect(timeline.progress(4) == prog(.out, 1, 2))
        #expect(timeline.progress(4.999) == prog(.out, 1.999, 2))
        
        // Repeats every 5 second
        #expect(timeline.progress(5) == prog(.in, 0, 3))
        #expect(timeline.progress(5.5) == prog(.in, 0.5, 3))
        #expect(timeline.progress(6) == prog(.in, 1, 3))
        #expect(timeline.progress(7) == prog(.in, 2, 3))
        
        #expect(timeline.progress(8) == prog(.out, 0, 2))
        #expect(timeline.progress(8.1) == prog(.out, 0.1, 2))
        #expect(timeline.progress(8.5) == prog(.out, 0.5, 2))
        #expect(timeline.progress(9) == prog(.out, 1, 2))
        #expect(timeline.progress(9.999) == prog(.out, 1.999, 2))
        
        #expect(timeline.progress(10) == prog(.in, 0, 0, true))
    }
    
    @Test func testInfinite() async throws {
        let m = ExerciseModel(
            id: UUID().uuidString,
            title: "",
            track: .constant,
            constantTrack: ConstantTrackModel(
                in: 3,
                inHold: 0,
                out: 2,
                outHold: 0,
                repeatTimes: .infiniteRepeatTimes() // <-- infinite repeat
            ),
            increasingTrack: .defaultIncreasing(),
            decreasingTrack: .defaultDecreasing(),
            customTrack: .default()
        )
        
        let timeline: ExerciseTimeline = .forModel(m)
        
        // First cycle
        #expect(timeline.progress(0) == prog(.in, 0, 3))
        #expect(timeline.progress(0.5) == prog(.in, 0.5, 3))
        #expect(timeline.progress(1) == prog(.in, 1, 3))
        #expect(timeline.progress(2) == prog(.in, 2, 3))
        
        #expect(timeline.progress(3) == prog(.out, 0, 2))
        #expect(timeline.progress(3.1) == prog(.out, 0.1, 2))
        #expect(timeline.progress(3.5) == prog(.out, 0.5, 2))
        #expect(timeline.progress(4) == prog(.out, 1, 2))
        #expect(timeline.progress(4.999) == prog(.out, 1.999, 2))
        
        // Repeats every 5 second
        #expect(timeline.progress(5) == prog(.in, 0, 3))
        #expect(timeline.progress(5.5) == prog(.in, 0.5, 3))
        #expect(timeline.progress(6) == prog(.in, 1, 3))
        #expect(timeline.progress(7) == prog(.in, 2, 3))
        
        #expect(timeline.progress(8) == prog(.out, 0, 2))
        #expect(timeline.progress(8.1) == prog(.out, 0.1, 2))
        #expect(timeline.progress(8.5) == prog(.out, 0.5, 2))
        #expect(timeline.progress(9) == prog(.out, 1, 2))
        #expect(timeline.progress(9.999) == prog(.out, 1.999, 2))
        
        // Repeats every 5 second
        #expect(timeline.progress(10) == prog(.in, 0, 3))
        #expect(timeline.progress(10.5) == prog(.in, 0.5, 3))
        #expect(timeline.progress(11) == prog(.in, 1, 3))
        #expect(timeline.progress(12) == prog(.in, 2, 3))
        
        #expect(timeline.progress(13) == prog(.out, 0, 2))
        #expect(timeline.progress(13.1) == prog(.out, 0.1, 2))
        #expect(timeline.progress(13.5) == prog(.out, 0.5, 2))
        #expect(timeline.progress(14) == prog(.out, 1, 2))
        #expect(timeline.progress(14.999) == prog(.out, 1.999, 2))
    }
    
    @Test func testIncreasing() async throws {
        let m = ExerciseModel(
            id: UUID().uuidString,
            title: "",
            track: .increasing,
            constantTrack: .default(),
            increasingTrack: DynamicTrackModel(
                in: 1,
                inHold: 0,
                out: 1,
                outHold: 0,
                dynPhase: .in,
                add: 3,
                limit: 8
            ),
            decreasingTrack: .defaultDecreasing(),
            customTrack: .default()
        )
        
        let timeline: ExerciseTimeline = .forModel(m)
        
        #expect(timeline.progress(0) == prog(.in, 0, 1))
        #expect(timeline.progress(0.5) == prog(.in, 0.5, 1))
        
        #expect(timeline.progress(1) == prog(.out, 0, 1))
        #expect(timeline.progress(1.999) == prog(.out, 0.999, 1))
        
        #expect(timeline.progress(2) == prog(.in, 0, 4))
        #expect(timeline.progress(4) == prog(.in, 2, 4))
        #expect(timeline.progress(5.999) == prog(.in, 3.999, 4))
        
        #expect(timeline.progress(6) == prog(.out, 0, 1))
        #expect(timeline.progress(6.999) == prog(.out, 0.999, 1))
        
        #expect(timeline.progress(7) == prog(.in, 0, 7))
        #expect(timeline.progress(10) == prog(.in, 3, 7))
        #expect(timeline.progress(13) == prog(.in, 6, 7))
        #expect(timeline.progress(13.999) == prog(.in, 6.999, 7))
        
        #expect(timeline.progress(14) == prog(.out, 0, 1))
        #expect(timeline.progress(14.999) == prog(.out, 0.999, 1))
        
        #expect(timeline.progress(15) == prog(.in, 0, 8))
        #expect(timeline.progress(20) == prog(.in, 5, 8))
        #expect(timeline.progress(22.999) == prog(.in, 7.999, 8))
        
        #expect(timeline.progress(23) == prog(.out, 0, 1))
        #expect(timeline.progress(23.999) == prog(.out, 0.999, 1))
        
        #expect(timeline.progress(24) == prog(.in, 0, 0, true))
        #expect(timeline.progress(34) == prog(.in, 0, 0, true))
    }
    
    @Test func testIncreasingZeroAdd() async throws {
        let m = ExerciseModel(
            id: UUID().uuidString,
            title: "",
            track: .increasing,
            constantTrack: .default(),
            increasingTrack: DynamicTrackModel(
                in: 1,
                inHold: 0,
                out: 1,
                outHold: 0,
                dynPhase: .in,
                add: 0,
                limit: 8
            ),
            decreasingTrack: .defaultDecreasing(),
            customTrack: .default()
        )
        
        let timeline: ExerciseTimeline = .forModel(m)
        
        #expect(timeline.progress(0) == prog(.in, 0, 0, true))
        #expect(timeline.progress(100) == prog(.in, 0, 0, true))
    }
    
    @Test func testIncreasing2() async throws {
        let m = ExerciseModel(
            id: UUID().uuidString,
            title: "",
            track: .increasing,
            constantTrack: .default(),
            increasingTrack: DynamicTrackModel(
                in: 1,
                inHold: 0,
                out: 1,
                outHold: 0,
                dynPhase: .in,
                add: 1,
                limit: 2
            ),
            decreasingTrack: .defaultDecreasing(),
            customTrack: .default()
        )
        
        let timeline: ExerciseTimeline = .forModel(m)
        
        #expect(timeline.progress(0) == prog(.in, 0, 1))
        #expect(timeline.progress(0.999) == prog(.in, 0.999, 1))
        
        #expect(timeline.progress(1) == prog(.out, 0, 1))
        #expect(timeline.progress(1.999) == prog(.out, 0.999, 1))
        
        #expect(timeline.progress(2) == prog(.in, 0, 2))
        #expect(timeline.progress(2.999) == prog(.in, 0.999, 2))
        #expect(timeline.progress(3.999) == prog(.in, 1.999, 2))
        
        #expect(timeline.progress(4) == prog(.out, 0, 1))
        #expect(timeline.progress(4.999) == prog(.out, 0.999, 1))
        
        #expect(timeline.progress(5) == prog(.in, 0, 0, true))
        #expect(timeline.progress(555) == prog(.in, 0, 0, true))
    }
    
    @Test func testIncreasing3() async throws {
        let m = ExerciseModel(
            id: UUID().uuidString,
            title: "",
            track: .increasing,
            constantTrack: .default(),
            increasingTrack: DynamicTrackModel(
                in: 1,
                inHold: 0,
                out: 1,
                outHold: 0,
                dynPhase: .in,
                add: 100,
                limit: 3
            ),
            decreasingTrack: .defaultDecreasing(),
            customTrack: .default()
        )
        
        let timeline: ExerciseTimeline = .forModel(m)
        
        #expect(timeline.progress(0) == prog(.in, 0, 1))
        #expect(timeline.progress(0.999) == prog(.in, 0.999, 1))
        
        #expect(timeline.progress(1) == prog(.out, 0, 1))
        #expect(timeline.progress(1.999) == prog(.out, 0.999, 1))
        
        #expect(timeline.progress(2) == prog(.in, 0, 3))
        #expect(timeline.progress(2.999) == prog(.in, 0.999, 3))
        #expect(timeline.progress(3.999) == prog(.in, 1.999, 3))
        #expect(timeline.progress(4.999) == prog(.in, 2.999, 3))
        
        #expect(timeline.progress(5) == prog(.out, 0, 1))
        #expect(timeline.progress(5.999) == prog(.out, 0.999, 1))
        
        #expect(timeline.progress(6) == prog(.in, 0, 0, true))
        #expect(timeline.progress(999) == prog(.in, 0, 0, true))
    }
    
    @Test func testDecreasing() async throws {
        let m = ExerciseModel(
            id: UUID().uuidString,
            title: "",
            track: .decreasing,
            constantTrack: .default(),
            increasingTrack: .defaultIncreasing(),
            decreasingTrack: DynamicTrackModel(
                in: 10,
                inHold: 0,
                out: 1,
                outHold: 0,
                dynPhase: .in,
                add: -3,
                limit: 3
            ),
            customTrack: .default()
        )
        
        let timeline: ExerciseTimeline = .forModel(m)
        
        #expect(timeline.progress(0) == prog(.in, 0, 10))
        #expect(timeline.progress(5) == prog(.in, 5, 10))
        #expect(timeline.progress(9.999) == prog(.in, 9.999, 10))
        
        #expect(timeline.progress(10) == prog(.out, 0, 1))
        #expect(timeline.progress(10.999) == prog(.out, 0.999, 1))
        
        #expect(timeline.progress(11) == prog(.in, 0, 7))
        #expect(timeline.progress(17.999) == prog(.in, 6.999, 7))
        
        #expect(timeline.progress(18) == prog(.out, 0, 1))
        #expect(timeline.progress(18.999) == prog(.out, 0.999, 1))
        
        #expect(timeline.progress(19) == prog(.in, 0, 4))
        #expect(timeline.progress(22.999) == prog(.in, 3.999, 4))
        
        #expect(timeline.progress(23) == prog(.out, 0, 1))
        #expect(timeline.progress(23.999) == prog(.out, 0.999, 1))
        
        #expect(timeline.progress(24) == prog(.in, 0, 3))
        #expect(timeline.progress(26.999) == prog(.in, 2.999, 3))
        
        #expect(timeline.progress(27) == prog(.out, 0, 1))
        #expect(timeline.progress(27.999) == prog(.out, 0.999, 1))
        
        #expect(timeline.progress(28) == prog(.in, 0, 0, true))
        #expect(timeline.progress(500) == prog(.in, 0, 0, true))
    }
    
    @Test func testDecreasing2() async throws {
        let m = ExerciseModel(
            id: UUID().uuidString,
            title: "",
            track: .decreasing,
            constantTrack: .default(),
            increasingTrack: .defaultIncreasing(),
            decreasingTrack: DynamicTrackModel(
                in: 2,
                inHold: 0,
                out: 1,
                outHold: 0,
                dynPhase: .in,
                add: -1,
                limit: 1
            ),
            customTrack: .default()
        )
        
        let timeline: ExerciseTimeline = .forModel(m)
        
        #expect(timeline.progress(0) == prog(.in, 0, 2))
        #expect(timeline.progress(0.999) == prog(.in, 0.999, 2))
        #expect(timeline.progress(1.999) == prog(.in, 1.999, 2))
        
        #expect(timeline.progress(2) == prog(.out, 0, 1))
        #expect(timeline.progress(2.999) == prog(.out, 0.999, 1))
    
        #expect(timeline.progress(3) == prog(.in, 0, 1))
        #expect(timeline.progress(3.999) == prog(.in, 0.999, 1))
        
        #expect(timeline.progress(4) == prog(.out, 0, 1))
        #expect(timeline.progress(4.999) == prog(.out, 0.999, 1))
        
        #expect(timeline.progress(5) == prog(.in, 0, 0, true))
        #expect(timeline.progress(555) == prog(.in, 0, 0, true))
    }
    
    @Test func testDecreasing3() async throws {
        let m = ExerciseModel(
            id: UUID().uuidString,
            title: "",
            track: .decreasing,
            constantTrack: .default(),
            increasingTrack: .defaultIncreasing(),
            decreasingTrack: DynamicTrackModel(
                in: 3,
                inHold: 0,
                out: 1,
                outHold: 0,
                dynPhase: .in,
                add: -100,
                limit: 1
            ),
            customTrack: .default()
        )
        
        let timeline: ExerciseTimeline = .forModel(m)
        
        #expect(timeline.progress(0) == prog(.in, 0, 3))
        #expect(timeline.progress(2.999) == prog(.in, 2.999, 3))
        
        #expect(timeline.progress(3) == prog(.out, 0, 1))
        #expect(timeline.progress(3.999) == prog(.out, 0.999, 1))
        
        #expect(timeline.progress(4) == prog(.in, 0, 1))
        #expect(timeline.progress(4.999) == prog(.in, 0.999, 1))
        
        #expect(timeline.progress(5) == prog(.out, 0, 1))
        #expect(timeline.progress(5.999) == prog(.out, 0.999, 1))
        
        #expect(timeline.progress(6) == prog(.in, 0, 0, true))
        #expect(timeline.progress(999) == prog(.in, 0, 0, true))
    }
    
    @Test func testDecreasingZeroAdd() async throws {
        let m = ExerciseModel(
            id: UUID().uuidString,
            title: "",
            track: .decreasing,
            constantTrack: .default(),
            increasingTrack: .defaultIncreasing(),
            decreasingTrack: DynamicTrackModel(
                in: 10,
                inHold: 0,
                out: 1,
                outHold: 0,
                dynPhase: .in,
                add: 0,
                limit: 1
            ),
            customTrack: .default()
        )
        
        let timeline: ExerciseTimeline = .forModel(m)
        
        #expect(timeline.progress(0) == prog(.in, 0, 0, true))
        #expect(timeline.progress(100) == prog(.in, 0, 0, true))
    }
}
