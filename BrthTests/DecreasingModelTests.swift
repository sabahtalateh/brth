import Testing
@testable import Brth

struct DecreasingModelTests {

    @Test func decreasingTrackDuration1() async throws {
        let track = DecreasingTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            decreasePhase: Phases.in,
            decreaseTo: 2,
            decreaseBy: 1
        )
        
        #expect(track.duration() == .seconds(0))
    }
    
    @Test func decreasingTrackDuration2() async throws {
        let track = DecreasingTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            decreasePhase: Phases.in,
            decreaseTo: 1,
            decreaseBy: 1
        )
        
        #expect(track.duration() == .seconds(0))
    }
    
    @Test func decreasingTrackDuration3() async throws {
        let track = DecreasingTrackModel(
            in: 2,
            inHold: 0,
            out: 0,
            outHold: 0,
            decreasePhase: Phases.in,
            decreaseTo: 1,
            decreaseBy: 1
        )
        
        #expect(track.duration() == .seconds(3))
    }
    
    @Test func decreasingTrackDuration4() async throws {
        let track = DecreasingTrackModel(
            in: 2,
            inHold: 0,
            out: 0,
            outHold: 0,
            decreasePhase: Phases.in,
            decreaseTo: 1,
            decreaseBy: 100
        )
        
        #expect(track.duration() == .seconds(3))
    }
    
    @Test func decreasingTrackDuration5() async throws {
        let track = DecreasingTrackModel(
            in: 400,
            inHold: 0,
            out: 0,
            outHold: 0,
            decreasePhase: Phases.in,
            decreaseTo: 0,
            decreaseBy: 200
        )
        
        #expect(track.duration() == .seconds(600))
    }
    
    @Test func decreasingTrackDuration6() async throws {
        let track = DecreasingTrackModel(
            in: 10,
            inHold: 0,
            out: 0,
            outHold: 0,
            decreasePhase: Phases.in,
            decreaseTo: 5,
            decreaseBy: 3
        )
        
        #expect(track.duration() == .seconds(22))
    }
}
