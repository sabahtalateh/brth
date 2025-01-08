import SwiftUI

struct ExerciseTitleView: View {
    @Binding var title: String
    // @EnvironmentObject var selectedExerciseStore: SelectedExerciseStore
    
    var body: some View {
        Section {
            TextField("Exercise Title", text: $title)
        } header: {
            Text("Exercise Title")
        }
    }
}

#Preview {
    Form {
        ExerciseTitleView(title: .constant("Zhopa"))
    }
    .preferredColorScheme(.dark)
}
