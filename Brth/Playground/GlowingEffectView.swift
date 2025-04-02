import SwiftUI

struct GlowingEffectView: View {
    var body: some View {
        ZStack {
            // Фон
            Color.black
                .ignoresSafeArea()
            
            ZStack {
                // Радиационное свечение
                Circle()
                    .fill(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                .blue,
                                .clear,
                                .clear,
                                .blue,
                                .clear,
                                .clear,
                                .clear,
                                .clear,
                                .clear,
                                .clear,
                                .blue,
                                .blue,
                                .cyan,
                                .blue,
                                .clear,
                                .clear,
                                .clear,
                                .cyan,
                                .clear,
                                .clear,
                                .cyan,
                                .blue,
                                .cyan,
                                .blue,
                                .clear,
                                .clear,
                                .cyan,
                                .cyan,
                            ]),
                            center: .center
                        )
                    )
                    .blur(radius: 10)
                    .rotationEffect(.degrees(30))
                    .mask(
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.white,
                                        Color.white,
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 200
                                )
                            )
                    )
                    .blendMode(.screen)
                
                Circle()
                    .fill(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                .green,
                                .clear,
                                .clear,
                                .green,
                                .clear,
                                .clear,
                                .green,
                                .clear,
                                .clear,
                                .green,
                                .clear,
                                .clear,
                                .green,
                                .clear,
                                .clear,
                                .green,
                            ]),
                            center: .center
                        )
                    )
                    .blur(radius: 20)
                    .rotationEffect(.degrees(66.6))
                    .mask(
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.white,
                                        Color.white,
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 180
                                )
                            )
                    )
                    .blendMode(.screen)
                
                Circle()
                    .fill(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                .red,
                                .red,
                                .clear,
                                .clear,
                                .green,
                                .clear,
                                .clear,
                                .green,
                                .red,
                                .clear,
                                .green,
                                .red,
                                .clear,
                                .green,
                                .red,
                                .clear,
                                .green,
                            ]),
                            center: .center
                        )
                    )
                    .blur(radius: 20)
                    .rotationEffect(.degrees(95))
                    .mask(
                        Circle()
                            .fill(
                                RadialGradient(
                                    gradient: Gradient(colors: [
                                        Color.white,
                                        Color.white,
                                        Color.clear
                                    ]),
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 140
                                )
                            )
                    )
                    .blendMode(.screen)
                
                Circle()
                    .fill(Color.white)
                    .frame(width: 100, height: 100)
                    .blur(radius: 3)
                    .blendMode(.screen)
            }
            .compositingGroup()
            
            // Центральный белый круг
            
        }
    }
}

#Preview {
    GlowingEffectView()
}
