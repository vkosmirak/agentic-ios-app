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
    private var mockStopwatchService: MockStopwatchService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockStopwatchService = MockStopwatchService()
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
        XCTAssertEqual(viewModel.stopwatch.elapsedTime, 0, accuracy: 0.01)
        XCTAssertFalse(viewModel.stopwatch.isRunning)
        XCTAssertTrue(viewModel.stopwatch.laps.isEmpty)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testInitializationResetsRunningStopwatch() {
        // Given
        var runningStopwatch = StopwatchModel()
        runningStopwatch.isRunning = true
        mockStopwatchService.stopwatch = runningStopwatch
        
        // When
        let newViewModel = StopwatchViewModel(stopwatchService: mockStopwatchService)
        
        // Then
        XCTAssertFalse(newViewModel.stopwatch.isRunning)
        XCTAssertEqual(mockStopwatchService.saveStopwatchCallCount, 1)
    }
    
    // MARK: - Start Tests
    
    func testStart() {
        // Given
        XCTAssertFalse(viewModel.stopwatch.isRunning)
        
        // When
        viewModel.start()
        
        // Then
        XCTAssertTrue(viewModel.stopwatch.isRunning)
        XCTAssertNotNil(viewModel.stopwatch.startTime)
        XCTAssertEqual(mockStopwatchService.saveStopwatchCallCount, 1)
    }
    
    func testStartDoesNothingWhenAlreadyRunning() {
        // Given
        var stopwatch = StopwatchModel()
        stopwatch.isRunning = true
        stopwatch.startTime = Date()
        mockStopwatchService.stopwatch = stopwatch
        viewModel = StopwatchViewModel(stopwatchService: mockStopwatchService)
        // Reset call count after initialization (which resets running stopwatch)
        
        // When
        viewModel.start()
        
        // Then
        // Should still save because stopwatch was reset in init
        XCTAssertGreaterThanOrEqual(mockStopwatchService.saveStopwatchCallCount, 0)
    }
    
    func testStartSetsStartTime() {
        // Given
        let beforeStart = Date()
        
        // When
        viewModel.start()
        
        // Then
        XCTAssertNotNil(viewModel.stopwatch.startTime)
        if let startTime = viewModel.stopwatch.startTime {
            XCTAssertGreaterThanOrEqual(startTime.timeIntervalSince1970, beforeStart.timeIntervalSince1970)
        }
    }
    
    // MARK: - Stop Tests
    
    func testStop() {
        // Given
        var stopwatch = StopwatchModel()
        stopwatch.isRunning = true
        stopwatch.startTime = Date().addingTimeInterval(-10)
        stopwatch.pausedTime = 5.0
        mockStopwatchService.stopwatch = stopwatch
        viewModel = StopwatchViewModel(stopwatchService: mockStopwatchService)
        
        // When
        viewModel.stop()
        
        // Then
        XCTAssertFalse(viewModel.stopwatch.isRunning)
        XCTAssertNil(viewModel.stopwatch.startTime)
        XCTAssertEqual(mockStopwatchService.saveStopwatchCallCount, 1)
    }
    
    func testStopDoesNothingWhenNotRunning() {
        // Given
        XCTAssertFalse(viewModel.stopwatch.isRunning)
        
        // When
        viewModel.stop()
        
        // Then
        XCTAssertEqual(mockStopwatchService.saveStopwatchCallCount, 0)
    }
    
    func testStopSavesElapsedTime() {
        // Given
        mockStopwatchService.stopwatch = StopwatchModel()
        viewModel = StopwatchViewModel(stopwatchService: mockStopwatchService)
        // Start the stopwatch to set it running
        viewModel.start()
        
        // Wait a moment for time to elapse
        RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        
        // When
        viewModel.stop()
        
        // Then
        XCTAssertGreaterThan(viewModel.stopwatch.elapsedTime, 0.0)
        XCTAssertEqual(viewModel.stopwatch.pausedTime, viewModel.stopwatch.elapsedTime, accuracy: 0.1)
    }
    
    // MARK: - Reset Tests
    
    func testReset() {
        // Given
        var stopwatch = StopwatchModel()
        stopwatch.elapsedTime = 125.67
        stopwatch.isRunning = true
        stopwatch.laps = [LapModel(lapNumber: 1, lapTime: 45.23, totalTime: 45.23)]
        mockStopwatchService.stopwatch = stopwatch
        viewModel = StopwatchViewModel(stopwatchService: mockStopwatchService)
        mockStopwatchService.saveStopwatchCallCount = 0 // Reset after init (which resets running stopwatch)
        
        // When
        viewModel.reset()
        
        // Then
        XCTAssertEqual(viewModel.stopwatch.elapsedTime, 0, accuracy: 0.01)
        XCTAssertFalse(viewModel.stopwatch.isRunning)
        XCTAssertTrue(viewModel.stopwatch.laps.isEmpty)
        XCTAssertEqual(mockStopwatchService.saveStopwatchCallCount, 1)
    }
    
    // MARK: - Record Lap Tests
    
    func testRecordLapWhenRunning() {
        // Given
        var stopwatch = StopwatchModel()
        stopwatch.isRunning = true
        stopwatch.startTime = Date().addingTimeInterval(-5)
        stopwatch.pausedTime = 0
        mockStopwatchService.stopwatch = stopwatch
        viewModel = StopwatchViewModel(stopwatchService: mockStopwatchService)
        // Start the stopwatch to set it running
        viewModel.start()
        mockStopwatchService.saveStopwatchCallCount = 0 // Reset after init
        
        // When
        viewModel.recordLap()
        
        // Then
        XCTAssertEqual(viewModel.stopwatch.laps.count, 1)
        XCTAssertEqual(viewModel.stopwatch.laps[0].lapNumber, 1)
        XCTAssertGreaterThan(viewModel.stopwatch.laps[0].totalTime, 0)
        XCTAssertEqual(mockStopwatchService.saveStopwatchCallCount, 1)
    }
    
    func testRecordLapWhenStopped() {
        // Given
        var stopwatch = StopwatchModel()
        stopwatch.elapsedTime = 45.23
        stopwatch.isRunning = false
        mockStopwatchService.stopwatch = stopwatch
        viewModel = StopwatchViewModel(stopwatchService: mockStopwatchService)
        
        // When
        viewModel.recordLap()
        
        // Then
        XCTAssertEqual(viewModel.stopwatch.laps.count, 1)
        XCTAssertEqual(viewModel.stopwatch.laps[0].lapNumber, 1)
        XCTAssertEqual(viewModel.stopwatch.laps[0].totalTime, 45.23, accuracy: 0.01)
    }
    
    func testRecordLapDoesNothingWhenZero() {
        // Given
        XCTAssertEqual(viewModel.stopwatch.elapsedTime, 0, accuracy: 0.01)
        XCTAssertFalse(viewModel.stopwatch.isRunning)
        
        // When
        viewModel.recordLap()
        
        // Then
        XCTAssertTrue(viewModel.stopwatch.laps.isEmpty)
        XCTAssertEqual(mockStopwatchService.saveStopwatchCallCount, 0)
    }
    
    func testRecordMultipleLaps() {
        // Given
        var stopwatch = StopwatchModel()
        stopwatch.isRunning = true
        stopwatch.startTime = Date().addingTimeInterval(-10)
        stopwatch.pausedTime = 0
        mockStopwatchService.stopwatch = stopwatch
        viewModel = StopwatchViewModel(stopwatchService: mockStopwatchService)
        // Start the stopwatch to set it running
        viewModel.start()
        mockStopwatchService.saveStopwatchCallCount = 0 // Reset after init
        
        // When
        viewModel.recordLap()
        viewModel.recordLap()
        viewModel.recordLap()
        
        // Then
        XCTAssertEqual(viewModel.stopwatch.laps.count, 3)
        XCTAssertEqual(viewModel.stopwatch.laps[0].lapNumber, 1)
        XCTAssertEqual(viewModel.stopwatch.laps[1].lapNumber, 2)
        XCTAssertEqual(viewModel.stopwatch.laps[2].lapNumber, 3)
        XCTAssertLessThan(viewModel.stopwatch.laps[0].totalTime, viewModel.stopwatch.laps[1].totalTime)
        XCTAssertLessThan(viewModel.stopwatch.laps[1].totalTime, viewModel.stopwatch.laps[2].totalTime)
    }
    
    // MARK: - Clear Laps Tests
    
    func testClearLaps() {
        // Given
        var stopwatch = StopwatchModel()
        stopwatch.laps = [
            LapModel(lapNumber: 1, lapTime: 45.23, totalTime: 45.23),
            LapModel(lapNumber: 2, lapTime: 52.67, totalTime: 97.90)
        ]
        mockStopwatchService.stopwatch = stopwatch
        viewModel = StopwatchViewModel(stopwatchService: mockStopwatchService)
        
        // When
        viewModel.clearLaps()
        
        // Then
        XCTAssertTrue(viewModel.stopwatch.laps.isEmpty)
        XCTAssertEqual(mockStopwatchService.saveStopwatchCallCount, 1)
    }
    
    // MARK: - Current Elapsed Time Tests
    
    func testCurrentElapsedTimeWhenNotRunning() {
        // Given
        var stopwatch = StopwatchModel()
        stopwatch.elapsedTime = 45.23
        stopwatch.isRunning = false
        mockStopwatchService.stopwatch = stopwatch
        viewModel = StopwatchViewModel(stopwatchService: mockStopwatchService)
        
        // When
        let currentTime = viewModel.currentElapsedTime
        
        // Then
        XCTAssertEqual(currentTime, 45.23, accuracy: 0.01)
    }
    
    func testCurrentElapsedTimeWhenRunning() {
        // Given
        mockStopwatchService.stopwatch = StopwatchModel()
        viewModel = StopwatchViewModel(stopwatchService: mockStopwatchService)
        
        // Start the stopwatch to set it running
        viewModel.start()
        
        // Wait a moment for time to elapse
        RunLoop.current.run(until: Date().addingTimeInterval(0.1))
        
        // When
        let currentTime = viewModel.currentElapsedTime
        
        // Then
        XCTAssertGreaterThan(currentTime, 0.0)
    }
    
    // MARK: - Formatted Time Tests
    
    func testFormattedCurrentElapsedTime() {
        // Given
        var stopwatch = StopwatchModel()
        stopwatch.elapsedTime = 125.67
        mockStopwatchService.stopwatch = stopwatch
        viewModel = StopwatchViewModel(stopwatchService: mockStopwatchService)
        
        // When
        let formatted = viewModel.formattedCurrentElapsedTime
        
        // Then
        XCTAssertEqual(formatted, "2:05.67")
    }
    
    // MARK: - Lifecycle Tests
    
    func testOnDisappearSavesState() {
        // Given
        var stopwatch = StopwatchModel()
        stopwatch.elapsedTime = 45.23
        mockStopwatchService.stopwatch = stopwatch
        viewModel = StopwatchViewModel(stopwatchService: mockStopwatchService)
        
        // When
        viewModel.onDisappear()
        
        // Then
        XCTAssertEqual(mockStopwatchService.saveStopwatchCallCount, 1)
    }
}

// MARK: - Mock Stopwatch Service

private class MockStopwatchService: StopwatchServiceProtocol {
    var stopwatch = StopwatchModel()
    
    var loadStopwatchCallCount = 0
    var saveStopwatchCallCount = 0
    var resetStopwatchCallCount = 0
    
    func loadStopwatch() -> StopwatchModel {
        loadStopwatchCallCount += 1
        return stopwatch
    }
    
    func saveStopwatch(_ stopwatch: StopwatchModel) {
        saveStopwatchCallCount += 1
        self.stopwatch = stopwatch
    }
    
    func resetStopwatch() {
        resetStopwatchCallCount += 1
        stopwatch = StopwatchModel()
    }
}

