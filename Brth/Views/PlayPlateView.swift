import SwiftUI

fileprivate func phaseRemaining(_ p: ExerciseProgress) -> String {
    var v = p.phaseDuration - p.phaseElapsed
    if v >= 1/15 {
        v = ceil(v)
    }
    return String("\(min(Int(v), 99))")
}

struct PlayPlateView: View {
    
    let exerciseProgress: ExerciseProgress
    
    @EnvironmentObject var playStore: PlayStore
    
    @State private var paused: Bool = false
    
    // Hide countdown numbers before hide plate itself
    // to prevent numbers jumping
    @Binding var countdownHidden: Bool
    @Binding var plateHidden: Bool
    
    @ScaledMetric var counterWidth: Double = 42
    @ScaledMetric var buttonHeight: Double = 32
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            HStack(spacing: 0) {
                
                let remaining = phaseRemaining(exerciseProgress)
                
                Text(remaining)
                    .contentTransition(.numericText())
                    .font(.title)
                    .foregroundStyle(.primary)
                    .monospacedDigit()
                    .lineLimit(1)
                    .frame(width: counterWidth, alignment: .center)
                    .padding(.trailing)
                    .overlay(alignment: .trailing) { Divider() }
                    .animation(.default, value: remaining)
                    .opacity(countdownHidden ? 0 : 1)
                
                let icons = exerciseProgress.icons
                
                // MARK: - Phases icons
                HStack {
                    // Phases icons
                    ForEach(icons) { icon in
                        
                        // Enlarge first icon and make if brighter
                        let isFirst = icons.firstIndex(of: icon) == 0
                        
                        PhaseIcons.icon(for: icon.phase)
                            .foregroundStyle(isFirst ? .primary : .secondary)
                            .scaleEffect(isFirst ? 1.0 : 0.85)
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                )
                            )
                    }
                    
                    // Empty phases icons
                    ForEach(0..<4-icons.count, id: \.self) { _ in
                        Image(systemName: "circle.fill")
                            .foregroundStyle(.tertiary)
                            .scaleEffect(0.5)
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: .trailing).combined(with: .opacity),
                                    removal: .move(edge: .leading).combined(with: .opacity)
                                )
                            )
                    }
                }
                .font(.title)
                .padding(.horizontal)
                .animation(.default, value: icons)
            }
            .padding(.bottom)
            
            switch exerciseProgress.duration {
            case .infinity:
                EmptyView()
            case .seconds(let total):
                HStack {
                    Text(formatSeconds(Int(exerciseProgress.elapsed)))
                        .font(.footnote)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                    
                    let progress = if total == 0 {
                        1.0
                    } else {
                        exerciseProgress.elapsed / Double(total)
                    }
                    
                    ProgressView(value: max(min(progress, 1), 0), total: 1)
                        .tint(.secondary)
                    
                    let total = if !playStore.showRemaining {
                        formatSeconds(total)
                    } else {
                        "-" + formatSeconds(total - Int(exerciseProgress.elapsed))
                    }
                    
                    Text(total)
                        .font(.footnote)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
                .onTapGesture {
                    playStore.showRemaining.toggle()
                }
            }
            
            HStack {
                Spacer()
                
                Button {
                    playStore.back()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .font(.title)
                .tint(.primary)
                .padding(.horizontal)
                .frame(minHeight: buttonHeight)
                
                if exerciseProgress.duration == .infinity {
                    Spacer()
                    
                    Text(formatSeconds(Int(exerciseProgress.elapsed)))
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button {
                    if paused {
                        playStore.play()
                        paused = false
                    } else {
                        playStore.pause()
                        paused = true
                    }
                } label: {
                    if #available(iOS 17.0, *) {
                        Image(systemName: paused ? "play.fill" : "pause.fill")
                            .contentTransition(.symbolEffect(.replace))
                    } else {
                        Image(systemName: paused ? "play.fill" : "pause.fill")
                            .animation(.default, value: paused)
                    }
                }
                .font(.title)
                .tint(.primary)
                .padding(.horizontal)
                .frame(minHeight: buttonHeight)
                .disabled(playStore.disablePlayPause)
                .animation(.default, value: playStore.disablePlayPause)
                
                Spacer()
                
                Button {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 0.15)) { countdownHidden = true }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.easeInOut(duration: 0.35)) { plateHidden = true }
                    }
                } label: {
                    Image(systemName: "chevron.compact.down")
                }
                .font(.title)
                .tint(.primary)

                Spacer()
            }
            .padding(.top)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        }
    }
}

#Preview {
    let particleSystem = ParticleSystem(
        spawnRate: 20,
        limit: 99,
        velocity: 0,
        particleRadius: 0.003..<0.009,
        innerRadius: 0
    )
    
    VStack {
        Spacer()
        PlayPlateView(
            exerciseProgress: ExerciseProgress(),
            countdownHidden: .constant(false),
            plateHidden: .constant(false)
        )
        Spacer()
    }
    .padding()
    // .preferredColorScheme(.dark)
    .environmentObject(PlayStore(
        ns: Namespace().wrappedValue,
        particleSystem: particleSystem
    ))
}
