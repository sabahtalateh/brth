import Testing
@testable import Brth

struct DecreasingModelTests {

    @Test func decreasingTrackDuration1() async throws {
        let track = DynamicTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            dynPhase: .in,
            add: -1,
            limit: 2
        )
        
        #expect(track.duration() == .seconds(0))
    }
    
    @Test func decreasingTrackDuration2() async throws {
        let track = DynamicTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            dynPhase: .in,
            add: -1,
            limit: 1
        )
        
        #expect(track.duration() == .seconds(0))
    }
    
    @Test func decreasingTrackDuration3() async throws {
        let track = DynamicTrackModel(
            in: 2,
            inHold: 0,
            out: 0,
            outHold: 0,
            dynPhase: .in,
            add: -1,
            limit: 1
        )
        
        #expect(track.duration() == .seconds(3))
    }
    
    @Test func decreasingTrackDuration4() async throws {
        let track = DynamicTrackModel(
            in: 2,
            inHold: 0,
            out: 0,
            outHold: 0,
            dynPhase: .in,
            add: -100,
            limit: 1
        )
        
        #expect(track.duration() == .seconds(3))
    }
    
    @Test func decreasingTrackDuration5() async throws {
        let track = DynamicTrackModel(
            in: 400,
            inHold: 0,
            out: 0,
            outHold: 0,
            dynPhase: .in,
            add: -200,
            limit: 0
        )
        
        #expect(track.duration() == .seconds(600))
    }
    
    @Test func decreasingTrackDuration6() async throws {
        let track = DynamicTrackModel(
            in: 10,
            inHold: 0,
            out: 0,
            outHold: 0,
            dynPhase: .in,
            add: -3,
            limit: 5
        )
        
        #expect(track.duration() == .seconds(22))
    }
}
