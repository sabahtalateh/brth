import Testing
@testable import Brth

struct IncreasingModelTests {

    @Test func increasingTrackDuration1() async throws {
        let track = IncreasingTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            increasePhase: Phases.in,
            increaseTo: 2,
            increaseBy: 1
        )
        
        #expect(track.duration() == .seconds(3))
    }
    
    @Test func increasingTrackDuration2() async throws {
        let track = IncreasingTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            increasePhase: Phases.in,
            increaseTo: 3,
            increaseBy: 1
        )
        
        #expect(track.duration() == .seconds(6))
    }
    
    @Test func increasingTrackDuration3() async throws {
        let track = IncreasingTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            increasePhase: Phases.in,
            increaseTo: 2,
            increaseBy: 10
        )
        
        #expect(track.duration() == .seconds(3))
    }
    
    @Test func increasingTrackDuration4() async throws {
        let track = IncreasingTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            increasePhase: Phases.in,
            increaseTo: 3,
            increaseBy: 10
        )
        
        #expect(track.duration() == .seconds(4))
    }
    
    @Test func increasingTrackDuration5() async throws {
        let track = IncreasingTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            increasePhase: Phases.in,
            increaseTo: 11,
            increaseBy: 10
        )
        
        #expect(track.duration() == .seconds(12))
    }
    
    @Test func increasingTrackDuration6() async throws {
        let track = IncreasingTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            increasePhase: Phases.in,
            increaseTo: 12,
            increaseBy: 10
        )
        
        #expect(track.duration() == .seconds(24))
    }
}
