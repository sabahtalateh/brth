import SwiftUI

protocol ExercisesRepository {
    func save(_: [ExerciseModel]) throws
    func load() throws -> [ExerciseModel]
    func populateExamples() throws
    func getInitError() -> Error?
}

class AppExercisesRepository: Repository, ExercisesRepository {
    
    init() {
        let storageDirectory = URL.documentsDirectory.appending(path: "storage")
        let storageURL = storageDirectory.appending(path: "exercises.json")
        
        super.init(storageDirectory: storageDirectory, storageURL: storageURL)
    }
    
    func save(_ exercises: [ExerciseModel]) throws {
        do {
            let data = try JSONEncoder().encode(exercises)
            try data.write(to: storageURL)
        } catch {
            throw RepositoryError("save: " + error.localizedDescription)
        }
    }
    
    func load() throws -> [ExerciseModel] {
        do {
            let jsonData = try Data(contentsOf: storageURL)
            var exercises = try JSONDecoder().decode([ExerciseModel].self, from: jsonData)
            
        //     for i in exercises.indices {
        //         for j in exercises[i].customTrack.steps.indices {
        //             exercises[i].customTrack.steps[j].viewId = UUID().uuidString
        //             exercises[i].customTrack.steps[j].viewIdx = j
        //         }
        //     }
            
            return exercises
        } catch {
            throw RepositoryError("load exercises: " + error.localizedDescription)
        }
    }
    
    func populateExamples() throws {
        try save([
            .defaultConstant(title: "5 in; 5 out"),
            .defaultIncreasing(title: "In 1 to 10"),
            .defaultDecreasing(title: "In 10 to 1"),
            .defaultCustom(title: "Custom 1"),
            .defaultCustom(title: "Custom 2")
        ])
    }
}

extension ExerciseModel {
    static func empty() -> ExerciseModel {
        ExerciseModel(
            id: "",
            title: "",
            track: Tracks.constant,
            constantTrack: .default(),
            increasingTrack: .default(),
            decreasingTrack: .default(),
            customTrack: .default()
        )
    }
    
    static func defaultConstant(title: String) -> ExerciseModel {
        ExerciseModel(
            id: UUID().uuidString,
            title: title,
            track: Tracks.constant,
            constantTrack: .default(),
            increasingTrack: .default(),
            decreasingTrack: .default(),
            customTrack: .default()
        )
    }
    
    static func defaultIncreasing(title: String) -> ExerciseModel {
        ExerciseModel(
            id: UUID().uuidString,
            title: title,
            track: Tracks.increasing,
            constantTrack: .default(),
            increasingTrack: .default(),
            decreasingTrack: .default(),
            customTrack: .default()
        )
    }
    
    static func defaultDecreasing(title: String) -> ExerciseModel {
        ExerciseModel(
            id: UUID().uuidString,
            title: title,
            track: Tracks.decreasing,
            constantTrack: .default(),
            increasingTrack: .default(),
            decreasingTrack: .default(),
            customTrack: .default()
        )
    }
    
    static func defaultCustom(title: String) -> ExerciseModel {
        ExerciseModel(
            id: UUID().uuidString,
            title: title,
            track: Tracks.custom,
            constantTrack: .default(),
            increasingTrack: .default(),
            decreasingTrack: .default(),
            customTrack: .default()
        )
    }
}
