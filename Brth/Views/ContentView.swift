import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var errorStore: ErrorStore
    @EnvironmentObject var playStore: PlayStore
    
    @State private var editCustomTrack: Bool = false
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @State private var exercisePlaying: Bool = false
    
    var body: some View {
        ZStack {
            if playStore.showPlayView {
                PlayView()
                    .transition(.move(edge: .trailing))
            }
            
            if !playStore.hideNavSplitView {
                NavigationSplitView(columnVisibility: $columnVisibility) {
                    SidebarView(editCustomTrack: $editCustomTrack)
                } detail: {
                    DetailView(editCustomTrack: $editCustomTrack)
                }
                .navigationSplitViewStyle(.balanced)
                .tint(.primary)
                .transition(.move(edge: .leading))
            }
        }
        .alert(
            errorStore.text,
            isPresented: $errorStore.show,
            actions: {
                Button("Exit", role: .destructive) { exit(1) }
                Button("Cancel", role: .cancel) {  }
            },
            message: { Text("Exit application and try launch it again") }
        )
        .ignoresSafeArea()
        .preferredColorScheme(.dark)
    }
}

// #Preview {
//     let exercisesRepo = PreviewExercisesRepository()
//     
//     let errorStore = ErrorStore()
//     let exercisesStore = ExercisesStore(errorStore, exercisesRepo)
//     let selectedExerciseStore = SelectedExerciseStore(exercisesStore, exercisesRepo)
// 
//     ContentView()
//         .environmentObject(errorStore)
//         .environmentObject(exercisesStore)
//         .environmentObject(selectedExerciseStore)
//         .environmentObject(PlayStore(ns: Namespace().wrappedValue))
// }
