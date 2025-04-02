import SwiftUI

struct ShearedRotatedEllipseCanvas: View {
    @State private var shearAngle: CGFloat = 0.0 // Угол наклона (shear)
    @State private var rotationAngle: CGFloat = 0.0 // Угол вращения (в градусах)

    var body: some View {
        VStack {
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let ellipseSize = CGSize(width: 150, height: 150)

                // Создаем эллипс с центром в (0,0)
                var path = Path(ellipseIn: CGRect(
                    x: -ellipseSize.width / 2,
                    y: -ellipseSize.height / 2,
                    width: ellipseSize.width,
                    height: ellipseSize.height
                ))

                // Матрица наклона (shear)
                let shearX = tan(shearAngle) // Тангенс угла
                let shearMatrix = CGAffineTransform(a: 1, b: shearX, c: shearX, d: 1, tx: 0, ty: 0)
                path = path.applying(shearMatrix)

                // Матрица вращения
                let rotationRadians = rotationAngle * .pi / 180 // Конвертируем градусы в радианы
                let rotationMatrix = CGAffineTransform(rotationAngle: rotationRadians)
                path = path.applying(rotationMatrix)

                // Перемещаем эллипс в центр
                let moveToCenter = CGAffineTransform(translationX: center.x, y: center.y)
                path = path.applying(moveToCenter)

                context.fill(path, with: .color(.blue))
            }
            .frame(width: 300, height: 200)

            // Слайдер для наклона
            VStack {
                Text("Shear Angle: \(shearAngle, specifier: "%.2f") rad")
                Slider(value: $shearAngle, in: -0.5...0.5, step: 0.01)
            }
            .padding()

            // Слайдер для вращения
            VStack {
                Text("Rotation Angle: \(rotationAngle, specifier: "%.0f")°")
                Slider(value: $rotationAngle, in: -180...180, step: 1)
            }
            .padding()
        }
    }
}

#Preview {
    ShearedRotatedEllipseCanvas()
}
