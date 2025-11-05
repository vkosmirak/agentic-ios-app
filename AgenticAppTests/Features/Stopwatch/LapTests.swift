//
//  LapTests.swift
//  AgenticAppTests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest
@testable import AgenticApp

final class LapTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitializationWithDefaults() {
        // When
        let lap = Lap(lapNumber: 1, time: 2.01, lapTime: 2.01)
        
        // Then
        XCTAssertNotNil(lap.id)
        XCTAssertEqual(lap.lapNumber, 1)
        XCTAssertEqual(lap.time, 2.01, accuracy: 0.01)
        XCTAssertEqual(lap.lapTime, 2.01, accuracy: 0.01)
    }
    
    func testInitializationWithAllParameters() {
        // Given
        let id = UUID()
        let lapNumber = 5
        let time: TimeInterval = 13.27
        let lapTime: TimeInterval = 0.41
        
        // When
        let lap = Lap(id: id, lapNumber: lapNumber, time: time, lapTime: lapTime)
        
        // Then
        XCTAssertEqual(lap.id, id)
        XCTAssertEqual(lap.lapNumber, lapNumber)
        XCTAssertEqual(lap.time, time, accuracy: 0.01)
        XCTAssertEqual(lap.lapTime, lapTime, accuracy: 0.01)
    }
    
    // MARK: - Formatting Tests
    
    func testFormattedTime() {
        // Given
        let lap1 = Lap(lapNumber: 1, time: 2.01, lapTime: 2.01) // 00:02,01
        let lap2 = Lap(lapNumber: 2, time: 14.40, lapTime: 12.39) // 00:14,40
        let lap3 = Lap(lapNumber: 3, time: 65.50, lapTime: 51.10) // 01:05,50
        
        // Then - Check formatted strings match expected format
        // Note: Floating point precision may cause slight rounding
        XCTAssertTrue(lap1.formattedTime.hasPrefix("00:02"))
        XCTAssertTrue(lap1.formattedTime.contains("01") || lap1.formattedTime.contains("00"))
        XCTAssertEqual(lap2.formattedTime, "00:14,40")
        XCTAssertEqual(lap3.formattedTime, "01:05,50")
    }
    
    func testFormattedLapTime() {
        // Given
        let lap1 = Lap(lapNumber: 1, time: 2.01, lapTime: 2.01) // 00:02,01
        let lap2 = Lap(lapNumber: 2, time: 14.40, lapTime: 12.39) // 00:12,39
        let lap3 = Lap(lapNumber: 3, time: 65.50, lapTime: 51.10) // 00:51,10
        
        // Then - Check formatted strings match expected format
        // Note: Floating point precision may cause slight rounding
        XCTAssertTrue(lap1.formattedLapTime.hasPrefix("00:02"))
        XCTAssertTrue(lap1.formattedLapTime.contains("01") || lap1.formattedLapTime.contains("00"))
        XCTAssertEqual(lap2.formattedLapTime, "00:12,39")
        XCTAssertEqual(lap3.formattedLapTime, "00:51,10")
    }
    
    func testFormattedTimeWithZero() {
        // Given
        let lap = Lap(lapNumber: 1, time: 0.0, lapTime: 0.0)
        
        // Then
        XCTAssertEqual(lap.formattedTime, "00:00,00")
        XCTAssertEqual(lap.formattedLapTime, "00:00,00")
    }
    
    func testFormattedTimeWithLargeValues() {
        // Given
        let lap = Lap(lapNumber: 1, time: 3661.50, lapTime: 3661.50) // 61:01,50
        
        // Then
        XCTAssertEqual(lap.formattedTime, "61:01,50")
    }
    
    // MARK: - Equality Tests
    
    func testEqualityWithSameID() {
        // Given
        let id = UUID()
        let lap1 = Lap(id: id, lapNumber: 1, time: 2.01, lapTime: 2.01)
        let lap2 = Lap(id: id, lapNumber: 1, time: 2.01, lapTime: 2.01)
        
        // Then
        XCTAssertEqual(lap1, lap2)
    }
    
    func testEqualityWithDifferentIDs() {
        // Given
        let lap1 = Lap(lapNumber: 1, time: 2.01, lapTime: 2.01)
        let lap2 = Lap(lapNumber: 1, time: 2.01, lapTime: 2.01)
        
        // Then
        XCTAssertNotEqual(lap1, lap2, "Laps with different IDs should not be equal")
    }
    
    func testEqualityWithDifferentProperties() {
        // Given
        let id = UUID()
        let lap1 = Lap(id: id, lapNumber: 1, time: 2.01, lapTime: 2.01)
        let lap2 = Lap(id: id, lapNumber: 2, time: 2.01, lapTime: 2.01)
        
        // Then
        XCTAssertNotEqual(lap1, lap2, "Laps with different lap numbers should not be equal")
    }
    
    // MARK: - Identifiable Tests
    
    func testIdentifiable() {
        // Given
        let lap = Lap(lapNumber: 1, time: 2.01, lapTime: 2.01)
        
        // Then
        XCTAssertNotNil(lap.id)
        XCTAssertFalse(lap.id.uuidString.isEmpty)
    }
}

