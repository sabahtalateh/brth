import SwiftUI

fileprivate let trackTexts: [String: (String, String)] = [
    Tracks.constant: (
        "Constant",
        "Each phase of the breathing cycle has same duration throughout the exercise"
    ),
    Tracks.increasing: (
        "Increasing",
        "Duration of one of phases of breathing cycle gradually increases over time"
    ),
    Tracks.decreasing: (
        "Decreasing",
        "Duration of one of phases of breathing cycle gradually decreases over time"
    ),
    Tracks.custom: (
        "Custom",
        "Manually compose exercise"
    )
]

struct TrackPickerView: View {
    
    @Binding var track: String
    
    var trackTitle: String {
        if let tt = trackTexts[track] {
            tt.0
        } else {
            ""
        }
    }
    
    var trackDescription: String {
        if let tt = trackTexts[track] {
            tt.1
        } else {
            ""
        }
    }
    
    var body: some View {
        Section {
            Picker("Exercise Track", selection: $track) {
                Image(systemName: "circle.circle").tag(Tracks.constant)
                Image(systemName: "arrow.up.right").tag(Tracks.increasing)
                Image(systemName: "arrow.down.right").tag(Tracks.decreasing)
                Image(systemName: "circle.dotted").tag(Tracks.custom)
            }
            .pickerStyle(.segmented)
            .listRowSeparator(.hidden)
            
            VStack(alignment: .leading) {
                Text(trackTitle)
                Text(trackDescription)
                    .foregroundStyle(.secondary)
                    .font(.callout)
            }
            .padding(.top, -4)
        } header: {
            Text("Exercise Track")
        }
    }
}

#Preview {
    Form {
        TrackPickerView(track: .constant(Tracks.constant))
        TrackPickerView(track: .constant(Tracks.increasing))
        TrackPickerView(track: .constant(Tracks.decreasing))
        TrackPickerView(track: .constant(Tracks.custom))
    }
    .preferredColorScheme(.dark)
}
