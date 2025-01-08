import SwiftUI

struct SidebarView: View {
    
    @EnvironmentObject var exercisesStore: ExercisesStore
    @EnvironmentObject var selectedExerciseStore: SelectedExerciseStore
    @EnvironmentObject var playStore: PlayStore
    
    @Binding var editCustomTrack: Bool
    
    @State private var presentDestination: Bool = false
    @State private var editMode: EditMode = .inactive
    
    @State private var firstAppear = true
    
    var body: some View {
        ZStack {
            // Circle()
            
            List {
                ForEach(exercisesStore.exercises, id: \.id) { e in
                    let ns = playStore.ns
                    let nsID = PlayCirclePlacement.sidebarElement(e.id).nsID()
                    let isSrc = playStore.playCirclePlacement == .sidebarElement(e.id)
                    
                    Button {
                        // select exercise only if not editing list
                        if editMode != .active {
                            selectedExerciseStore.exercise = e
                            selectedExerciseStore.detailTitle = e.title
                            presentDestination = true
                        }
                    } label: {
                        HStack {
                            Circle()
                                .frame(width: 50, height: 50)
                                .onTapGesture {
                                    // select exercise only if not editing list
                                    if editMode != .active {
                                        playStore.play(from: .sidebarElement(e.id), e: e)
                                        // print("Circle pressed", e.id)
                                        // selectedExerciseStore.exercise = e
                                        // selectedExerciseStore.detailTitle = e.title
                                        // presentDestination = true
                                    }
                                }
                                .matchedGeometryEffect(id: nsID, in: ns, isSource: isSrc)
                            Text("\(e.title)")
                        }
                    }
                    // https://stackoverflow.com/questions/66391155/swiftui-listrowbackground-cant-animate
                    .listRowBackground(
                        Color(selectedExerciseStore.exercise.id == e.id ? .black : .clear)
                            .opacity(0.5)
                            .animation(.easeOut(duration: 0.18))
                    )
                }
                .onMove { ii, i in
                    // TODO: implement
                }
                .onDelete { ii in
                    // TODO: implement
                }
            }
            .listStyle(.plain)
            .background(.thinMaterial)
            .navigationTitle(editMode == .active ? "Edit" : "Exercises")
            .navigationBarTitleDisplayMode(.inline)
            .environment(\.editMode, $editMode)
            .navigationDestination(isPresented: $presentDestination, destination: {
                DetailView(editCustomTrack: $editCustomTrack)
                    .onDisappear {
                        // reset selected row highlight
                        selectedExerciseStore.detailTitle = ""
                        selectedExerciseStore.exercise = .empty()
                    }
            })
            .toolbar {
                Button {
                    withAnimation {
                        if editMode == .active {
                            editMode = .inactive
                        } else {
                            editMode = .active
                            presentDestination = false
                            selectedExerciseStore.exercise = .empty()
                        }
                    }
                } label: {
                    if #available(iOS 17.0, *) {
                        Image(systemName: editMode == .active ? "checkmark" : "pencil")
                            .contentTransition(.symbolEffect(.replace, options: .speed(2)))
                    } else {
                        Image(systemName: editMode == .active ? "checkmark" : "pencil")
                    }
                }
                
                Button {
                    // TODO: action
                } label: {
                    Label {
                        Text("Add Exercise")
                    } icon: {
                        Image(systemName: "plus")
                    }
                }
                .disabled(editMode == .active)
            }
        }
        .onAppear {
            // Fix stupid SwiftUI bug.
            // "firstAppear" state var needs to show selected exercise on app start
            // if it was selected before quit app.
            // If remove "firstAppear" then CustomTrack will jump back and forth
            // when click "back" on iPhone.
            // It is somehow related to toolbar within CustomTrackView. If remove toolbar
            // then it will not jump 😐
            if firstAppear && selectedExerciseStore.exercise.id != "" {
                presentDestination = true
            }
            if firstAppear {
                firstAppear = false
            }
        }
        .disabled(editCustomTrack)
    }
}

#Preview {
    
    let exercisesRepo = PreviewExercisesRepository()
    
    let errorStore = ErrorStore()
    let exercisesStore = ExercisesStore(errorStore, exercisesRepo)
    let selectedExerciseStore = SelectedExerciseStore(exercisesStore, exercisesRepo)
    
    SidebarView(editCustomTrack: .constant(false))
        .preferredColorScheme(.dark)
        .environmentObject(errorStore)
        .environmentObject(exercisesStore)
        .environmentObject(selectedExerciseStore)
        .environmentObject(PlayStore(ns: Namespace().wrappedValue))
}
