import SwiftUI

class SettingsStore: ObservableObject {
    @AppStorage("examples_populated")
    var examplesPopulated: Bool = false
    
    
}
