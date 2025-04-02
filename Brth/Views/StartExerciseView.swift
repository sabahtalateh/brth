import SwiftUI

struct StartExerciseView: View {
    
    @EnvironmentObject var selectedExerciseStore: SelectedExerciseStore
    @EnvironmentObject var playStore: PlayStore
    
    var scroller: ScrollViewProxy
    
    var exerciseDuration: Text {
        switch selectedExerciseStore.exercise.duration {
        case .infinity:
            Text("\(Image(systemName: "infinity"))")
        case .seconds(let val):
            Text("\(formatSeconds(val))")
        }
    }
    
    var body: some View {
        // let ns = playStore.ns
        
        let e = selectedExerciseStore.exercise
        
        Section {
            HStack {
                Spacer()
                
                GeometryReader { g in
                    Button {
                        playStore.setExercise(e)
                        playStore.play()
                    } label: {
                        ZStack {
                            Circle()
                                .stroke(.white, lineWidth: 3)
                            
                            Image(systemName: "play.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(.primary)
                                .backgroundStyle(.thickMaterial)
                        }
                    }
                    .buttonStyle(NoTapAnimationStyle())
                    // .onChange(of: g.frame(in: .scrollView)) { oldValue, newValue in
                    //     showToolbarStartButton = newValue.maxY < 0
                    // }
                }
                .frame(width: 100, height: 100)
                
                Spacer()
            }
            
            HStack {
                Label {
                    Text("Exercise Duration")
                } icon: {
                    Image(systemName: "recordingtape")
                }
                
                Spacer()
                
                exerciseDuration
                    .fontWeight(.bold)
                    .monospacedDigit()
            }
            
        } header: {
            Text("Start Exercise")
        }
    }
}

// #Preview {
//     let exercisesRepo = PreviewExercisesRepository()
//     
//     let errorStore = ErrorStore()
//     let exercisesStore = ExercisesStore(errorStore, exercisesRepo)
//     let selectedExerciseStore = SelectedExerciseStore(exercisesStore, exercisesRepo)
//     
//     let _ = selectedExerciseStore.exercise = .defaultConstant(title: "123")
//     
//     ScrollViewReader { scroller in
//         Form {
//             StartExerciseView(scroller: scroller)
//                 .preferredColorScheme(.dark)
//         }
//         .tint(.primary)
//     }
//     .environmentObject(selectedExerciseStore)
//     .environmentObject(PlayStore(ns: Namespace().wrappedValue))
// }
