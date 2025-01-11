import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var errorStore: ErrorStore
    @EnvironmentObject var playStore: PlayStore
    
    @State private var editCustomTrack: Bool = false
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    var body: some View {
        let navViewOpacity = 1 - playStore.playCircleOpacity
        
        ZStack {
            PlayView()
            
            NavigationSplitView(columnVisibility: $columnVisibility) {
                SidebarView(editCustomTrack: $editCustomTrack)
            } detail: {
                DetailView(editCustomTrack: $editCustomTrack)
            }
            .navigationSplitViewStyle(.balanced)
            .tint(.primary)
            .opacity(navViewOpacity)
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
        .onAppear {
            
        }
    }
}

#Preview {
    let exercisesRepo = PreviewExercisesRepository()
    
    let errorStore = ErrorStore()
    let exercisesStore = ExercisesStore(errorStore, exercisesRepo)
    let selectedExerciseStore = SelectedExerciseStore(exercisesStore, exercisesRepo)

    ContentView()
        .environmentObject(errorStore)
        .environmentObject(exercisesStore)
        .environmentObject(selectedExerciseStore)
        .environmentObject(PlayStore(ns: Namespace().wrappedValue))
}
