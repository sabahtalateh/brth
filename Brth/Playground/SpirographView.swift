import SwiftUI

struct SinusoidalCircleView: View {
    @State private var freq1: Double = 10.3
    @State private var amp1: Double = 9
    @State private var rot1: Angle = .zero
    @State private var scale1: Double = 1
    
    @State private var freq2: Double = 15
    @State private var amp2: Double = 9
    @State private var rot2: Angle = .zero
    @State private var scale2: Double = 1
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                
                SinusoidalCirclePath(amplitude: amp1, frequency: freq1)
                    .stroke(Color.blue, lineWidth: 2)
                    .blur(radius: 0)
                    .rotationEffect(rot1)
                    .scaleEffect(scale1)
                
                SinusoidalCirclePath(amplitude: amp2, frequency: freq2)
                    .stroke(Color.red, lineWidth: 2)
                    .blur(radius: 1)
                    .rotationEffect(rot2)
                    .scaleEffect(scale2) 
                
            }
            Slider(value: $freq1, in: 0...10, step: 1)
            Slider(value: $amp1, in: 0...100, step: 1)
        }
        .padding()
        .onAppear {
            withAnimation(
                .easeInOut(duration: 5).repeatForever(autoreverses: true)
            ) {
                freq1 = 20
                amp1 = 15
                rot1 = .degrees(360)
                scale1 = 1.5
            }
            
            withAnimation(
                .easeInOut(duration: 3).repeatForever(autoreverses: true)
            ) {
                freq2 = 6
                amp2 = 15
                rot2 = .degrees(-360)
                scale2 = 0.4
            }
        }
    }
}

struct SinusoidalCirclePath: Shape {
    var amplitude: CGFloat
    var frequency: CGFloat
    
    // Конформим к Animatable для обеих переменных
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { AnimatablePair(amplitude, frequency) }
        set {
            amplitude = newValue.first
            frequency = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2 - amplitude
        
        let points = 720
        for i in 0..<points {
            let angle = CGFloat(i) * .pi / 360
            let sineOffset = sin(angle * frequency) * amplitude
            
            let x = center.x + (radius + sineOffset) * cos(angle)
            let y = center.y + (radius + sineOffset) * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}

#Preview {
    SinusoidalCircleView()
}
