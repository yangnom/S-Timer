import Foundation
import Combine
import SwiftUI

@available(watchOS 6.0, *)
@available(iOS 13.0, *)
@available(macOS 10.15, *)

public class Stimer: ObservableObject {
        var subscriptions = Set<AnyCancellable>()
        
        @Published public var timerLength = 120.0
        @Published public var elapsedTime = 30.0
        var remainingTime = 0.0
        var paused = true
        
        var timeLeft: Double {
            timerLength - elapsedTime
        }
        
        var percentTimerDone: Double {
            elapsedTime / timerLength
        }
        
    public init() {
        print("timer loaded")
    }
    
     public func startTimer(timerLength: Double, happensEveryTick: @escaping (Double) -> (), timerEnded: @escaping () -> ()) {
            // set everything up
            self.timerLength = timerLength
        print("timerLength is: \(self.timerLength)")
            let now = Date()
            guard paused == true else { return }
            paused = false
                        
            // start the timer
            Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .prefix(while: { _ in self.timeLeft > 0.0
                    && self.paused == false
                })
                .map { $0.timeIntervalSince(now) + self.remainingTime }
                .sink(receiveCompletion: {_ in
                    // timer ends
                    if self.paused == false {
                        self.elapsedTime = 0.0
                        self.remainingTime = 0.0
                        self.paused = true
                        timerEnded()
                    } else {
                    // timer pauses
                        self.remainingTime = self.elapsedTime
                    }
                }, receiveValue: {
                    self.elapsedTime = $0
                    happensEveryTick(self.percentTimerDone)
                })
                .store(in: &subscriptions)}
}
