import SwiftUI

class ErrorStore: ObservableObject {
    @Published var text: String = ""
    @Published var show: Bool = false
    
    func setError(_ text: String) {
        self.text = text
        show = true
    }
    
    func setInternalError() {
        setError("Internal Error")
    }
}
