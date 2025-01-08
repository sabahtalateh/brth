import Combine
import SwiftUI

class SelectedExerciseStore: ObservableObject {
    
    @AppStorage("selected_exercise_id")
    private var savedId: String = ""
    
    // @Published var id: String = ""
    // @Published var exerciseSelected: Bool = false
    @Published var exercise: ExerciseModel = .empty()
    @Published var detailTitle: String = ""
    
    var subscriptions = Set<AnyCancellable>()
    
    init(_ exercisesStore: ExercisesStore, _ repo: ExercisesRepository) {
        // if let uuid = UIDevice.current.identifierForVendor?.uuidString {
        //     print(uuid)
        // }
        
        // id = savedId
        
        // $id
        //     .removeDuplicates()
        //     .sink { id in
        //         dprint("-> SelectedExerciseStore.$id:", "set selected exercise", "id:", id)
        //
        //         self.savedId = id
        //
        //         if let e = exercisesStore.exercises.first(where: { e in e.id == id }) {
        //             self.exercise = e
        //             // self.exerciseSelected = true
        //             self.detailTitle = e.title
        //         } else {
        //             if self.id != "" {
        //                 self.id = ""
        //             }
        //             self.exercise = .init()
        //             // self.exerciseSelected = false
        //             self.detailTitle = ""
        //         }
        //     }
        //     .store(in: &subscriptions)
        //
        
        if savedId != "",
           let e = exercisesStore.exercises.first(where: {e in e.id == savedId})
        {
            exercise = e
            self.detailTitle = e.title
        }
        
        $exercise
            .dropFirst()
            .debounce(for: 0.7, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { e in
                dprint("-> SelectedExerciseStore.$exercise:", "id", e.id)
                
                self.savedId = e.id
                self.detailTitle = e.title
                
                if e.id == "" {
                    return
                }
                
                guard let exI = exercisesStore.exercises.firstIndex(where: { ex in ex.id == e.id }) else {
                    return
                }
                
                exercisesStore.exercises[exI] = e
            }
            .store(in: &subscriptions)
    }
}
