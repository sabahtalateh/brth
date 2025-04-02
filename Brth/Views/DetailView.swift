import SwiftUI

struct DetailView: View {
    
    @EnvironmentObject var selectedExerciseStore: SelectedExerciseStore
    
    @Binding var editCustomTrack: Bool
    
    var body: some View {
        ZStack {
            // Circle()
            
            // Don't remove this if. It will break exercise starting animation from sidebar
            if selectedExerciseStore.exercise.id != "" {
                ScrollViewReader { scroller in
                    Form {
                        StartExerciseView(scroller: scroller)
                            .disabled(editCustomTrack)
                        
                        ExerciseTitleView(title: $selectedExerciseStore.exercise.title)
                            .disabled(editCustomTrack)
                        
                        TrackPickerView(track: $selectedExerciseStore.exercise.track)
                            .disabled(editCustomTrack)
                        
                        switch selectedExerciseStore.exercise.track {
                        case .constant:
                            ConstantTrackView()
                        case .increasing:
                            IncreasingTrackView()
                        case .decreasing:
                            DecreasingTrackView()
                        case .custom:
                            CustomTrackView(
                                editCustomTrack: $editCustomTrack,
                                scroller: scroller
                            )
                        }
                    }
                    .formStyle(.grouped)
                    .scrollContentBackground(.hidden)
                    .background(.thickMaterial)
                    .toolbar {
                        if selectedExerciseStore.exercise.track == .custom {
                            CustomTrackToolbar(
                                editCustomTrack: $editCustomTrack,
                                scroller: scroller
                            )
                        }
                    }
                    // .animation(.default, value: selectedExerciseStore.exercise)
                    // .contentTransition(.numericText())
                }
            }
            
            if selectedExerciseStore.exercise.id == "" {
                ZStack {
                    Rectangle()
                        .fill(.black)
                    
                    Rectangle()
                        .fill(.thickMaterial)
                    
                    Text("Select Exercise")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
                .ignoresSafeArea()
            }
        }
        .navigationTitle(selectedExerciseStore.detailTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// #Preview {
//     let exercisesRepo = PreviewExercisesRepository()
//     
//     let errorStore = ErrorStore()
//     let exercisesStore = ExercisesStore(errorStore, exercisesRepo)
//     let selectedExerciseStore = SelectedExerciseStore(exercisesStore, exercisesRepo)
//     
//     let _ = selectedExerciseStore.exercise = .defaultConstant(title: "123")
//     
//     NavigationSplitView {
//         Text("")
//             .navigationDestination(isPresented: .constant(true)) {
//                 DetailView(editCustomTrack: .constant(false))
//             }
//     } detail: {
//         
//     }
//     .tint(.primary)
//     .preferredColorScheme(.dark)
//     .ignoresSafeArea()
//     .environmentObject(selectedExerciseStore)
//     .environmentObject(PlayStore(ns: Namespace().wrappedValue))
// }
