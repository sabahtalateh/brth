import SwiftUI

struct FPS: TimelineSchedule {
    let fps: Int
    
    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
        let interval = 1.0 / Double(fps)
        var currentDate = startDate
        
        return AnyIterator {
            currentDate = currentDate.addingTimeInterval(interval)
            return currentDate
        }
    }
}

// TODO: чем больше частица тем меньше скорость

struct ParticleSystemPlayground: View {
    
    @State private var limit: Double = 0
    @State private var spawnRate: Double = 0
    @State private var velocity: Double = 0
    @State private var particlesCount: Int = 0
    @State private var particleSizeFrom: Double = 0
    @State private var particleSizeTo: Double = 0
    @State private var innerRadius: Double = 0
    
    @State private var blur1: Double = 0.7
    @State private var blur2: Double = 16
    @State private var opacity1: Double = 1
    @State private var opacity2: Double = 0.55
    
    @State private var scale: Double = 2.8
    
    let particleSystem: ParticleSystem = .init(
        
        // Optimal ?
        spawnRate: 20,
        limit: 99, // 100?
        velocity: 1,
        particleRadius: 0.005..<0.013,
        innerRadius: 0
    )
    
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    Circle()
                        .fill(.clear)
                        .overlay {
                            ZStack {
                                GeometryReader { g in
                                    // let size = min(g.size.width, g.size.height)
                                    
                                    TimelineView(.animation) { ctx in
                                        // TimelineView(FPS(fps: 30)) { ctx in
                                        // TwoLayersOfParticles(
                                        //     particles: particleSystem.update(at: ctx.date, progress: .init()),
                                        //     bottomScale: CGFloat(scale),
                                        //     blur: (blur1, blur2),
                                        //     opacity: (opacity1, opacity2)
                                        // )
                                    }
                                    
                                    // Outer stroke
                                    Circle()
                                        .strokeBorder(lineWidth: 2)
                                    
                                    // Outer glow
                                    ZStack {
                                        Circle()
                                            .strokeBorder(lineWidth: 0.008 * g.size.width)
                                            .blur(radius: 0.01 * g.size.width)
                                            .blendMode(.plusLighter)
                                        
                                        Circle()
                                            .strokeBorder(lineWidth: 0.025 * g.size.width)
                                            .blur(radius: 0.042 * g.size.width)
                                            .blendMode(.plusLighter)
                                    }
                                    .mask {
                                        Circle()
                                    }
                                    .opacity(1.15 - innerRadius)
                                    
                                    
                                    // Circle()
                                    //     .stroke(lineWidth: 2)
                                    //     .scale(innerRadius)
                                    
                                    // Inner circle
                                    ZStack {
                                        Circle()
                                            .scale(innerRadius)
                                            .blur(radius: 0.035 * g.size.width)
                                            .blendMode(.plusLighter)
                                        Circle()
                                            .scale(innerRadius)
                                            .blur(radius: 0.055 * g.size.width)
                                            .blendMode(.plusLighter)
                                        Circle()
                                            .scale(innerRadius)
                                            .blur(radius: 0.084 * g.size.width)
                                            .blendMode(.plusLighter)
                                    }
                                }
                            }
                            .mask {
                                Circle()
                            }
                        }
                }
                .frame(maxWidth: 400, alignment: .center)
                // .blendMode(.plusLighter)
                
                HStack {
                    VStack {
                        HStack {
                            RedButton(action: {particleSystem.reset()}, label: "Reset")
                            RedButton(action: {}, label: "Particles \(particlesCount)").monospacedDigit()
                        }
                        
                        VStack {
                            Text("Circle Radius: \(String(format: "%.2f", innerRadius))").font(.title2)
                            HStack {
                                Slider(value: $innerRadius, in: 0...1, step: 0.01)
                                    .tint(.red)
                                    .onChange(of: innerRadius) { v in particleSystem.setInnerRadius(innerRadius - 0.15) }
                            }
                        }
                        
                        VStack {
                            Text("System Velocity: \(String(format: "%.3f", velocity))").font(.title2)
                            HStack {
                                Slider(value: $velocity, in: -2...2, step: 0.001)
                                    .tint(.red)
                                    .onChange(of: velocity) { v in particleSystem.setVelocity(velocity) }
                                
                                RedButton(action: {
                                    velocity = -1
                                    particleSystem.setVelocity(-1)
                                }, label: "=-1")
                                
                                RedButton(action: {
                                    velocity = 0
                                    particleSystem.setVelocity(0)
                                }, label: "=0")
                                
                                RedButton(action: {
                                    velocity = 1
                                    particleSystem.setVelocity(1)
                                }, label: "=1")
                            }
                        }
                        
                        VStack {
                            Text("Limit: \(String(format: "%.0f", limit))").font(.title2)
                            HStack {
                                Slider(value: $limit, in: 0...2000, step: 1)
                                    .tint(.red)
                                    .onChange(of: limit) { v in particleSystem.setLimit(Int(limit)) }
                                
                                RedButton(action: {
                                    limit -= 10
                                    particleSystem.setLimit(Int(limit) - 10)
                                }, label: "-10")
                                
                                RedButton(action: {
                                    limit -= 100
                                    particleSystem.setLimit(Int(limit) - 100)
                                }, label: "-100")
                                
                                RedButton(action: {
                                    limit += 10
                                    particleSystem.setLimit(Int(limit) + 10)
                                }, label: "+10")
                                
                                RedButton(action: {
                                    limit += 100
                                    particleSystem.setLimit(Int(limit) + 100)
                                }, label: "+100")
                            }
                        }
                        
                        VStack {
                            Text("Spawn Rate: \(String(format: "%.0f", spawnRate))").font(.title2)
                            HStack {
                                Slider(value: $spawnRate, in: 0...2000, step: 1)
                                    .tint(.red)
                                    .onChange(of: spawnRate) { v in particleSystem.setSpawnRate(Int(spawnRate)) }
                                
                                RedButton(action: {
                                    spawnRate -= 10
                                    particleSystem.setSpawnRate(Int(spawnRate) - 10)
                                }, label: "-10")
                                
                                RedButton(action: {
                                    spawnRate -= 100
                                    particleSystem.setSpawnRate(Int(spawnRate) - 100)
                                }, label: "-100")
                                
                                RedButton(action: {
                                    spawnRate += 10
                                    particleSystem.setSpawnRate(Int(spawnRate) + 10)
                                }, label: "+10")
                                
                                RedButton(action: {
                                    spawnRate += 100
                                    particleSystem.setSpawnRate(Int(spawnRate) + 100)
                                }, label: "+100")
                            }
                        }
                        
                        VStack {
                            Text("Particle Size: \(String(format: "%.3f", particleSizeFrom))..<\(String(format: "%.3f", particleSizeTo))").font(.title2)
                            HStack {
                                Slider(value: $particleSizeFrom, in: 0...0.1, step: 0.001)
                                    .tint(.red)
                                    .onChange(of: particleSizeFrom) { v in
                                        particleSystem.setParticleSize(particleSizeFrom..<particleSizeTo)
                                    }
                                
                                Slider(value: $particleSizeTo, in: 0...0.1, step: 0.001)
                                    .tint(.red)
                                    .onChange(of: particleSizeTo) { v in
                                        particleSystem.setParticleSize(particleSizeFrom..<particleSizeTo)
                                    }
                            }
                        }
                        
                        
                        HStack {
                            VStack {
                                Text("Blur 1: \(String(format: "%.1f", blur1))").font(.title2)
                                HStack {
                                    Slider(value: $blur1, in: 0...25, step: 0.1).tint(.red)
                                    RedButton(action: { blur1 -= 0.1 }, label: "-0.1")
                                    RedButton(action: { blur1 += 0.1 }, label: "+0.1")
                                }
                            }
                            
                            VStack {
                                Text("Blur 2: \(String(format: "%.1f", blur2))").font(.title2)
                                HStack {
                                    Slider(value: $blur2, in: 0...25, step: 0.1).tint(.red)
                                    RedButton(action: { blur2 -= 0.1 }, label: "-0.1")
                                    RedButton(action: { blur2 += 0.1 }, label: "+0.1")
                                }
                            }
                        }
                        
                        HStack {
                            VStack {
                                Text("Scale: \(String(format: "%.1f", scale))").font(.title2)
                                HStack {
                                    Slider(value: $scale, in: 1...5, step: 0.1).tint(.red)
                                    RedButton(action: { scale -= 0.1 }, label: "-0.1")
                                    RedButton(action: { scale += 0.1 }, label: "+0.1")
                                }
                            }
                        }
                        
                        HStack {
                            VStack {
                                Text("Opacity 1: \(String(format: "%.1f", opacity1))").font(.title2)
                                HStack {
                                    Slider(value: $opacity1, in: 0...1, step: 0.1).tint(.red)
                                    RedButton(action: { opacity1 -= 0.1 }, label: "-0.1")
                                    RedButton(action: { opacity1 += 0.1 }, label: "+0.1")
                                }
                            }
                            
                            VStack {
                                Text("Opacity 2: \(String(format: "%.1f", opacity2))").font(.title2)
                                HStack {
                                    Slider(value: $opacity2, in: 0...1, step: 0.1).tint(.red)
                                    RedButton(action: { opacity2 -= 0.1 }, label: "-0.1")
                                    RedButton(action: { opacity2 += 0.1 }, label: "+0.1")
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .onAppear {
                initState()
            }
        }
    }
    
    func initState() {
        // 1
        limit = Double(particleSystem.getLimit())
        spawnRate = Double(particleSystem.getSpawnRate())
        velocity = particleSystem.getVelocity()
        particlesCount = particleSystem.getParticlesCount()
        
        let psize1 = particleSystem.getParticleSize()
        particleSizeFrom = psize1.lowerBound
        particleSizeTo = psize1.upperBound
        
        innerRadius = particleSystem.getInnerRadius() + 0.15
        
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            particlesCount = particleSystem.getParticlesCount()
        }
    }
}



struct RedButton: View {
    let action: () -> Void
    let label: String
    
    var body: some View {
        Button(action: action) {
            Text(label)
        }
        .padding()
        .background(.red)
        .foregroundStyle(.white)
        .clipShape(Capsule())
    }
}

#Preview {
    ParticleSystemPlayground()
        .preferredColorScheme(.dark)
}
