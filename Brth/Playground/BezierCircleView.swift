import SwiftUI


struct BezierCircleView: View {
    
    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            
            var path = Path()
            path.addBezierEllipse(
                center: center,
                radiusX: 40.0,
                radiusY: 70.0,
                rotation: .zero
            )

            context.stroke(path, with: .color(.blue), lineWidth: 2)
        }
    }
}

#Preview {
    BezierCircleView()
}
