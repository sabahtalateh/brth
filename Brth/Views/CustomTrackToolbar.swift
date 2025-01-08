import SwiftUI

struct CustomTrackToolbar: View {
    
    @EnvironmentObject var selectedExerciseStore: SelectedExerciseStore
    
    @Binding var editCustomTrack: Bool
    
    var scroller: ScrollViewProxy
    
    var customTrack: CustomTrackModel {
        selectedExerciseStore.exercise.customTrack
    }
    
    var body: some View {
        Group {
            Button {
                withAnimation { editCustomTrack.toggle() }
            } label: {
                if #available(iOS 17.0, *) {
                    Image(systemName: editCustomTrack ? "checkmark" : "pencil")
                        .contentTransition(.symbolEffect(.replace, options: .speed(2)))
                } else {
                    Image(systemName: editCustomTrack ? "checkmark" : "pencil")
                }
            }
            
            Button {
                withAnimation {
                    selectedExerciseStore.exercise.customTrack.addStep()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    withAnimation {
                        if let lst = customTrack.steps.last {
                            scroller.scrollTo(lst.id, anchor: .top)
                        }
                    }
                }
            } label: {
                Label("Add", systemImage: "plus")
            }
            .disabled(editCustomTrack)
        }
        .navigationBarBackButtonHidden(editCustomTrack)
    }
}
