import SwiftUI

struct Particle {
    var x: Double
    var y: Double
}

class ParticleSystem {
    
    private var particles: [Particle] = []
    
    // How many particles will be emmited per second
    private var emissionRate: Double
    // How many particles will be emmited on next update
    private var emissionAccum: Double = 0
    
    // Maximum amount of particles
    private var limit: Int
    
    // How long single particle will be presented
    private var presentDuration: Duration
    
    init(emissionRate: Double, limit: Int, presentDuration: Duration) {
        self.emissionRate = emissionRate
        self.limit = limit
        self.presentDuration = presentDuration
    }
}
