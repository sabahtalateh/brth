import SwiftUI

struct DecreasingTrackView: View {
    
    @EnvironmentObject var selectedExerciseStore: SelectedExerciseStore
    
    @State var decreaseFrom: Int = 0
    @State var decreaseTo: Int = 0
    
    var phase: String {
        selectedExerciseStore.exercise.decreasingTrack.decreasePhase
    }
    
    var track: DecreasingTrackModel {
        selectedExerciseStore.exercise.decreasingTrack
    }
    
    var body: some View {
        Section {
            CustomStepper(
                label: PhaseTitles.in.capitalized,
                icon: PhaseIcons.in,
                in: 1...99,
                value: $selectedExerciseStore.exercise.decreasingTrack.in
            )
            
            CustomStepper(
                label: PhaseTitles.inHold.capitalized,
                icon: PhaseIcons.inHold,
                in: 0...99,
                value: $selectedExerciseStore.exercise.decreasingTrack.inHold,
                replace: [0: Image(systemName: "forward.fill")],
                dimLowest: true
            )
            
            CustomStepper(
                label: PhaseTitles.out.capitalized,
                icon: PhaseIcons.out,
                in: 1...99,
                value: $selectedExerciseStore.exercise.decreasingTrack.out
            )
            
            CustomStepper(
                label: PhaseTitles.outHold.capitalized,
                icon: PhaseIcons.outHold,
                in: 0...99,
                value: $selectedExerciseStore.exercise.decreasingTrack.outHold,
                replace: [0: Image(systemName: "forward.fill")],
                dimLowest: true
            )
        } header: {
            Text("Initial Durations")
        } footer: {
            Text("Set initial breathing cycle phases durations. Durations are measured in seconds")
        }
        
        Section {
            HStack {
                Menu {
                    ForEach(Phases.list(), id: \.self) { phase in
                        Button {
                            selectedExerciseStore.exercise.decreasingTrack.decreasePhase = phase
                        } label: {
                            Label {
                                Text(PhaseTitles.title(for: phase).capitalized)
                            } icon: {
                                PhaseIcons.icon(for: phase)
                            }
                        }
                    }
                } label: {
                    Label {
                        Text(PhaseTitles.title(for: phase).capitalized)
                    } icon: {
                        PhaseIcons.icon(for: phase)
                    }
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                }
            }
            
            CustomStepper(
                label: "Decrease to",
                icon: Image(systemName: "arrow.up.right"),
                in: decreaseFrom...decreaseTo,
                value: $selectedExerciseStore.exercise.decreasingTrack.decreaseTo
            )
            .onAppear {
                adjustDecreaseRange()
            }
            .onChange(of: selectedExerciseStore.exercise.decreasingTrack) { _ in
                adjustDecreaseRange()
            }
            
            CustomStepper(
                label: "Decrease by",
                icon: Image(systemName: "repeat"),
                in: 1...99,
                value: $selectedExerciseStore.exercise.decreasingTrack.decreaseBy
            )
            
        } header: {
            Text("Decrease")
        } footer: {
            Text("Select decreasing phase. Set its duration at the end of exercise and decreasing rate")
        }
    }
    
    func adjustDecreaseRange() {
        let initDur = track.initialDuration()
        
        var rngStart = switch track.decreasePhase {
        case Phases.in, Phases.out:
            1
        default:
            0
        }
        var rngEnd = initDur - 1
        if rngEnd < 0 {
            rngEnd = 0
        }
        
        if rngStart > rngEnd {
            rngStart = rngEnd
        }
        
        decreaseFrom = rngStart
        decreaseTo = rngEnd
        
        if selectedExerciseStore.exercise.decreasingTrack.decreaseTo < rngStart {
            selectedExerciseStore.exercise.decreasingTrack.decreaseTo = rngStart
        }
        
        if selectedExerciseStore.exercise.decreasingTrack.decreaseTo > rngEnd {
            selectedExerciseStore.exercise.decreasingTrack.decreaseTo = rngEnd
        }
    }
}

#Preview {
    let exercisesRepo = PreviewExercisesRepository()
    
    let errorStore = ErrorStore()
    let exercisesStore = ExercisesStore(errorStore, exercisesRepo)
    let selectedExerciseStore = SelectedExerciseStore(exercisesStore, exercisesRepo)
    
    let _ = selectedExerciseStore.exercise = .defaultDecreasing(title: "123")
    
    Form {
        DecreasingTrackView()
    }
    .tint(.primary)
    .preferredColorScheme(.dark)
    .environmentObject(selectedExerciseStore)
}
