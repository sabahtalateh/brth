import SwiftUI

struct DecreasingTrackView: View {
    
    @EnvironmentObject var selectedExerciseStore: SelectedExerciseStore
    
    @State private var decreaseFrom: Int = 0
    @State private var decreaseTo: Int = 0
    
    @State private var decreaseBy: Int = 0
    
    var phase: Phase {
        selectedExerciseStore.exercise.decreasingTrack.dynPhase
    }
    
    var track: DynamicTrackModel {
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
                    ForEach(Phase.allCases, id: \.self) { phase in
                        Button {
                            selectedExerciseStore.exercise.decreasingTrack.dynPhase = phase
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
                value: $selectedExerciseStore.exercise.decreasingTrack.limit
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
                value: $decreaseBy
            )
            .onAppear {
                decreaseBy = -selectedExerciseStore.exercise.decreasingTrack.add
            }
            .onChange(of: decreaseBy) { newValue in
                selectedExerciseStore.exercise.decreasingTrack.add = -newValue
            }
            
        } header: {
            Text("Decrease")
        } footer: {
            Text("Select decreasing phase. Set its duration at the end of exercise and decreasing rate")
        }
    }
    
    func adjustDecreaseRange() {
        let initDur = track.dynPhaseDuration()
        
        var rngStart = switch track.dynPhase {
        case .in, .out:
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
        
        if selectedExerciseStore.exercise.decreasingTrack.limit < rngStart {
            selectedExerciseStore.exercise.decreasingTrack.limit = rngStart
        }
        
        if selectedExerciseStore.exercise.decreasingTrack.limit > rngEnd {
            selectedExerciseStore.exercise.decreasingTrack.limit = rngEnd
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
