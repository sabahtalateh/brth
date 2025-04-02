import SwiftUI

struct PhaseTitles {
    static var `in`: String = "breathe in"
    static var inHold: String = "breathe in hold"
    static var out: String = "breathe out"
    static var outHold: String = "breathe out hold"
    
    static func title(for phase: Phase) -> String {
        switch phase {
        case .in: `in`
        case .inHold: inHold
        case .out: out
        case .outHold: outHold
        }
    }
}

struct PhaseIcons {
    static let `in`: Image = Image(systemName: "smallcircle.filled.circle")
    static let inHold: Image = Image(systemName: "circle.fill")
    static let out: Image = Image(systemName: "smallcircle.filled.circle.fill")
    static let outHold: Image = Image(systemName: "circle")
    
    static func icon(for phase: Phase) -> Image {
        switch phase {
        case .in: `in`
        case .inHold: inHold
        case .out: out
        case .outHold: outHold
        }
    }
}

func formatSeconds(_ seconds: Int) -> String {
    let minutes = seconds / 60
    let remainingSeconds = seconds % 60
    return String(format: "%02d:%02d", minutes, remainingSeconds)
}
