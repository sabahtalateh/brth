import SwiftUI

struct Petal: View {
    let goldenRatio: CGFloat = 1.618
        let numberOfPetals = 30
        let petalSize: CGFloat = 10
        let maxRadius: CGFloat = 150
        let minRadius: CGFloat = 0
        
        @State private var radius: CGFloat = 0
        @State private var scale: CGFloat = 0
        @State private var opacity: Double = 1.0
        
        var body: some View {
            ZStack {
                ForEach(0..<numberOfPetals, id: \.self) { i in
                    // Angle for the petal using golden ratio for spacing
                    let angle = Angle(degrees: Double(i) * 137.5) // Golden angle (137.5 degrees)
                    
                    // Calculate position using polar coordinates
                    let x = radius * cos(CGFloat(angle.radians))
                    let y = radius * sin(CGFloat(angle.radians))
                    
                    // Create petal (circle for simplicity)
                    Circle()
                        .frame(width: petalSize, height: petalSize)
                        .position(x: 200 + x, y: 200 + y) // Centering the pattern
                        .foregroundColor(.yellow)
                        .scaleEffect(scale)
                        .opacity(opacity)
                }
            }
            .frame(width: 400, height: 400)
            .onAppear {
                withAnimation(
                    Animation.easeInOut(duration: 3)
                        .repeatForever(autoreverses: true)
                ) {
                    // Animate the radius, scale, and opacity to simulate breathing
                    radius = maxRadius
                    scale = 1
                    opacity = 0.4 // Make it fade in and out for the breathing effect
                }
            }
        }
}

#Preview {
    Petal()
}
