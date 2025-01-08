import Testing

struct PlaygroundTests {
    
    @Test func increasingTrackDuration1() async throws {
        let a = 10
        let b = 4
        
        let c = a % b
        
        #expect(c == 2)
    }
}
