import SwiftUI

struct ConstantTrackView: View {
    
    @EnvironmentObject var selectedExerciseStore: SelectedExerciseStore
    
    var body: some View {
        Section {
            CustomStepper(
                label: PhaseTitles.in.capitalized,
                icon: PhaseIcons.in,
                in: 1...99,
                value: $selectedExerciseStore.exercise.constantTrack.in
            )
            
            CustomStepper(
                label: PhaseTitles.inHold.capitalized,
                icon: PhaseIcons.inHold,
                in: 0...99,
                value: $selectedExerciseStore.exercise.constantTrack.inHold,
                replace: [0: Image(systemName: "forward.fill")],
                dimLowest: true
            )
            
            CustomStepper(
                label: PhaseTitles.out.capitalized,
                icon: PhaseIcons.out,
                in: 1...99,
                value: $selectedExerciseStore.exercise.constantTrack.out
            )
            
            CustomStepper(
                label: PhaseTitles.outHold.capitalized,
                icon: PhaseIcons.outHold,
                in: 0...99,
                value: $selectedExerciseStore.exercise.constantTrack.outHold,
                replace: [0: Image(systemName: "forward.fill")],
                dimLowest: true
            )
        } header: {
            Text("Durations")
        } footer: {
            Text("Set breathing cycle phases durations. Durations are measured in seconds")
        }
        
        Section {
            CustomStepper(
                label: "Repeat Times",
                icon: Image(systemName: "repeat"),
                in: 1...Int.infiniteRepeatTimes(),
                value: $selectedExerciseStore.exercise.constantTrack.repeatTimes,
                replace: [.infiniteRepeatTimes(): Image(systemName: "infinity")]
            )
        } header: {
            Text("Repeat")
        } footer: {
            Text("Set number of repetitions of breathing cycle")
        }
    }
}

#Preview {
    let exercisesRepo = PreviewExercisesRepository()
    
    let errorStore = ErrorStore()
    let exercisesStore = ExercisesStore(errorStore, exercisesRepo)
    let selectedExerciseStore = SelectedExerciseStore(exercisesStore, exercisesRepo)
    
    let _ = selectedExerciseStore.exercise = .defaultConstant(title: "123")
    
    Form {
        ConstantTrackView()
    }
    .tint(.primary)
    .preferredColorScheme(.dark)
    .environmentObject(selectedExerciseStore)
}
