import SwiftUI

class Repository {
    
    let storageDirectory: URL
    let storageURL: URL
    
    var initError: Error?
    
    init(storageDirectory: URL, storageURL: URL) {
        self.storageDirectory = storageDirectory
        self.storageURL = storageURL
        
        do {
            try initFileSystem()
        } catch {
            initError = error
        }
    }
    
    func initFileSystem() throws {
        // throw URLError(URLError.badURL)
        
        try FileManager
            .default
            .createDirectory(
                atPath: self.storageDirectory.path,
                withIntermediateDirectories: true,
                attributes: nil
            )
        
#if DEBUG
        print("DEBUG:", "App Exercises Repository:", "Init File System:", "Storage File Created:", self.storageURL)
#endif
    }
    
    func getInitError() -> Error? {
        return initError
    }
}
