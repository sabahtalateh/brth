import SwiftUI

struct BlendMode: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.white)
                .frame(width: 100, height: 100)
                .blur(radius: 20)
            
            Circle()
                .fill(.white)
                .frame(width: 100, height: 100)
                .opacity(0.6)
                .blur(radius: 20)
            
        }
        // .blendMode(.screen)
        .blendMode(.plusLighter)
        // .blendMode(.hardLight)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    BlendMode()
}
