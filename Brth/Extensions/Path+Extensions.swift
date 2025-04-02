import SwiftUI

extension Path {
    mutating func addCircle(c: CGPoint, r: CGFloat) {
        self.addArc(
            center: c,
            radius: r,
            startAngle: .zero,
            endAngle: .degrees(360),
            clockwise: false
        )
    }
    
    mutating func addBezierEllipse(
        center: CGPoint,
        radiusX: CGFloat,
        radiusY: CGFloat,
        rotation: Angle
    ) {
        // horizontal control
        let hControl: CGFloat = radiusY * 0.55
        // vertical control
        let vControl: CGFloat = radiusY * 0.55 * (radiusX / radiusY) // this last multiplier makes ellipse smoother
        
        let points = [
            CGPoint(x: center.x, y: center.y - radiusY), // up
            CGPoint(x: center.x + radiusX, y: center.y), // right
            CGPoint(x: center.x, y: center.y + radiusY), // down
            CGPoint(x: center.x - radiusX, y: center.y)  // left
        ]
        
        // rotate points
        let rotatedPoints = points.map { rotatePoint($0, center: center, angle: rotation) }
        
        // rotate control points
        let controlPoints = [
            CGPoint(x: points[0].x + vControl, y: points[0].y),
            CGPoint(x: points[1].x, y: points[1].y - hControl),
            CGPoint(x: points[1].x, y: points[1].y + hControl),
            CGPoint(x: points[2].x + vControl, y: points[2].y),
            CGPoint(x: points[2].x - vControl, y: points[2].y),
            CGPoint(x: points[3].x, y: points[3].y + hControl),
            CGPoint(x: points[3].x, y: points[3].y - hControl),
            CGPoint(x: points[0].x - vControl, y: points[0].y)
        ].map { rotatePoint($0, center: center, angle: rotation) }
        
        self.move(to: rotatedPoints[0])
       
        self.addCurve(to: rotatedPoints[1],
                      control1: controlPoints[0],
                      control2: controlPoints[1])
       
        self.addCurve(to: rotatedPoints[2],
                      control1: controlPoints[2],
                      control2: controlPoints[3])
       
        self.addCurve(to: rotatedPoints[3],
                      control1: controlPoints[4],
                      control2: controlPoints[5])
       
        self.addCurve(to: rotatedPoints[0],
                      control1: controlPoints[6],
                      control2: controlPoints[7])
    }
}

func rotatePoint(_ point: CGPoint, center: CGPoint, angle: Angle) -> CGPoint {
    let dx = point.x - center.x
    let dy = point.y - center.y
    let newX = center.x + dx * cos(angle.radians) - dy * sin(angle.radians)
    let newY = center.y + dx * sin(angle.radians) + dy * cos(angle.radians)
    return CGPoint(x: newX, y: newY)
}
