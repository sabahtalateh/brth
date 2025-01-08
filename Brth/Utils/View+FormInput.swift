import SwiftUI

extension View {
    func formInput() -> some View {
        self
            .rpadding()
            .background(.thinMaterial)
            .rounded()
            .rpadding(.horizontal)
    }
}
