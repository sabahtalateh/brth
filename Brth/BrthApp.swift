import SwiftUI

@main
struct BrthApp: App {
    
    @Namespace var rootNS
    
    let exercisesRepo: ExercisesRepository
    
    let errorStore: ErrorStore
    let settingsStore: SettingsStore
    let exercisesStore: ExercisesStore
    let selectedExerciseStore: SelectedExerciseStore
    
    init() {
        exercisesRepo = AppExercisesRepository()
        
        errorStore = ErrorStore()
        
        do {
            try exercisesRepo.populateExamples()
        } catch {
            print("Error: \(error). Stack trace: \(Thread.callStackSymbols)")
            errorStore.setInternalError()
        }
        
        settingsStore = SettingsStore()
        exercisesStore = ExercisesStore(errorStore, exercisesRepo)
        selectedExerciseStore = SelectedExerciseStore(exercisesStore, exercisesRepo)
    }
    
    var body: some Scene {
        let playStore = PlayStore(ns: rootNS, particleSystem: .init(
            spawnRate: 20,
            limit: 99,
            velocity: 0,
            particleRadius: 0.003..<0.009,
            innerRadius: 0
        ))
        
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
