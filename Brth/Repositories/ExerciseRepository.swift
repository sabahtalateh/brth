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
            print("Error: \(error). Stack trace: \(Thread.callStackSymbols)")
            throw RepositoryError("save: " + error.localizedDescription)
        }
    }
    
    func load() throws -> [ExerciseModel] {
        do {
            let jsonData = try Data(contentsOf: storageURL)
            let exercises = try JSONDecoder().decode([ExerciseModel].self, from: jsonData)
            return exercises
        } catch {
            print("Error: \(error). Stack trace: \(Thread.callStackSymbols)")
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
            track: .constant,
            constantTrack: .default(),
            increasingTrack: .defaultIncreasing(),
            decreasingTrack: .defaultDecreasing(),
            customTrack: .default()
        )
    }
    
    static func defaultConstant(title: String) -> ExerciseModel {
        ExerciseModel(
            id: UUID().uuidString,
            title: title,
            track: .constant,
            constantTrack: .default(),
            increasingTrack: .defaultIncreasing(),
            decreasingTrack: .defaultDecreasing(),
            customTrack: .default()
        )
    }
    
    static func defaultIncreasing(title: String) -> ExerciseModel {
        ExerciseModel(
            id: UUID().uuidString,
            title: title,
            track: .increasing,
            constantTrack: .default(),
            increasingTrack: .defaultIncreasing(),
            decreasingTrack: .defaultDecreasing(),
            customTrack: .default()
        )
    }
    
    static func defaultDecreasing(title: String) -> ExerciseModel {
        ExerciseModel(
            id: UUID().uuidString,
            title: title,
            track: .decreasing,
            constantTrack: .default(),
            increasingTrack: .defaultIncreasing(),
            decreasingTrack: .defaultDecreasing(),
            customTrack: .default()
        )
    }
    
    static func defaultCustom(title: String) -> ExerciseModel {
        ExerciseModel(
            id: UUID().uuidString,
            title: title,
            track: .custom,
            constantTrack: .default(),
            increasingTrack: .defaultIncreasing(),
            decreasingTrack: .defaultDecreasing(),
            customTrack: .default()
        )
    }
}
