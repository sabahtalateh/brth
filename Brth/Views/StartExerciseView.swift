import SwiftUI

func formatSeconds(_ seconds: Int) -> String {
    let minutes = seconds / 60
    let remainingSeconds = seconds % 60
    return String(format: "%02d:%02d", minutes, remainingSeconds)
}

struct StartExerciseView: View {
    
    @EnvironmentObject var selectedExerciseStore: SelectedExerciseStore
    @EnvironmentObject var playStore: PlayStore
    
    var scroller: ScrollViewProxy
    
    var exerciseDuration: Text {
        switch selectedExerciseStore.exercise.duration() {
        case .infinity:
            Text("\(Image(systemName: "infinity"))")
        case .seconds(let val):
            Text("\(formatSeconds(val))")
        }
    }
    
    var body: some View {
        let ns = playStore.ns
        
        let e = selectedExerciseStore.exercise
        
        let eID = e.id
        let nsID = PlayCirclePlacement.detail(eID).nsID()
        let isSrc = playStore.playCirclePlacement == .detail(eID)
        
        Section {
            HStack {
                Spacer()
                
                GeometryReader { g in
                    Button {
                        playStore.play(from: .detail(eID), e: e)
                    } label: {
                        ZStack {
                            Circle()
                                .stroke(.white, lineWidth: 3)
                            
                            Image(systemName: "play.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(.primary)
                                .backgroundStyle(.thickMaterial)
                        }
                        .matchedGeometryEffect(id: nsID, in: ns, isSource: isSrc)
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

#Preview {
    let exercisesRepo = PreviewExercisesRepository()
    
    let errorStore = ErrorStore()
    let exercisesStore = ExercisesStore(errorStore, exercisesRepo)
    let selectedExerciseStore = SelectedExerciseStore(exercisesStore, exercisesRepo)
    
    let _ = selectedExerciseStore.exercise = .defaultConstant(title: "123")
    
    ScrollViewReader { scroller in
        Form {
            StartExerciseView(scroller: scroller)
                .preferredColorScheme(.dark)
        }
        .tint(.primary)
    }
    .environmentObject(selectedExerciseStore)
    .environmentObject(PlayStore(ns: Namespace().wrappedValue))
}
