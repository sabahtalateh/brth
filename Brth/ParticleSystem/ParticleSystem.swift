import SwiftUI

struct Particle {
    var angle: Angle
    var velocity: Double
    var angleVelocity: Double
    var radialDistance: Double
    var radius: Double
    var color: (Color, Color)
    
    init(
        angle: Angle,
        velocity: Double,
        angleVelocity: Double,
        radialDistance: Double,
        radius: Double,
        color: (Color, Color)
    ) {
        self.angle = angle
        self.velocity = velocity
        self.angleVelocity = angleVelocity
        self.radialDistance = radialDistance
        self.radius = radius
        self.color = color
    }
}

class ParticleSystem {
    
    private var particles: [Particle] = []
    
    private var lastUpdate: Date = .distantFuture
    
    private var spawnRate: Int
    private var spawnAccum: Double = 0
    private var limit: Int
    private var velocity: Double = 0
    private var particleRadius: Range<Double>
    private var innerRadius: Double = 0
    
    init(
        spawnRate: Int,
        limit: Int,
        velocity: Double,
        particleRadius: Range<Double>,
        innerRadius: Double
    ) {
        self.spawnRate = spawnRate
        self.limit = limit
        self.velocity = velocity
        self.particleRadius = particleRadius
        self.innerRadius = max(min(innerRadius, 1), 0)
    }
    
    func preSpawn() {
        particles = []
        
        for _ in 0..<limit {
            particles.append(randomParticle(distance: Double.random(in: innerRadius..<1)))
        }
    }
    
    func update(at: Date) -> [Particle] {
        defer {
            lastUpdate = at
        }
        
        let dt = at.timeIntervalSince(lastUpdate)
        
        if dt < 0 {
            return particles
        }
        
        updateParticles(dt)
        spawnParticles(dt)
        
        return particles
    }
    
    private func spawnParticles(_ dt: TimeInterval) {
        if !(particles.count < limit) {
            return
        }
        
        spawnAccum += dt * Double(spawnRate)
        
        let accumVal: Int = Int(spawnAccum)
        if accumVal == 0 {
            return
        }
        
        let maxSpawn = limit - particles.count
        let toSpawn = min(maxSpawn, accumVal)
        
        if self.velocity > 0 { // system moving to center. spawn on edge
            for _ in 0..<toSpawn {
                particles.append(randomParticle(distance: 1))
            }
        } else if self.velocity < 0 { // system moving from center. spawn in center
            for _ in 0..<toSpawn {
                particles.append(randomParticle(distance: innerRadius))
            }
        }
        
        spawnAccum -= Double(accumVal)
    }
    
    private func updateParticles(_ dt: TimeInterval) {
        let respawn = particles.count < limit
        
        particles = particles.compactMap { p in
            let deltaDistance = dt * p.velocity * self.velocity
            let newDistance = p.radialDistance - deltaDistance
            
            // Particle was moved to center and reached it
            // Spawn new particle on edge
            if newDistance < innerRadius{
                if !respawn {
                    return nil
                }
                
                if velocity >= 0 {
                    return randomParticle(distance: 1)
                }
            }
            
            // Particle was moved from center and reached edge
            // Spawn new particle in center
            if newDistance > 1 {
                if !respawn {
                    return nil
                }
                
                if velocity <= 0 {
                    return randomParticle(distance: innerRadius)
                }
            }
            
            return Particle(
                angle: p.angle + .degrees(p.angleVelocity * 360 * dt),
                velocity: p.velocity,
                angleVelocity: p.angleVelocity,
                radialDistance: newDistance,
                radius: p.radius,
                color: p.color
            )
        }
    }
    
    func randomParticle(distance: Double) -> Particle {
        let color = colors.randomElement()!
        
        return Particle(
            angle: .degrees(Double.random(in: 0..<360)),
            velocity: .random(in: 0.25..<0.75),
            angleVelocity: .random(in: 0.005...0.02),
            radialDistance: distance,
            radius: .random(in: particleRadius),
            color: color
        )
    }
}

extension ParticleSystem {
    
    func setParticleSize(_ s: Range<Double>) {
        self.particleRadius = s
    }
    
    func getParticleSize() -> Range<Double> {
        self.particleRadius
    }
    
    func setLimit(_ l: Int) {
        self.limit = l
    }
    
    func getLimit() -> Int {
        self.limit
    }
    
    func setSpawnRate(_ s: Int) {
        self.spawnRate = s
    }
    
    func getSpawnRate() -> Int {
        self.spawnRate
    }
    
    func setVelocity(_ v: Double) {
        self.velocity = v
    }
    
    func getVelocity() -> Double {
        self.velocity
    }
    
    func setInnerRadius(_ r: Double) {
        self.innerRadius = max(min(r, 1), 0)
    }
    
    func getInnerRadius() -> Double {
        self.innerRadius
    }
    
    func getParticlesCount() -> Int {
        self.particles.count
    }
    
    func reset() {
        self.innerRadius = 0
        self.particles = []
    }
}

fileprivate let sat1: Double = 0.05
fileprivate let sat2: Double = 0.15
fileprivate let colors: [(Color, Color)] = [
    (.white, .white),
    (.white, .white),
    (.white, .white),
    (.white, .white),
    (.white, .white),
    (.white, .white),
    (Color(hue: 0, saturation: sat1, brightness: 1), Color(hue: 0, saturation: sat2, brightness: 1)),
    (Color(hue: 60/360, saturation: sat1, brightness: 1), Color(hue: 60/360, saturation: sat2, brightness: 1)),
    (Color(hue: 120/360, saturation: sat1, brightness: 1), Color(hue: 120/360, saturation: sat2, brightness: 1)),
    (Color(hue: 180/360, saturation: sat1, brightness: 1), Color(hue: 180/360, saturation: sat2, brightness: 1)),
    (Color(hue: 240/360, saturation: sat1, brightness: 1), Color(hue: 240/360, saturation: sat2, brightness: 1)),
    (Color(hue: 300/360, saturation: sat1, brightness: 1), Color(hue: 300/360, saturation: sat2, brightness: 1)),
]
