import SwiftUI

struct CustomStepper: View {
    
    let label: String
    let icon: Image
    let `in`: ClosedRange<Int>
    
    @Binding var value: Int
    
    var replace: [Int: Image] = [:]
    var dimLowest: Bool = false
    
    var foregroundStyle: HierarchicalShapeStyle {
        dimLowest && value == `in`.lowerBound
        ? .secondary
        : .primary
    }
    
    var valueFontWeight: Font.Weight {
        dimLowest && value == `in`.lowerBound
        ? .regular
        : .bold
    }
    
    var valueText: Text {
        if let repl = replace[value] {
            Text(repl)
        } else {
            Text("\(value)")
        }
    }
    
    var body: some View {
        Stepper(
            value: $value,
            in: `in`,
            label: {
                Label {
                    HStack {
                        Text(label)
                            .foregroundStyle(foregroundStyle)
                        
                        Spacer()
                        
                        // if #available(iOS 17, *) {
                            valueText
                                .fontWeight(valueFontWeight)
                                .foregroundStyle(foregroundStyle)
                                .monospacedDigit()
                                // contentTransition laggy on iOS 16 emulator. check on device
                                // .contentTransition(.numericText())
                        // } else {
                        //     valueText
                        //         .fontWeight(valueFontWeight)
                        //         .foregroundStyle(foregroundStyle)
                        // }
                    }
                } icon: {
                    icon
                        .foregroundStyle(foregroundStyle)
                }
            }
        )
    }
}

#Preview {
    Form {
        CustomStepper(
            label: "Label",
            icon: Image(systemName: "circle"),
            in: 1...99,
            value: .constant(25)
        )
    }
    .tint(.primary)
    .preferredColorScheme(.dark)
}
