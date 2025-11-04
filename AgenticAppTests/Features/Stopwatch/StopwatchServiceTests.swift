//
//  StopwatchServiceTests.swift
//  AgenticAppTests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest
@testable import AgenticApp

final class StopwatchServiceTests: XCTestCase {
    
    private var stopwatchService: StopwatchService!
    private var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        // Use a separate UserDefaults suite for testing to avoid conflicts
        userDefaults = UserDefaults(suiteName: "com.readdle.AgenticApp.stopwatch.tests")
        userDefaults?.removePersistentDomain(forName: "com.readdle.AgenticApp.stopwatch.tests")
        stopwatchService = StopwatchService(userDefaults: userDefaults)
    }
    
    override func tearDown() {
        // Clean up test data
        userDefaults?.removePersistentDomain(forName: "com.readdle.AgenticApp.stopwatch.tests")
        stopwatchService = nil
        userDefaults = nil
        super.tearDown()
    }
    
    // MARK: - Load Tests
    
    func testLoadStopwatchEmpty() {
        // When
        let stopwatch = stopwatchService.loadStopwatch()
        
        // Then
        XCTAssertEqual(stopwatch.elapsedTime, 0, accuracy: 0.01)
        XCTAssertFalse(stopwatch.isRunning)
        XCTAssertTrue(stopwatch.laps.isEmpty)
    }
    
    func testLoadStopwatch() {
        // Given
        let stopwatch = StopwatchModel(
            elapsedTime: 125.67,
            isRunning: true,
            laps: [LapModel(lapNumber: 1, lapTime: 45.23, totalTime: 45.23)]
        )
        stopwatchService.saveStopwatch(stopwatch)
        
        // When
        let loadedStopwatch = stopwatchService.loadStopwatch()
        
        // Then
        XCTAssertEqual(loadedStopwatch.id, stopwatch.id)
        XCTAssertEqual(loadedStopwatch.elapsedTime, stopwatch.elapsedTime, accuracy: 0.01)
        XCTAssertEqual(loadedStopwatch.isRunning, stopwatch.isRunning)
        XCTAssertEqual(loadedStopwatch.laps.count, stopwatch.laps.count)
    }
    
    // MARK: - Save Tests
    
    func testSaveStopwatch() {
        // Given
        let stopwatch = StopwatchModel(
            elapsedTime: 125.67,
            isRunning: true,
            laps: [LapModel(lapNumber: 1, lapTime: 45.23, totalTime: 45.23)]
        )
        
        // When
        stopwatchService.saveStopwatch(stopwatch)
        
        // Then
        let loadedStopwatch = stopwatchService.loadStopwatch()
        XCTAssertEqual(loadedStopwatch.id, stopwatch.id)
        XCTAssertEqual(loadedStopwatch.elapsedTime, stopwatch.elapsedTime, accuracy: 0.01)
        XCTAssertEqual(loadedStopwatch.isRunning, stopwatch.isRunning)
        XCTAssertEqual(loadedStopwatch.laps.count, stopwatch.laps.count)
    }
    
    func testSaveStopwatchWithLaps() {
        // Given
        let laps = [
            LapModel(lapNumber: 1, lapTime: 45.23, totalTime: 45.23),
            LapModel(lapNumber: 2, lapTime: 52.67, totalTime: 97.90),
            LapModel(lapNumber: 3, lapTime: 48.12, totalTime: 146.02)
        ]
        let stopwatch = StopwatchModel(elapsedTime: 146.02, laps: laps)
        
        // When
        stopwatchService.saveStopwatch(stopwatch)
        
        // Then
        let loadedStopwatch = stopwatchService.loadStopwatch()
        XCTAssertEqual(loadedStopwatch.laps.count, 3)
        XCTAssertEqual(loadedStopwatch.laps[0].lapNumber, 1)
        XCTAssertEqual(loadedStopwatch.laps[1].lapNumber, 2)
        XCTAssertEqual(loadedStopwatch.laps[2].lapNumber, 3)
    }
    
    // MARK: - Reset Tests
    
    func testResetStopwatch() {
        // Given
        let stopwatch = StopwatchModel(
            elapsedTime: 125.67,
            isRunning: true,
            laps: [LapModel(lapNumber: 1, lapTime: 45.23, totalTime: 45.23)]
        )
        stopwatchService.saveStopwatch(stopwatch)
        
        // When
        stopwatchService.resetStopwatch()
        
        // Then
        let loadedStopwatch = stopwatchService.loadStopwatch()
        XCTAssertEqual(loadedStopwatch.elapsedTime, 0, accuracy: 0.01)
        XCTAssertFalse(loadedStopwatch.isRunning)
        XCTAssertTrue(loadedStopwatch.laps.isEmpty)
    }
    
    // MARK: - Update Tests
    
    func testUpdateStopwatch() {
        // Given
        let stopwatch1 = StopwatchModel(elapsedTime: 45.23)
        stopwatchService.saveStopwatch(stopwatch1)
        
        // When
        var updatedStopwatch = stopwatch1
        updatedStopwatch.elapsedTime = 125.67
        updatedStopwatch.isRunning = true
        stopwatchService.saveStopwatch(updatedStopwatch)
        
        // Then
        let loadedStopwatch = stopwatchService.loadStopwatch()
        XCTAssertEqual(loadedStopwatch.id, stopwatch1.id)
        XCTAssertEqual(loadedStopwatch.elapsedTime, 125.67, accuracy: 0.01)
        XCTAssertTrue(loadedStopwatch.isRunning)
    }
}

