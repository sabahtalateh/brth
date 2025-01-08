import SwiftUI

@main
struct BrthApp: App {
    
    @Namespace var rootNS
    
    var body: some Scene {
        let exercisesRepo = AppExercisesRepository()
        
        let errorStore = ErrorStore()
        let settingsStore = SettingsStore()
        let exercisesStore = ExercisesStore(errorStore, exercisesRepo)
        let selectedExerciseStore = SelectedExerciseStore(exercisesStore, exercisesRepo)
        let playStore = PlayStore(ns: rootNS)
        
        WindowGroup {
            ContentView()
                .environmentObject(errorStore)
                .environmentObject(settingsStore)
                .environmentObject(exercisesStore)
                .environmentObject(selectedExerciseStore)
                .environmentObject(playStore)
        }
    }
}
