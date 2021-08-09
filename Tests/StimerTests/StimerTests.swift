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
        private var cancellables: Set<AnyCancellable>!

        override func setUp() {
            super.setUp()
            cancellables = []
        }

        func testIdentifyingUsernames() {
            let stimer = Stimer()
        
            // Declaring local variables that we'll be able to write
            // our output to, as well as an expectation that we'll
            // use to await our asynchronous result:
            var error: Error?
            let expectation = self.expectation(description: "Tokenization")

            stimer.startTimer(timerLength: 10, happensEveryTick: {_ in print("Tick")}, timerEnded: {
                expectation.fulfill()
            })

            // Awaiting fulfilment of our expecation before
            // performing our asserts:
            waitForExpectations(timeout: 10)

            // Asserting that our Combine pipeline yielded the
            // correct output:
            XCTAssertNil(error)
            XCTAssertEqual(tokens, [.text("Hello "), .username("john")])
        }
    }
