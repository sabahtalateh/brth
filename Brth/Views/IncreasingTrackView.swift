import SwiftUI

struct IncreasingTrackView: View {
    
    @EnvironmentObject var selectedExerciseStore: SelectedExerciseStore
    
    @State var increaseFrom: Int = 0
    @State var increaseTo: Int = 0
    
    var phase: String {
        selectedExerciseStore.exercise.increasingTrack.increasePhase
    }
    
    var track: IncreasingTrackModel {
        selectedExerciseStore.exercise.increasingTrack
    }
    
    var body: some View {
        Section {
            CustomStepper(
                label: PhaseTitles.in.capitalized,
                icon: PhaseIcons.in,
                in: 1...99,
                value: $selectedExerciseStore.exercise.increasingTrack.in
            )
            
            CustomStepper(
                label: PhaseTitles.inHold.capitalized,
                icon: PhaseIcons.inHold,
                in: 0...99,
                value: $selectedExerciseStore.exercise.increasingTrack.inHold,
                replace: [0: Image(systemName: "forward.fill")],
                dimLowest: true
            )
            
            CustomStepper(
                label: PhaseTitles.out.capitalized,
                icon: PhaseIcons.out,
                in: 1...99,
                value: $selectedExerciseStore.exercise.increasingTrack.out
            )
            
            CustomStepper(
                label: PhaseTitles.outHold.capitalized,
                icon: PhaseIcons.outHold,
                in: 0...99,
                value: $selectedExerciseStore.exercise.increasingTrack.outHold,
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
                            selectedExerciseStore.exercise.increasingTrack.increasePhase = phase
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
                label: "Increase to",
                icon: Image(systemName: "arrow.up.right"),
                in: increaseFrom...increaseTo,
                value: $selectedExerciseStore.exercise.increasingTrack.increaseTo
            )
            .onAppear {
                adjustIncreaseRange()
            }
            .onChange(of: selectedExerciseStore.exercise.increasingTrack) { _ in
                adjustIncreaseRange()
            }
            
            CustomStepper(
                label: "Increase by",
                icon: Image(systemName: "repeat"),
                in: 1...99,
                value: $selectedExerciseStore.exercise.increasingTrack.increaseBy
            )
            
        } header: {
            Text("Increase")
        } footer: {
            Text("Select increasing phase. Set its duration at the end of exercise and increasing rate")
        }
    }
    
    func adjustIncreaseRange() {
        let initDur = track.initialDuration()
        
        let rngStart = initDur + 1
        let rngEnd = initDur + 99
        
        increaseFrom = rngStart
        increaseTo = rngEnd
        
        if selectedExerciseStore.exercise.increasingTrack.increaseTo < rngStart {
            selectedExerciseStore.exercise.increasingTrack.increaseTo = rngStart
        }
        
        if selectedExerciseStore.exercise.increasingTrack.increaseTo > rngEnd {
            selectedExerciseStore.exercise.increasingTrack.increaseTo = rngEnd
        }
    }
}

#Preview {
    let exercisesRepo = PreviewExercisesRepository()
    
    let errorStore = ErrorStore()
    let exercisesStore = ExercisesStore(errorStore, exercisesRepo)
    let selectedExerciseStore = SelectedExerciseStore(exercisesStore, exercisesRepo)
    
    let _ = selectedExerciseStore.exercise = .defaultIncreasing(title: "123")
    
    Form {
        IncreasingTrackView()
    }
    .tint(.primary)
    .preferredColorScheme(.dark)
    .environmentObject(selectedExerciseStore)
}
