import Testing
import Foundation

struct PlaygroundTests {
    
    @Test func div() async throws {
        let a = 10
        let b = 4
        
        let c = a % b
        
        #expect(c == 2)
    }
    
    @Test func strd() async throws {
        for number in stride(from: 0, to: 10, by: 4) {
           print(number)
       }
    }
}
