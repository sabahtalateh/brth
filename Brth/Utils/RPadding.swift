import SwiftUI

struct Padding: ViewModifier {
    var insets: Edge.Set = .all
    var length: CGFloat? = nil

    func body(content: Content) -> some View {
        content.padding(insets, length)
    }
}

fileprivate let paddingUnit: CGFloat = 16

enum PaddingRatio {
    case triple, double, unit, half, quarter, zero
}

extension PaddingRatio {
    func value() -> Double {
        switch self {
        case .zero:
            0
        case .quarter:
            0.25
        case .half:
            0.5
        case .unit:
            1
        case .double:
            2
        case .triple:
            3
        }
    }
}

extension View {
    func rpadding(_ ratio: PaddingRatio = .unit) -> some View {
        modifier(Padding(insets: .all, length: paddingUnit * ratio.value()))
    }
    
    func rpadding(_ insets: Edge.Set = .all, _ ratio: PaddingRatio = .unit) -> some View {
        modifier(Padding(insets: insets, length: paddingUnit * ratio.value()))
    }
}
