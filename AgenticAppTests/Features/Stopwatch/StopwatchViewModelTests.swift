//
//  StopwatchViewModelTests.swift
//  AgenticAppTests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest
import Combine
@testable import AgenticApp

final class StopwatchViewModelTests: XCTestCase {
    
    private var viewModel: StopwatchViewModel!
    private var mockStopwatchService: StopwatchServiceMock!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockStopwatchService = StopwatchServiceMock()
        viewModel = StopwatchViewModel(stopwatchService: mockStopwatchService)
    }
    
    override func tearDown() {
        viewModel.onDisappear()
        viewModel = nil
        mockStopwatchService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        // Then
        XCTAssertEqual(viewModel.elapsedTime, 0)
        XCTAssertTrue(viewModel.laps.isEmpty)
        XCTAssertFalse(viewModel.isRunning)
        XCTAssertEqual(viewModel.formattedTime, "00:00,00")
    }
    
    // MARK: - Start Tests
    
    func testStart() {
        // When
        viewModel.start()
        
        // Then
        XCTAssertTrue(viewModel.isRunning)
    }
    
    func testStartBeginsTimerUpdates() {
        // When
        viewModel.start()
        
        // Then
        // Wait a bit and check that elapsed time is updating
        let expectation = expectation(description: "Elapsed time should start updating")
        expectation.expectedFulfillmentCount = 1
        
        var initialElapsedTime: TimeInterval = 0
        
        viewModel.$elapsedTime
            .dropFirst()
            .sink { elapsedTime in
                if initialElapsedTime == 0 {
                    initialElapsedTime = elapsedTime
                }
                if elapsedTime > 0.05 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertGreaterThan(viewModel.elapsedTime, 0)
    }
    
    func testStartWhenAlreadyRunning() {
        // Given
        viewModel.start()
        XCTAssertTrue(viewModel.isRunning)
        
        // When
        viewModel.start()
        
        // Then - should not change state
        XCTAssertTrue(viewModel.isRunning)
    }
    
    // MARK: - Stop Tests
    
    func testStop() {
        // Given
        viewModel.start()
        XCTAssertTrue(viewModel.isRunning)
        
        // When
        viewModel.stop()
        
        // Then
        XCTAssertFalse(viewModel.isRunning)
    }
    
    func testStopWhenNotRunning() {
        // Given
        XCTAssertFalse(viewModel.isRunning)
        
        // When
        viewModel.stop()
        
        // Then - should not change state
        XCTAssertFalse(viewModel.isRunning)
    }
    
    // MARK: - Lap Tests
    
    func testLap() {
        // Given
        viewModel.start()
        
        // Wait a bit for elapsed time to accumulate
        let expectation = expectation(description: "Elapsed time should accumulate")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 0.5)
        
        // When
        viewModel.lap()
        
        // Then
        XCTAssertEqual(viewModel.laps.count, 1)
        XCTAssertEqual(viewModel.laps.first?.lapNumber, 1)
    }
    
    func testLapWhenNotRunning() {
        // Given
        XCTAssertFalse(viewModel.isRunning)
        
        // When
        viewModel.lap()
        
        // Then
        XCTAssertTrue(viewModel.laps.isEmpty)
    }
    
    func testMultipleLaps() {
        // Given
        viewModel.start()
        
        // Wait for some elapsed time
        let waitExpectation = expectation(description: "Wait for elapsed time")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            waitExpectation.fulfill()
        }
        wait(for: [waitExpectation], timeout: 0.2)
        
        // When
        viewModel.lap()
        
        // Wait again
        let waitExpectation2 = expectation(description: "Wait for more elapsed time")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            waitExpectation2.fulfill()
        }
        wait(for: [waitExpectation2], timeout: 0.2)
        
        viewModel.lap()
        
        // Then
        XCTAssertEqual(viewModel.laps.count, 2)
        XCTAssertEqual(viewModel.laps[0].lapNumber, 1)
        XCTAssertEqual(viewModel.laps[1].lapNumber, 2)
    }
    
    // MARK: - Reset Tests
    
    func testReset() {
        // Given
        viewModel.start()
        viewModel.lap()
        
        // Wait for some elapsed time
        let waitExpectation = expectation(description: "Wait for elapsed time")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            waitExpectation.fulfill()
        }
        wait(for: [waitExpectation], timeout: 0.2)
        
        // When
        viewModel.reset()
        
        // Then
        XCTAssertFalse(viewModel.isRunning)
        XCTAssertEqual(viewModel.elapsedTime, 0, accuracy: 0.01)
        XCTAssertTrue(viewModel.laps.isEmpty)
    }
    
    func testResetStopsTimer() {
        // Given
        viewModel.start()
        XCTAssertTrue(viewModel.isRunning)
        
        // When
        viewModel.reset()
        
        // Then
        XCTAssertFalse(viewModel.isRunning)
        XCTAssertEqual(viewModel.elapsedTime, 0, accuracy: 0.01)
    }
    
    // MARK: - Fastest/Slowest Lap Tests
    
    func testFastestLap() {
        // Given
        let lap1 = Lap(lapNumber: 1, time: 2.01, lapTime: 2.01) // 2.01 seconds
        let lap2 = Lap(lapNumber: 2, time: 4.56, lapTime: 2.55) // 2.55 seconds
        let lap3 = Lap(lapNumber: 3, time: 5.15, lapTime: 0.59) // 0.59 seconds - fastest
        
        viewModel.laps = [lap1, lap2, lap3]
        
        // When
        let fastest = viewModel.fastestLap
        
        // Then
        XCTAssertNotNil(fastest)
        XCTAssertEqual(fastest?.lapNumber, 3)
        if let fastest = fastest {
            XCTAssertEqual(fastest.lapTime, 0.59, accuracy: 0.01)
        }
    }
    
    func testFastestLapWhenEmpty() {
        // Given
        XCTAssertTrue(viewModel.laps.isEmpty)
        
        // When
        let fastest = viewModel.fastestLap
        
        // Then
        XCTAssertNil(fastest)
    }
    
    func testSlowestLap() {
        // Given
        let lap1 = Lap(lapNumber: 1, time: 2.01, lapTime: 2.01) // 2.01 seconds
        let lap2 = Lap(lapNumber: 2, time: 4.56, lapTime: 2.55) // 2.55 seconds - slowest
        let lap3 = Lap(lapNumber: 3, time: 5.15, lapTime: 0.59) // 0.59 seconds
        
        viewModel.laps = [lap1, lap2, lap3]
        
        // When
        let slowest = viewModel.slowestLap
        
        // Then
        XCTAssertNotNil(slowest)
        XCTAssertEqual(slowest?.lapNumber, 2) // lap2 has the slowest lap time (2.55)
        if let slowest = slowest {
            XCTAssertEqual(slowest.lapTime, 2.55, accuracy: 0.01)
        }
    }
    
    func testSlowestLapWhenEmpty() {
        // Given
        XCTAssertTrue(viewModel.laps.isEmpty)
        
        // When
        let slowest = viewModel.slowestLap
        
        // Then
        XCTAssertNil(slowest)
    }
    
    func testFastestAndSlowestAreDifferent() {
        // Given
        let lap1 = Lap(lapNumber: 1, time: 2.01, lapTime: 2.01)
        let lap2 = Lap(lapNumber: 2, time: 4.56, lapTime: 2.55)
        let lap3 = Lap(lapNumber: 3, time: 5.15, lapTime: 0.59)
        
        viewModel.laps = [lap1, lap2, lap3]
        
        // When
        let fastest = viewModel.fastestLap
        let slowest = viewModel.slowestLap
        
        // Then
        XCTAssertNotNil(fastest)
        XCTAssertNotNil(slowest)
        XCTAssertNotEqual(fastest?.id, slowest?.id)
    }
    
    // MARK: - Formatted Time Tests
    
    func testFormattedTime() {
        // Given
        viewModel.elapsedTime = 14.40
        
        // Then
        XCTAssertEqual(viewModel.formattedTime, "00:14,40")
    }
    
    func testFormattedTimeWithZero() {
        // Given
        viewModel.elapsedTime = 0.0
        
        // Then
        XCTAssertEqual(viewModel.formattedTime, "00:00,00")
    }
    
    // MARK: - Timer Updates Tests
    
    func testTimerUpdatesElapsedTime() {
        // Given
        viewModel.start()
        
        // When - wait for timer updates
        let expectation = expectation(description: "Elapsed time should update")
        expectation.expectedFulfillmentCount = 1
        
        var initialElapsedTime: TimeInterval = 0
        
        viewModel.$elapsedTime
            .dropFirst()
            .sink { elapsedTime in
                if initialElapsedTime == 0 {
                    initialElapsedTime = elapsedTime
                }
                if elapsedTime > 0.1 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        // Then
        XCTAssertGreaterThan(viewModel.elapsedTime, 0)
    }
    
    func testTimerStopsOnStop() {
        // Given
        viewModel.start()
        
        // Wait a bit
        let waitExpectation = expectation(description: "Wait for elapsed time")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            waitExpectation.fulfill()
        }
        wait(for: [waitExpectation], timeout: 0.3)
        
        let elapsedBeforeStop = viewModel.elapsedTime
        
        // When
        viewModel.stop()
        
        // Wait a bit more
        let waitExpectation2 = expectation(description: "Wait after stop")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            waitExpectation2.fulfill()
        }
        wait(for: [waitExpectation2], timeout: 0.3)
        
        // Then - elapsed time should not have increased significantly
        let elapsedAfterStop = viewModel.elapsedTime
        XCTAssertEqual(elapsedAfterStop, elapsedBeforeStop, accuracy: 0.02)
    }
    
    // MARK: - Lifecycle Tests
    
    func testOnAppear() {
        // When
        viewModel.onAppear()
        
        // Then - no-op but should not crash
        XCTAssertFalse(viewModel.isRunning)
    }
    
    func testOnDisappearStopsTimer() {
        // Given
        viewModel.start()
        
        // When
        viewModel.onDisappear()
        
        // Then - timer should be stopped
        // Wait a bit to ensure no updates
        let expectation = expectation(description: "No updates after disappear")
        expectation.isInverted = true
        
        let lastElapsedTime = viewModel.elapsedTime
        
        viewModel.$elapsedTime
            .dropFirst()
            .sink { elapsedTime in
                if abs(elapsedTime - lastElapsedTime) > 0.01 {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    // MARK: - Published Properties Tests
    
    func testElapsedTimeIsPublished() {
        // Given
        let expectation = expectation(description: "Elapsed time should be published")
        
        viewModel.$elapsedTime
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        wait(for: [expectation], timeout: 0.1)
        
        // Then
        XCTAssertNotNil(viewModel.elapsedTime)
    }
    
    func testLapsIsPublished() {
        // Given
        let expectation = expectation(description: "Laps should be published")
        
        viewModel.$laps
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        wait(for: [expectation], timeout: 0.1)
        
        // Then
        XCTAssertNotNil(viewModel.laps)
    }
    
    func testIsRunningIsPublished() {
        // Given
        let expectation = expectation(description: "IsRunning should be published")
        
        viewModel.$isRunning
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        wait(for: [expectation], timeout: 0.1)
        
        // Then
        XCTAssertNotNil(viewModel.isRunning)
    }
}
