import SwiftUI

fileprivate var bgColors: [Color] = [
    // .white,
    .init(hue: 108/360, saturation: 0.2, brightness: 1), // green
    .init(hue: 210/360, saturation: 0.2, brightness: 1), // onyx
    .init(hue: 177/360, saturation: 0.2, brightness: 1), // blue
    .init(hue: 148/360, saturation: 0.2, brightness: 1), // light green
]

fileprivate let startScale: Double = 0.2
fileprivate let endScale: Double = 0.85
fileprivate var progressScale: Double { endScale - startScale }

struct PlayView: View {
    
    @EnvironmentObject var playStore: PlayStore
    
    @State var countdownHidden: Bool = false
    @State var plateHidden: Bool = false
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var backgroundIndex: Int = 0
    @State private var backgroundLastUpdate: Date = .distantPast
    @State private var backgroundUpdateInterval: Double = 0
    @State private var backgroundOpacity: Double = 0
    
    var body: some View {
        
        TimelineView(.animation) { ctx in
            
            let progressAt = playStore.progressAt(ctx.date)
            let ratio = progressAt.toRatio()
            
            ZStack {
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        
                        Circle()
                            .fill(.clear)
                            .overlay {
                                ZStack {
                                    Circle()
                                        .strokeBorder(.primary, lineWidth: 2)
                                        .frame(maxWidth: 500, alignment: .center)
                                    
                                    GeometryReader { g in
                                        let minDimension = min(g.size.width, g.size.height)
                                        
                                        ZStack {
                                            
                                            ZStack {
                                                ParticlesView(particles: updatedWithProgress(ctx.date, progressAt))
                                                
                                                InnerCircleView(
                                                    scale: ratio,
                                                    totalSize: minDimension
                                                )
                                                
                                                OuterGlowView(
                                                    size: minDimension,
                                                    opacity: 1 - (ratio / endScale)
                                                )
                                            }
                                            .mask {
                                                Circle()
                                            }
                                            
                                            ZStack {
                                                
                                                let bgColor = bgColors[backgroundIndex]
                                                
                                                Circle()
                                                    .fill(.white)
                                                    .opacity(0.15)
                                                    .blur(radius: 20)
                                                    .blendMode(.plusLighter)
                                                
                                                Circle()
                                                    .fill(bgColor)
                                                    .opacity(0.3)
                                                    .blur(radius: 100)
                                                    .blendMode(.plusLighter)
                                                
                                                Circle()
                                                    .blendMode(.destinationOut)
                                            }
                                            .compositingGroup()
                                            .opacity(0.4 + ratio * 0.6)
                                            .opacity(backgroundOpacity)
                                        }
                                        
                                    }
                                    .frame(maxWidth: 500, alignment: .center)
                                }
                            }
                        // .frame(maxWidth: 500, maxHeight: 500, alignment: .center)
                    }
                    .padding()
                    
                    Spacer()
                    
                    if !plateHidden {
                        
                        PlayPlateView(
                            exerciseProgress: progressAt,
                            countdownHidden: $countdownHidden,
                            plateHidden: $plateHidden
                        )
                        .frame(maxWidth: 500, alignment: .center)
                        .padding()
                        .transition(.asymmetric(
                            insertion: .push(from: .bottom),
                            removal: .push(from: .top)
                        ))
                        .background {
                            let bgColor = bgColors[backgroundIndex]
                            
                            RoundedRectangle(cornerRadius: 16)
                                .scale(x: 1.5, y: 0.9)
                                .fill(bgColor)
                                .opacity(0.8)
                                .blur(radius: 150)
                                .opacity(0.35 + ratio)
                                .opacity(backgroundOpacity)
                        }
                        .blendMode(.plusLighter)
                        
                        Spacer()
                    }
                    
                    if plateHidden {
                        HStack {
                            Spacer()
                            
                            Button {
                                DispatchQueue.main.async {
                                    withAnimation(.easeInOut(duration: 0.35)) { plateHidden = false }
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    withAnimation(.easeInOut(duration: 0.15)) { countdownHidden = false }
                                }
                            } label: {
                                Image(systemName: "chevron.compact.up")
                            }
                            .font(.title)
                            .tint(.secondary)
                            .padding()
                            .background {
                                Circle()
                                    .fill(.thinMaterial)
                            }
                            .padding()
                        }
                        .transition(.asymmetric(
                            insertion: .push(from: .bottom),
                            removal: .push(from: .top)
                        ))
                    }
                }
                
                
            }
            .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 5)) {
                backgroundOpacity = 1
            }
        }
        .onReceive(timer) { time in updateBackground(time) }
        .onDisappear { timer.upstream.connect().cancel() }
    }
    
    private func updatedWithProgress(_ at: Date, _ ep: ExerciseProgress) -> [Particle] {
        let speedMul = if ep.phaseDuration == 0 {
            1.0
        } else if ep.phaseDuration <= 1 {
            2.5
        } else if ep.phaseDuration <= 2 {
            2.0
        } else if ep.phaseDuration <= 3 {
            1.5
        } else {
            1.0
        }
        
        let particleSystem = playStore.particleSystem
        
        if playStore.stopParticles {
            particleSystem.setVelocity(0)
        } else {
            switch ep.phase {
            case .in:
                // https://www.desmos.com/calculator/wqhc7u1hux
                // particleSystem.setVelocity(-CoreGraphics.cos(3.14 * 2 * ep.progress) / 2.2 + 0.5)
                
                // https://www.desmos.com/calculator/ddqqe9nj3s
                particleSystem.setVelocity(speedMul * (-CoreGraphics.cos(2 * 2 * ep.phaseProgress + 1.14) / 1.5 + 0.32))
                particleSystem.setInnerRadius(ep.phaseProgress - startScale)
            case .inHold:
                // https://www.desmos.com/calculator/hyztlkatwi
                particleSystem.setVelocity(-0.0909 * ep.phaseProgress + 0.04545)
                particleSystem.setInnerRadius(endScale - startScale)
            case .out:
                // https://www.desmos.com/calculator/jbfuqdptzc
                // particleSystem.setVelocity(speedMul * (CoreGraphics.cos(3.14 * 2 * ep.progress) / 2.2 - 0.5))
                
                // https://www.desmos.com/calculator/9wwmhpwvag
                particleSystem.setVelocity(speedMul * (CoreGraphics.cos(2 * 2 * ep.phaseProgress + 1.14) / 1.5 - 0.32))
                particleSystem.setInnerRadius(endScale - ep.phaseProgress - startScale)
            case .outHold:
                // https://www.desmos.com/calculator/aispppg6rv
                particleSystem.setVelocity(0.0909 * ep.phaseProgress - 0.04545)
                particleSystem.setInnerRadius(0)
            }
        }
        
        let particles = particleSystem.update(at: at)
        
        return particles
    }
    
    private func updateBackground(_ time: Date) {
        if time.timeIntervalSince(backgroundLastUpdate) < backgroundUpdateInterval {
            return
        }
        
        let udpateDuration = Double.random(in: 2..<4)
        // let udpateDuration = 2.0
        
        var newIndex = backgroundIndex + 1
        if newIndex >= bgColors.count {
            newIndex = 0
        }
        
        withAnimation(.easeInOut(duration: udpateDuration)) {
            backgroundIndex = newIndex
        }
        
        backgroundUpdateInterval = udpateDuration + Double.random(in: 5..<10)
        // backgroundUpdateInterval = udpateDuration
        backgroundLastUpdate = time
    }
}

struct ParticlesView: View {
    
    let particles: [Particle]
    
    var body: some View {
        
        ZStack {
            // Particles
            ParticlesLayer(
                particles: particles,
                blur: 0.7,
                scale: 1,
                colorSelector: { p in p.color.0 }
            )
            .opacity(0.85)
            .blendMode(.plusLighter)
            
            // Blured particles
            ParticlesLayer(
                particles: particles,
                blur: 16,
                scale: 2.8,
                colorSelector: { p in p.color.1 }
            )
            .opacity(0.55)
            .blendMode(.plusLighter)
        }
    }
}

struct InnerCircleView: View {
    
    let scale: Double
    let totalSize: Double
    
    var body: some View {
        ZStack {
            // Circle()
            //     // .fill(.red)
            //     .scale(scale)
            //     .opacity(0.4)
            Circle()
                .scale(scale)
                .blur(radius: 0.035 * totalSize)
                .blendMode(.plusLighter)
            Circle()
                .scale(scale)
                .blur(radius: 0.055 * totalSize)
                .blendMode(.plusLighter)
            Circle()
                .scale(scale)
                .blur(radius: 0.084 * totalSize)
                .blendMode(.plusLighter)
        }
    }
}

struct OuterGlowView: View {
    
    let size: Double
    let opacity: Double
    
    var body: some View {
        ZStack {
            Circle()
                .strokeBorder(.primary, lineWidth: 0.008 * size)
                .blur(radius: 0.01 * size)
                .blendMode(.plusLighter)
            
            Circle()
                .strokeBorder(.primary, lineWidth: 0.025 * size)
                .blur(radius: 0.042 * size)
                .blendMode(.plusLighter)
        }
        .opacity(opacity)
        .blendMode(.plusLighter)
    }
}

extension ExerciseProgress {
    
    func toRatio() -> Double {
        switch self.phase {
        case .in:
            // https://www.desmos.com/calculator/h1g66qs6qv
            let smooth = -1 * CoreGraphics.cos(self.phaseProgress * 3.14) / 2 + 0.5
            return smooth * progressScale + startScale
        case .inHold:
            return endScale
        case .out:
            // https://www.desmos.com/calculator/h1g66qs6qv
            let smooth = -1 * CoreGraphics.cos(self.phaseProgress * 3.14) / 2 + 0.5
            return (1 - smooth) * progressScale + startScale
        case .outHold:
            return startScale
        }
    }
}

#Preview {
    let particleSystem = ParticleSystem(
        spawnRate: 20,
        limit: 99,
        velocity: 0,
        particleRadius: 0.003..<0.009,
        innerRadius: 0
    )
    
    PlayView()
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
        .environmentObject(PlayStore(
            ns: Namespace().wrappedValue,
            particleSystem: particleSystem
        ))
    
}
