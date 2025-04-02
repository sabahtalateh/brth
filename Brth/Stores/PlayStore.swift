import SwiftUI

class PlayStore: ObservableObject {
    
    let ns: Namespace.ID
    
    // Prevent exercise deselection when user started exericse
    @Published private(set) var skipExerciseUnselect: Bool = false
    
    @Published var showRemaining: Bool = false
    
    @Published private(set) var hideNavSplitView: Bool = false
    @Published private(set) var showPlayView: Bool = false
    
    @Published private(set) var stopParticles: Bool = false
    @Published private(set) var disablePlayPause: Bool = false
    
    // Internal state
    var playing: Bool = false
    private var startedAt: Date = .distantFuture
    private var pausedAt: Date = .distantFuture
    private var finished: Bool = false
    private var pauseDuration: TimeInterval = 0
    
    private var exercise: ExerciseModel = .empty()
    private var timeline: ExerciseTimeline = .init()
    
    let particleSystem: ParticleSystem
    
    // Namespace.ID passed as parameter because it should be created from view. see BreathApp.swift
    init(ns: Namespace.ID, particleSystem: ParticleSystem) {
        self.ns = ns
        self.particleSystem = particleSystem
    }
    
    func setExercise(_ e: ExerciseModel) {
        self.exercise = e
        self.timeline = .forExercise(e)
    }
    
    func play() {
        if self.playing {
            return
        }
        
        // Unpause
        let intervalSincePause = Date.now.timeIntervalSince(pausedAt)
        let paused = intervalSincePause > 0
        if paused {
            self.playing = true
            self.pausedAt = .distantFuture
            self.pauseDuration += intervalSincePause
            
            self.stopParticles = false
            
            return
        }
        
        // Start
        
        self.particleSystem.reset()
        self.particleSystem.preSpawn()
        
        // Do not unselect selected exercise
        // when exercise screen disappear
        self.skipExerciseUnselect = true
        
        self.pauseDuration = 0
        self.pausedAt = .distantFuture
        self.finished = false
        
        self.stopParticles = false
        self.disablePlayPause = false
        
        withAnimation(.easeInOut(duration: 0.35)) {
            self.hideNavSplitView = true
            self.showPlayView = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.playing = true
            self.startedAt = .now
        }
    }
    
    func pause() {
        if !self.playing {
            return
        }
        
        self.playing = false
        self.pausedAt = .now
        
        self.stopParticles = true
    }
    
    func back() {
        self.skipExerciseUnselect = false
        
        self.pause()
        
        withAnimation(.easeInOut(duration: 0.35)) {
            self.hideNavSplitView = false
            self.showPlayView = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            self.stop()
        }
    }
    
    func progressAt(_ at: Date) -> ExerciseProgress {
        if self.finished {
            return self.timeline.progressOnEnd()
        }
        
        var interval = at.timeIntervalSince(self.startedAt)
        let startedInFuture = interval < 0
        if startedInFuture {
            interval = 0
        }
        
        if !startedInFuture && !self.playing && !self.finished {
            let pausedFor = at.timeIntervalSince(self.pausedAt)
            interval -= pausedFor
        }
        
        let elapsed = interval - pauseDuration
        let (prog, done) = self.timeline.progressOn(elapsed)
        
        if done && !self.finished {
            self.stop()
        }
        
        return prog
    }
    
    private func stop() {
        self.finished = true
        self.playing = false
        self.startedAt = .distantFuture
        self.pausedAt = .distantFuture
        
        DispatchQueue.main.async {
            self.disablePlayPause = true
        }
    }
}
