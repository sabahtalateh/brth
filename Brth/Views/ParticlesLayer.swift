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
    
    var body: some View {
        // let canvasParticles: [CanvasParticle] = particles.map { p in
            // particle size increasing hyperbolically
            // to make center circle wiggling more cool
            // https://www.desmos.com/calculator/csrve25ipo
            // let scale = (1 / (3 * p.radialDistance + 0.54)) + 0.71
            
            // let scale = 1.0
            
            // particle scale depends on how close it to center
            // x = 1 - on the edge
            // x = 0 - at center
            
            
            
            // https://www.desmos.com/calculator/zxgeuihgy1
            // let scale = -1.5 * p.radialDistance + 2
            // 
            // 
            // let halfParticleW = p.radius * size * scale
            // let halfParticleH = p.radius * size * scale
            // let halfRD = p.radialDistance / 2
            // 
            // return .init(
            //     x: (CoreGraphics.cos(p.angle.radians) * halfRD + 0.5) * size - halfParticleW,
            //     y: (CoreGraphics.sin(p.angle.radians) * halfRD + 0.5) * size - halfParticleH,
            //     width: halfParticleW * 2,
            //     height: halfParticleH * 2,
            //     color: p.color
            // )
        // }
        
        ZStack {
            // Circle()
            //     .fill(.red)
            
            Canvas { ctx, size in
                let pp = canvasParticles(size)
                
                ctx.addFilter(.blur(radius: blur))
                
                for p in pp {
                    var path = Path()
                    
                    path.addEllipse(in: CGRect(x: p.x, y: p.y, width: p.width, height: p.height))
                    ctx.fill(path, with: .color(p.color))
                }
            }
            .blendMode(.plusLighter)
            
            // Canvas { ctx, _ in
            //     ctx.addFilter(.blur(radius: blur.1))
            //     
            //     for p in canvasParticles {
            //         var path = Path()
            //         
            //         let pw = p.width * bottomScale
            //         let ph = p.height * bottomScale
            //         
            //         path.addEllipse(in: CGRect(
            //             x: p.x - (pw - p.width) / 2,
            //             y: p.y - (ph - p.height) / 2,
            //             width: pw,
            //             height: ph
            //         ))
            //         
            //         ctx.fill(path, with: .color(p.color.1))
            //     }
            // }
            // .blendMode(.plusLighter)
            // .opacity(opacity.1)
        }
    }
    
    private func canvasParticles(_ size: CGSize) -> [CanvasParticle] {
        let minSize = min(size.width, size.height)
        let offsetX = (size.width - minSize) / 2
        let offsetY = (size.height - minSize) / 2
        
        return particles.map { p in
            // https://www.desmos.com/calculator/zxgeuihgy1
            let scale = -1.5 * p.radialDistance + 2
            
            
            let halfParticleW = p.radius * minSize * scale
            let halfParticleH = p.radius * minSize * scale
            let halfRD = p.radialDistance / 2
            
            return .init(
                x: (CoreGraphics.cos(p.angle.radians) * halfRD + 0.5) * minSize - halfParticleW + offsetX,
                y: (CoreGraphics.sin(p.angle.radians) * halfRD + 0.5) * minSize - halfParticleH + offsetY,
                width: halfParticleW * 2,
                height: halfParticleH * 2,
                color: p.color.0
            )
        }
    }
}


