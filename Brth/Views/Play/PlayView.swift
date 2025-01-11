import SwiftUI

struct PlayView: View {
    
    @EnvironmentObject var playStore: PlayStore
    
    var body: some View {
        let ns = playStore.ns
        let nsID = playStore.playCirclePlacement.nsID()
        let isSrc = playStore.playCirclePlacement == .play
        // let isSrc = false
        
        let _ = print("SRC", playStore.playCirclePlacement)
        
        VStack {
            Spacer()
            
            TimelineView(.animation(paused: !playStore.playing)) { ctx in
                ZStack {
                    let prog = playStore.progressAt(ctx.date)
                    let el = prog.phaseElapsed
                    
                    switch prog.phase {
                    case .in:
                        Circle()
                            .fill(.secondary)
                            .overlay {
                                VStack {
                                    Text("In")
                                    Text("\(el)")
                                        .monospacedDigit()
                                }
                            }
                    case .inHold:
                        Circle()
                            .fill(.secondary)
                            .overlay {
                                VStack {
                                    Text("In Hold")
                                    Text("\(el)")
                                        .monospacedDigit()
                                }
                            }
                    case .out:
                        Circle()
                            .fill(.secondary)
                            .overlay {
                                VStack {
                                    Text("Out")
                                    Text("\(el)")
                                        .monospacedDigit()
                                }
                            }
                    case .outHold:
                        Circle()
                            .fill(.secondary)
                            .overlay {
                                VStack {
                                    Text("Out Hold")
                                    Text("\(el)")
                                        .monospacedDigit()
                                }
                            }
                    }
                    
                    Circle()
                        .stroke(.red, lineWidth: 4)
                        .opacity(playStore.playCircleOpacity)
                    
                }
                .matchedGeometryEffect(id: nsID, in: ns, isSource: isSrc)
            }
            
            Spacer()
            
            VStack {
                Text("Hello Hello Hello Hello Hello")
                Text("Hello Hello")
                Text("Hello Hello Hello")
                Button {
                    playStore.stop()
                } label: {
                    Image(systemName: "stop.fill")
                }
            }
            .background(.red)
            .opacity(playStore.progressPlateOpacity)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    VStack {
        let ps = PlayStore(ns: Namespace().wrappedValue)
        
        PlayView()
            .preferredColorScheme(.dark)
            .environmentObject(ps)
            .onAppear { ps.play(from: .play, e: .defaultConstant(title: ""), for: 0) }
    }
}

#Preview {
    VStack {
        let ps = PlayStore(ns: Namespace().wrappedValue)
        
        HStack {
            Button("Play") { ps.play(from: .play, e: .defaultConstant(title: "")) }
        }
        
        PlayView()
            .preferredColorScheme(.dark)
            .environmentObject(ps)
    }
}
