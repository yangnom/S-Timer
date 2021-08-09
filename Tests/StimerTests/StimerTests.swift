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
    }
