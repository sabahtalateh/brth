import SwiftUI

extension View {
    func formGroup(noPadding: Bool = false) -> some View {
        self
            .rpadding(.vertical, noPadding ? .zero : .half)
            .rpadding(.horizontal, noPadding ? .zero : .unit)
            .background(.thinMaterial)
            .rounded()
            .rpadding(.horizontal)
    }
}
