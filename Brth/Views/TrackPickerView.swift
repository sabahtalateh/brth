import SwiftUI

fileprivate let trackTexts: [Track: (String, String)] = [
    .constant: (
        "Constant",
        "Each phase of the breathing cycle has same duration throughout the exercise"
    ),
    .increasing: (
        "Increasing",
        "Duration of one of phases of breathing cycle gradually increases over time"
    ),
    .decreasing: (
        "Decreasing",
        "Duration of one of phases of breathing cycle gradually decreases over time"
    ),
    .custom: (
        "Custom",
        "Manually compose exercise"
    )
]

struct TrackPickerView: View {
    
    @Binding var track: Track
    
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
                Image(systemName: "circle.circle").tag(Track.constant)
                Image(systemName: "arrow.up.right").tag(Track.increasing)
                Image(systemName: "arrow.down.right").tag(Track.decreasing)
                Image(systemName: "circle.dotted").tag(Track.custom)
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
        TrackPickerView(track: .constant(Track.constant))
        TrackPickerView(track: .constant(Track.increasing))
        TrackPickerView(track: .constant(Track.decreasing))
        TrackPickerView(track: .constant(Track.custom))
    }
    .preferredColorScheme(.dark)
}
