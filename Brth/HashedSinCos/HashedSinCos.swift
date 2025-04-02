import SwiftUI

struct HashedSinCos {
    func hashedSin(_ a: Angle) -> Double {
        let radians = a.radians
        return sin(radians)
    }
    
    func hashedCos(_ a: Angle) -> Double {
        let radians = a.radians
        return cos(radians)
    }
}
