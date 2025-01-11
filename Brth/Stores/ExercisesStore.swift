import Combine
import SwiftUI

class ExercisesStore: ObservableObject {
    
    @ObservedObject var errorStore: ErrorStore
    
    @Published var exercises: [ExerciseModel] = []
    
    var subscriptions = Set<AnyCancellable>()
    
    init(_ errorStore: ErrorStore, _ repo: ExercisesRepository) {
        self.errorStore = errorStore
        
        do {
            self.exercises = try repo.load()
        } catch {
            print("Error: \(error). Stack trace: \(Thread.callStackSymbols)")
            self.errorStore.setInternalError()
        }
        
        $exercises
            .dropFirst() // drop first "self.exercises = try repo.load()"
            .sink { ee in
                dprint("-> ExercisesStore.$exercises")
                do {
                    try repo.save(ee)
                } catch {
                    print("Error: \(error). Stack trace: \(Thread.callStackSymbols)")
                    self.errorStore.setInternalError()
                }
            }
            .store(in: &subscriptions)
    }
    
    func addExercise() {
        // let titles = exercises.map { m in m.title }
        // 
        // let prefix = "New Exercise"
        // var i = 1
        // var candidate = ""
        // 
        // while true {
        //     candidate = if i == 1 { prefix } else { "\(prefix) \(i)" }
        //     
        //     if !titles.contains(candidate) {
        //         break
        //     }
        //     
        //     i+=1
        // }
        // 
        // exercises.append(ExerciseModel.linear(title: candidate, track: .init()))
    }
}
