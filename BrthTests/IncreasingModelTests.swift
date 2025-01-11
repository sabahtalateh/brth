import Testing
@testable import Brth

struct IncreasingModelTests {

    @Test func increasingTrackDuration1() async throws {
        let track = DynamicTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            dynPhase: .in,
            add: 1,
            limit: 2
        )
        
        #expect(track.duration() == .seconds(3))
    }
    
    @Test func increasingTrackDuration2() async throws {
        let track = DynamicTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            dynPhase: .in,
            add: 1,
            limit: 3
        )
        
        #expect(track.duration() == .seconds(6))
    }
    
    @Test func increasingTrackDuration3() async throws {
        let track = DynamicTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            dynPhase: .in,
            add: 10,
            limit: 2
        )
        
        #expect(track.duration() == .seconds(3))
    }
    
    @Test func increasingTrackDuration4() async throws {
        let track = DynamicTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            dynPhase: .in,
            add: 10,
            limit: 3
        )
        
        #expect(track.duration() == .seconds(4))
    }
    
    @Test func increasingTrackDuration5() async throws {
        let track = DynamicTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            dynPhase: .in,
            add: 10,
            limit: 11
        )
        
        #expect(track.duration() == .seconds(12))
    }
    
    @Test func increasingTrackDuration6() async throws {
        let track = DynamicTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            dynPhase: .in,
            add: 10,
            limit: 12
        )
        
        #expect(track.duration() == .seconds(24))
    }
    
    @Test func increasingTrackDuration7() async throws {
        let track = DynamicTrackModel(
            in: 1,
            inHold: 0,
            out: 0,
            outHold: 0,
            dynPhase: .in,
            add: 0,
            limit: 12
        )
        
        #expect(track.duration() == .seconds(0))
    }
    
    @Test func increasingTrackDuration8() async throws {
        let track = DynamicTrackModel(
            in: 10,
            inHold: 0,
            out: 0,
            outHold: 0,
            dynPhase: .in,
            add: 2,
            limit: 5
        )
        
        #expect(track.duration() == .seconds(0))
    }
}
