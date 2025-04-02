import SwiftUI

struct GlowingTrailView: View {
    var body: some View {
            ZStack {
                // Фон
                Color.black
                    .edgesIgnoringSafeArea(.all)

                // Белый светящийся круг
                Circle()
                    .fill(Color.white)
                    .frame(width: 100, height: 100)
                    .shadow(color: .white.opacity(0.8), radius: 50, x: 0, y: 0)

                // Цветные лучи вокруг
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(gradient: Gradient(colors: [.clear, .red.opacity(0.4)]),
                                           center: .center, startRadius: 50, endRadius: 150)
                        )
                        .blendMode(.screen)
                        .frame(width: 300, height: 300)

                    Circle()
                        .fill(
                            RadialGradient(gradient: Gradient(colors: [.clear, .blue.opacity(0.4)]),
                                           center: .center, startRadius: 50, endRadius: 150)
                        )
                        .blendMode(.screen)
                        .frame(width: 300, height: 300)
                        .offset(x: 50, y: -50)

                    Circle()
                        .fill(
                            RadialGradient(gradient: Gradient(colors: [.clear, .green.opacity(0.4)]),
                                           center: .center, startRadius: 50, endRadius: 150)
                        )
                        .blendMode(.screen)
                        .frame(width: 300, height: 300)
                        .offset(x: -50, y: 50)

                    Circle()
                        .fill(
                            RadialGradient(gradient: Gradient(colors: [.clear, .orange.opacity(0.4)]),
                                           center: .center, startRadius: 50, endRadius: 150)
                        )
                        .blendMode(.screen)
                        .frame(width: 300, height: 300)
                        .offset(x: -50, y: -50)
                }
            }
        }
}

#Preview {
    GlowingTrailView()
}
