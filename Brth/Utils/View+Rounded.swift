import SwiftUI

extension View {
    func rounded() -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
