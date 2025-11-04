//
//  StopwatchModelTests.swift
//  AgenticAppTests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest
@testable import AgenticApp

final class StopwatchModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitializationWithDefaults() {
        // When
        let stopwatch = StopwatchModel()
        
        // Then
        XCTAssertNotNil(stopwatch.id)
        XCTAssertEqual(stopwatch.elapsedTime, 0, accuracy: 0.01)
        XCTAssertFalse(stopwatch.isRunning)
        XCTAssertNil(stopwatch.startTime)
        XCTAssertEqual(stopwatch.pausedTime, 0, accuracy: 0.01)
        XCTAssertTrue(stopwatch.laps.isEmpty)
        XCTAssertNotNil(stopwatch.createdAt)
        XCTAssertNotNil(stopwatch.lastUpdated)
    }
    
    func testInitializationWithAllParameters() {
        // Given
        let id = UUID()
        let elapsedTime: TimeInterval = 125.67
        let isRunning = true
        let startTime = Date()
        let pausedTime: TimeInterval = 0
        let laps = [LapModel(lapNumber: 1, lapTime: 45.23, totalTime: 45.23)]
        let createdAt = Date().addingTimeInterval(-100)
        let lastUpdated = Date()
        
        // When
        let stopwatch = StopwatchModel(
            id: id,
            elapsedTime: elapsedTime,
            isRunning: isRunning,
            startTime: startTime,
            pausedTime: pausedTime,
            laps: laps,
            createdAt: createdAt,
            lastUpdated: lastUpdated
        )
        
        // Then
        XCTAssertEqual(stopwatch.id, id)
        XCTAssertEqual(stopwatch.elapsedTime, elapsedTime, accuracy: 0.01)
        XCTAssertTrue(stopwatch.isRunning)
        XCTAssertNotNil(stopwatch.startTime)
        XCTAssertEqual(stopwatch.pausedTime, pausedTime, accuracy: 0.01)
        XCTAssertEqual(stopwatch.laps.count, 1)
        XCTAssertEqual(stopwatch.createdAt.timeIntervalSince1970, createdAt.timeIntervalSince1970, accuracy: 0.1)
        XCTAssertEqual(stopwatch.lastUpdated.timeIntervalSince1970, lastUpdated.timeIntervalSince1970, accuracy: 0.1)
    }
    
    // MARK: - Formatting Tests
    
    func testFormattedElapsedTime() {
        // Given
        let stopwatch1 = StopwatchModel(elapsedTime: 45.23)
        let stopwatch2 = StopwatchModel(elapsedTime: 125.67)
        
        // Then
        XCTAssertEqual(stopwatch1.formattedElapsedTime, "0:45.23")
        XCTAssertEqual(stopwatch2.formattedElapsedTime, "2:05.67")
    }
    
    // MARK: - Current Elapsed Time Tests
    
    func testCurrentElapsedTimeWhenNotRunning() {
        // Given
        let stopwatch = StopwatchModel(elapsedTime: 45.23, isRunning: false)
        
        // When
        let currentTime = stopwatch.currentElapsedTime()
        
        // Then
        XCTAssertEqual(currentTime, 45.23, accuracy: 0.01)
    }
    
    func testCurrentElapsedTimeWhenRunning() {
        // Given
        let startTime = Date().addingTimeInterval(-10) // Started 10 seconds ago
        let pausedTime: TimeInterval = 5.0
        let stopwatch = StopwatchModel(
            elapsedTime: 5.0,
            isRunning: true,
            startTime: startTime,
            pausedTime: pausedTime
        )
        
        // When
        let currentTime = stopwatch.currentElapsedTime()
        
        // Then
        // Should be pausedTime (5.0) + time since startTime (~10 seconds)
        XCTAssertEqual(currentTime, 15.0, accuracy: 1.0)
    }
    
    // MARK: - Equatable Tests
    
    func testEquality() {
        // Given
        let id = UUID()
        let createdAt = Date()
        let lastUpdated = Date()
        let stopwatch1 = StopwatchModel(
            id: id,
            elapsedTime: 45.23,
            isRunning: false,
            createdAt: createdAt,
            lastUpdated: lastUpdated
        )
        let stopwatch2 = StopwatchModel(
            id: id,
            elapsedTime: 45.23,
            isRunning: false,
            createdAt: createdAt,
            lastUpdated: lastUpdated
        )
        let stopwatch3 = StopwatchModel(id: UUID(), elapsedTime: 45.23, isRunning: false)
        
        // Then
        XCTAssertEqual(stopwatch1, stopwatch2)
        XCTAssertNotEqual(stopwatch1, stopwatch3)
    }
}

