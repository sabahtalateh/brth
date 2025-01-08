import SwiftUI

class PreviewExercisesRepository: Repository, ExercisesRepository {
    
    init() {
        let storageDirectory = URL.documentsDirectory.appending(path: "storage")
        let storageURL = storageDirectory.appending(path: "exercises.json")
        
        super.init(storageDirectory: storageDirectory, storageURL: storageURL)
    }
    
    func save(_: [ExerciseModel]) throws {}
    
    func load() throws -> [ExerciseModel] {
        return [
            .defaultConstant(title: "Hello"),
            .defaultConstant(title: "World")
        ]
    }
    
    func populateExamples() throws {}
}
