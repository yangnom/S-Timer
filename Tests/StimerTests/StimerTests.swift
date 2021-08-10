    import XCTest
    import Combine
    @testable import Stimer
    
    //    final class StimerTests: XCTestCase {
    ////        func testExample() {
    ////            // This is an example of a functional test case.
    ////            // Use XCTAssert and related functions to verify your tests produce the correct
    ////            // results.
    ////            XCTAssertEqual(Stimer().text, "Hello, World!")
    ////        }
    //    }
    
    @available(watchOS 6.0, *)
    class StimerTests: XCTestCase {
        // why does this need to be force unwrapped?
        private var cancellables: Set<AnyCancellable>!
        
        override func setUp() {
            super.setUp()
            cancellables = []
        }
        
        //test to see if timer ticks every second and ends gracefully
        func testNewTimer() {
            let stimer = Stimer()
            
            let expectation = self.expectation(description: "Timer complete")
            
            print("Test started")
            stimer.startTimer(timerLength: 5, happensEveryTick: {print("\(stimer.ticks): ticked!")}, timerEnded: {print("Timer finished!")
                expectation.fulfill()
            })
            
            waitForExpectations(timeout: 8)
            XCTAssert(stimer.ticks == 5, "Timer ticked \(stimer.ticks) times")
        }
        
        // test for multiple timers at once
        func test_cantSetMultipleTimers() {
            let stimer = Stimer()
            
            let expectation = self.expectation(description: "One timer")
            
            print("multiple timers test started")
            
            stimer.startTimer(timerLength: 5, happensEveryTick: {print("\(stimer.ticks): ticked!")}, timerEnded: {print("Timer finished!")
                expectation.fulfill()
            })
            
            stimer.startTimer(timerLength: 5, happensEveryTick: {print("\(stimer.ticks): ticked!")}, timerEnded: {print("Timer finished!")
                expectation.fulfill()
            })
            
            waitForExpectations(timeout: 8)
            XCTAssert(stimer.ticks == 5, "Timer ticked \(stimer.ticks) times")
        }
        
        func test_percentTimerDone() {
            let stimer = Stimer()
            let secondsAfterToTestFor = 3
            var counter = 0
            
            let expectation = self.expectation(description: "will complete")
            
            stimer.startTimer(timerLength: 5, happensEveryTick: {
                print("\(stimer.ticks): ticked!")
                counter += 1
                
                if counter % secondsAfterToTestFor == 0 {
                    expectation.fulfill()
                }
            },
            timerEnded: {
                print("Timer finished!")
                //                expectation.fulfill()
            })
            
            waitForExpectations(timeout: 3)
            print("PercentTimerDone is: \(stimer.percentTimerDone)")
            XCTAssert(stimer.percentTimerDone > 0.59, "The timer was \(stimer.percentTimerDone) after 3 seconds")
        }
        
        func test_timerFinishesWith100PercentDone() {
            let stimer = Stimer()
            let expectation = expectation(description: "%100 done")
            
            stimer.startTimer(timerLength: 5, happensEveryTick: {print("\(stimer.ticks) tick!")}) {
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 10)
            XCTAssert(stimer.percentTimerDone == 1.0, "Percent Done: \(stimer.percentTimerDone)")
        }
    }
