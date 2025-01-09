import SwiftUI

enum PlayCirclePlacement: Equatable {
    case detail(_ ID: String)
    case sidebarElement(_ ID: String)
    case play
    case unset
}

extension PlayCirclePlacement {
    func nsID() -> String {
        switch self {
        case .detail(let ID):
            "detail(\(ID))"
        case .sidebarElement(let ID):
            "sidebarElement(\(ID))"
        case .play:
            "play"
        case .unset:
            "unset"
        }
    }
}

class PlayStore: ObservableObject {
    
    let ns: Namespace.ID
    
    var startPlacement: PlayCirclePlacement = .unset
    @Published private(set) var playCirclePlacement: PlayCirclePlacement = .unset
    @Published private(set) var playCircleOpacity: Double = 0
    @Published private(set) var progressPlateOpacity: Double = 0
    
    private var startedAt: Date = .init()
    @Published private(set) var playing: Bool = false
    
    private var timeline: ExerciseTimeline = .init()
    
    // Namespace.ID passed as parameter because it should be created from view. see BreathApp.swift
    init(ns: Namespace.ID) {
        self.ns = ns
    }
    
    func play(from source: PlayCirclePlacement, e: ExerciseModel, for duration: TimeInterval = 1.4) {
        self.timeline = .forModel(e)
        
        self.startPlacement = source
        self.playCirclePlacement = source
        
        let animSteps: [() -> ()] = [
            { self.playCircleOpacity = 1 },
            { self.playCirclePlacement = .play },
            { self.progressPlateOpacity = 1 },
        ]
        
        let singleAnimDur = duration / Double(animSteps.count)
        var totalDelay: Double = 0
        
        for (i, anim) in animSteps.enumerated() {
            // add 0.01 delay to prevent laggy animations
            let delay = 0.01 + singleAnimDur * Double(i)
            totalDelay += delay
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: singleAnimDur)) {
                    anim()
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay) {
            self.playing = true
            self.startedAt = .now
        }
    }
    
    func stop(for duration: TimeInterval = 1.4) {
        let animSteps: [() -> ()] = [
            { self.progressPlateOpacity = 0 },
            { self.playCirclePlacement = self.startPlacement },
            { self.playCircleOpacity = 0 },
        ]
        
        let singleAnimDur = duration / Double(animSteps.count)
        var totalDelay: Double = 0
        
        for (i, action) in animSteps.enumerated() {
            // add 0.01 delay to prevent laggy animations
            let delay = 0.01 + singleAnimDur * Double(i)
            totalDelay += delay
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeInOut(duration: singleAnimDur)) {
                    action()
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDelay) {
            self.playCirclePlacement = .unset
        }
    }
    
    func progressAt(_ at: Date) -> ExerciseProgress {
        self.timeline.progress(at.timeIntervalSince(self.startedAt))
    }
}
