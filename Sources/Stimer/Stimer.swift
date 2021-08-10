import Foundation
import Combine
import SwiftUI

@available(watchOS 6.0, *)
@available(iOS 13.0, *)
@available(macOS 10.15, *)

public class Stimer: ObservableObject {
        var subscriptions = Set<AnyCancellable>()
        
        @Published public var timerLength = 120.0
        @Published public var elapsedTime = 15.0
        public var paused = true
        public var running = false
        public var ticks = 0

    // TODO: var needs better name
        public var timeElapsedBeforePause = 0.0

    
        public var timeLeft: Double {
            timerLength - elapsedTime
        }
        
        public var percentTimerDone: Double {
            elapsedTime / timerLength
        }
        
    public init() {
        print("timer loaded")
    }
    
     public func oldTimer(timerLength: Double, happensEveryTick: @escaping () -> (), timerEnded: @escaping () -> ()) {
            // set everything up
            self.timerLength = timerLength
            let now = Date()
            guard paused == true else { return }
            paused = false
                        
            // start the timer
            Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .prefix(while: { _ in self.timeLeft > 0.0
                    && self.paused == false
                })
                .map { $0.timeIntervalSince(now) + self.timeElapsedBeforePause }
                .sink(receiveCompletion: {_ in
                    // timer ends
                    if self.paused == false {
                        self.elapsedTime = 0.0
                        self.timeElapsedBeforePause = 0.0
                        self.paused = true
                        timerEnded()
                    } else {
                    // timer pauses
                        self.timeElapsedBeforePause = self.elapsedTime
                    }
                }, receiveValue: {
                    self.elapsedTime = $0
                    happensEveryTick()
                })
                .store(in: &subscriptions)}
    
    
    public func startTimer(timerLength: Double, happensEveryTick: @escaping () -> (), timerEnded: @escaping () -> ()) {
        guard self.running == false else { return }
        let timerStartTime = Date()
        self.running = true
        self.timerLength = timerLength
        
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
//            .prefix(while: { _ in self.ticks < Int(timerLength) && self.running == true })
            .prefix(while: { _ in self.ticks < Int(timerLength)})
            .map { $0.timeIntervalSince(timerStartTime) }
            .sink(receiveCompletion: {_ in
                // make sure that the timer ends with percentDone = 1.0
                self.elapsedTime = self.timerLength
                timerEnded()
            }, receiveValue: {elapsedTime in
                happensEveryTick()
                self.elapsedTime = elapsedTime
                self.ticks += 1
            }).store(in: &subscriptions)
    }
}
