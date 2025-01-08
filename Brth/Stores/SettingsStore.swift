import SwiftUI

class SettingsStore: ObservableObject {
    @AppStorage("populate_examples")
    var examplesPopulated: Bool = false
    
    
}
