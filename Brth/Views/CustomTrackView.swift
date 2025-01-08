import SwiftUI

struct CustomTrackView: View {
    
    @EnvironmentObject var selectedExerciseStore: SelectedExerciseStore
    
    @Binding var editCustomTrack: Bool
    
    var scroller: ScrollViewProxy
    
    var track: CustomTrackModel {
        selectedExerciseStore.exercise.customTrack
    }
    
    var body: some View {
        Group {
            if track.steps.isEmpty {
                Section {
                    HStack {
                        Spacer()
                        Button {
                            selectedExerciseStore.exercise.customTrack.addStep()
                        } label: {
                            Label {
                                Text("Add breating cycle")
                            } icon: {
                                Image(systemName: "plus")
                            }
                        }
                        Spacer()
                    }
                }
            }
            
            ForEach($selectedExerciseStore.exercise.customTrack.steps, id: \.id) { step in
                Section {
                    CustomStepper(
                        label: PhaseTitles.in.capitalized,
                        icon: PhaseIcons.in,
                        in: 1...99,
                        value: step.in
                    )
                    
                    CustomStepper(
                        label: PhaseTitles.inHold.capitalized,
                        icon: PhaseIcons.inHold,
                        in: 0...99,
                        value: step.inHold,
                        replace: [0: Image(systemName: "forward.fill")],
                        dimLowest: true
                    )
                    
                    CustomStepper(
                        label: PhaseTitles.out.capitalized,
                        icon: PhaseIcons.out,
                        in: 1...99,
                        value: step.out
                    )
                    
                    CustomStepper(
                        label: PhaseTitles.outHold.capitalized,
                        icon: PhaseIcons.outHold,
                        in: 0...99,
                        value: step.outHold,
                        replace: [0: Image(systemName: "forward.fill")],
                        dimLowest: true
                    )
                } header: {
                    let stepI = track.steps.firstIndex { s in s.id == step.id.wrappedValue } ?? 0
                    
                    HStack {
                        Text("Breathing Cycle \(stepI + 1)")
                        Spacer()
                        Button {
                            if track.steps.count > 1 {
                                removeStep(step.id.wrappedValue)
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundStyle(track.steps.count > 1 ? .red : .secondary)
                        }
                        .opacity(editCustomTrack ? 1 : 0)
                    }
                } footer: {
                    // Text("Set initial breathing cycle phases durations. Durations are measured in seconds")
                }
                .id(step.id.wrappedValue)
            }
        }
    }
    
    func removeStep(_ id: String) {
        withAnimation {
            selectedExerciseStore.exercise.customTrack.removeStep(id)
        }
    }
}

#Preview {
    let exercisesRepo = PreviewExercisesRepository()
    
    let errorStore = ErrorStore()
    let exercisesStore = ExercisesStore(errorStore, exercisesRepo)
    let selectedExerciseStore = SelectedExerciseStore(exercisesStore, exercisesRepo)
    
    let _ = selectedExerciseStore.exercise = .defaultCustom(title: "123")
    
    ScrollViewReader { scroller in
        Form {
            CustomTrackView(editCustomTrack: .constant(false), scroller: scroller)
        }
        .tint(.primary)
        .preferredColorScheme(.dark)
        .environmentObject(selectedExerciseStore)
    }
}
