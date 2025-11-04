//
//  LapModelTests.swift
//  AgenticAppTests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest
@testable import AgenticApp

final class LapModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitializationWithDefaults() {
        // When
        let lap = LapModel(lapNumber: 1, lapTime: 45.23, totalTime: 45.23)
        
        // Then
        XCTAssertNotNil(lap.id)
        XCTAssertEqual(lap.lapNumber, 1)
        XCTAssertEqual(lap.lapTime, 45.23, accuracy: 0.01)
        XCTAssertEqual(lap.totalTime, 45.23, accuracy: 0.01)
    }
    
    func testInitializationWithAllParameters() {
        // Given
        let id = UUID()
        let lapNumber = 5
        let lapTime: TimeInterval = 52.67
        let totalTime: TimeInterval = 250.89
        
        // When
        let lap = LapModel(id: id, lapNumber: lapNumber, lapTime: lapTime, totalTime: totalTime)
        
        // Then
        XCTAssertEqual(lap.id, id)
        XCTAssertEqual(lap.lapNumber, lapNumber)
        XCTAssertEqual(lap.lapTime, lapTime, accuracy: 0.01)
        XCTAssertEqual(lap.totalTime, totalTime, accuracy: 0.01)
    }
    
    // MARK: - Formatting Tests
    
    func testFormattedLapTime() {
        // Given
        let lap1 = LapModel(lapNumber: 1, lapTime: 45.23, totalTime: 45.23)
        let lap2 = LapModel(lapNumber: 2, lapTime: 125.67, totalTime: 170.90)
        
        // Then
        XCTAssertEqual(lap1.formattedLapTime, "0:45.23")
        XCTAssertEqual(lap2.formattedLapTime, "2:05.67")
    }
    
    func testFormattedTotalTime() {
        // Given
        let lap1 = LapModel(lapNumber: 1, lapTime: 45.23, totalTime: 45.23)
        let lap2 = LapModel(lapNumber: 2, lapTime: 52.67, totalTime: 97.90)
        
        // Then
        XCTAssertEqual(lap1.formattedTotalTime, "0:45.23")
        XCTAssertEqual(lap2.formattedTotalTime, "1:37.90")
    }
    
    // MARK: - Equatable Tests
    
    func testEquality() {
        // Given
        let id = UUID()
        let lap1 = LapModel(id: id, lapNumber: 1, lapTime: 45.23, totalTime: 45.23)
        let lap2 = LapModel(id: id, lapNumber: 1, lapTime: 45.23, totalTime: 45.23)
        let lap3 = LapModel(id: UUID(), lapNumber: 1, lapTime: 45.23, totalTime: 45.23)
        
        // Then
        XCTAssertEqual(lap1, lap2)
        XCTAssertNotEqual(lap1, lap3)
    }
}

