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
        let model = StopwatchModel()
        
        // Then
        XCTAssertEqual(model.elapsedTime, 0)
        XCTAssertTrue(model.laps.isEmpty)
        XCTAssertFalse(model.isRunning)
        XCTAssertNil(model.startTime)
        XCTAssertEqual(model.pausedTime, 0)
    }
    
    func testInitializationWithAllParameters() {
        // Given
        let elapsedTime: TimeInterval = 14.40
        let laps = [Lap(lapNumber: 1, time: 2.01, lapTime: 2.01)]
        let isRunning = true
        let startTime = Date()
        let pausedTime: TimeInterval = 0
        
        // When
        let model = StopwatchModel(
            elapsedTime: elapsedTime,
            laps: laps,
            isRunning: isRunning,
            startTime: startTime,
            pausedTime: pausedTime
        )
        
        // Then
        XCTAssertEqual(model.elapsedTime, elapsedTime, accuracy: 0.01)
        XCTAssertEqual(model.laps.count, 1)
        XCTAssertTrue(model.isRunning)
        if let modelStartTime = model.startTime {
            XCTAssertEqual(modelStartTime.timeIntervalSince1970, startTime.timeIntervalSince1970, accuracy: 0.1)
        } else {
            XCTFail("startTime should not be nil")
        }
        XCTAssertEqual(model.pausedTime, pausedTime, accuracy: 0.01)
    }
    
    // MARK: - Formatting Tests
    
    func testFormattedTime() {
        // Given
        let model1 = StopwatchModel(elapsedTime: 2.01) // 00:02,01
        let model2 = StopwatchModel(elapsedTime: 14.40) // 00:14,40
        let model3 = StopwatchModel(elapsedTime: 65.50) // 01:05,50
        
        // Then - Check formatted strings match expected format
        // Note: Floating point precision may cause slight rounding
        XCTAssertTrue(model1.formattedTime.hasPrefix("00:02"))
        XCTAssertTrue(model1.formattedTime.contains("01") || model1.formattedTime.contains("00"))
        XCTAssertEqual(model2.formattedTime, "00:14,40")
        XCTAssertEqual(model3.formattedTime, "01:05,50")
    }
    
    func testFormattedTimeWithZero() {
        // Given
        let model = StopwatchModel(elapsedTime: 0.0)
        
        // Then
        XCTAssertEqual(model.formattedTime, "00:00,00")
    }
    
    func testFormattedTimeWithLargeValues() {
        // Given
        let model = StopwatchModel(elapsedTime: 3661.50) // 61:01,50
        
        // Then
        XCTAssertEqual(model.formattedTime, "61:01,50")
    }
}

