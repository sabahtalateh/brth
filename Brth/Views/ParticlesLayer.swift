import SwiftUI

fileprivate struct CanvasParticle {
    let x: CGFloat
    let y: CGFloat
    let width: CGFloat
    let height: CGFloat
    let color: Color
}

struct ParticlesLayer: View {
    
    // List of particles with radial coordinates
    // Mapped to absolute coordinates within view
    let particles: [Particle]
    
    let blur: Double
    let scale: Double
    
    let colorSelector: (Particle) -> Color
    
    var body: some View {
        
        ZStack {
            
            Canvas { ctx, size in
                let minSize = min(size.width, size.height)
                let offsetX = (size.width - minSize) / 2
                let offsetY = (size.height - minSize) / 2
                
                let pp: [CanvasParticle] = particles.map { p in
                    // https://www.desmos.com/calculator/q1dgsmjia2
                    let distanceScale = -0.5 * p.radialDistance + 1.5
                    
                    let halfParticleW = p.radius * minSize * scale * distanceScale
                    let halfParticleH = p.radius * minSize * scale * distanceScale
                    let halfRD = p.radialDistance / 2
                    
                    return .init(
                        x: (CoreGraphics.cos(p.angle.radians) * halfRD + 0.5) * minSize - halfParticleW + offsetX,
                        y: (CoreGraphics.sin(p.angle.radians) * halfRD + 0.5) * minSize - halfParticleH + offsetY,
                        width: halfParticleW * 2,
                        height: halfParticleH * 2,
                        color: colorSelector(p)
                    )
                }
                
                ctx.addFilter(.blur(radius: blur))
                ctx.blendMode = .plusLighter
                
                for p in pp {
                    var path = Path()
                    
                    path.addEllipse(in: CGRect(x: p.x, y: p.y, width: p.width, height: p.height))
                    ctx.fill(path, with: .color(p.color))
                }
            }
        }
    }
}


