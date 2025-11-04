//
//  TimerModelTests.swift
//  AgenticAppTests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest
@testable import AgenticApp

final class TimerModelTests: XCTestCase {
    
    // MARK: - Initialization Tests
    
    func testInitializationWithDefaults() {
        // When
        let timer = TimerModel(duration: 300)
        
        // Then
        XCTAssertNotNil(timer.id)
        XCTAssertEqual(timer.duration, 300)
        XCTAssertNil(timer.label)
        XCTAssertEqual(timer.sound, "Radar")
        XCTAssertFalse(timer.isRunning)
        XCTAssertEqual(timer.remainingTime, 300)
        XCTAssertNil(timer.endTime)
        XCTAssertNotNil(timer.createdAt)
    }
    
    func testInitializationWithAllParameters() {
        // Given
        let id = UUID()
        let duration: TimeInterval = 600
        let label = "Coffee Timer"
        let sound = "Alarm"
        let isRunning = true
        let remainingTime: TimeInterval = 245
        let endTime = Date().addingTimeInterval(245)
        let createdAt = Date().addingTimeInterval(-100)
        
        // When
        let timer = TimerModel(
            id: id,
            duration: duration,
            label: label,
            sound: sound,
            isRunning: isRunning,
            remainingTime: remainingTime,
            endTime: endTime,
            createdAt: createdAt
        )
        
        // Then
        XCTAssertEqual(timer.id, id)
        XCTAssertEqual(timer.duration, duration)
        XCTAssertEqual(timer.label, label)
        XCTAssertEqual(timer.sound, sound)
        XCTAssertTrue(timer.isRunning)
        XCTAssertEqual(timer.remainingTime, remainingTime)
        if let timerEndTime = timer.endTime {
            XCTAssertEqual(timerEndTime.timeIntervalSince1970, endTime.timeIntervalSince1970, accuracy: 0.1)
        }
        XCTAssertEqual(timer.createdAt.timeIntervalSince1970, createdAt.timeIntervalSince1970, accuracy: 0.1)
    }
    
    func testInitializationWithNilRemainingTimeDefaultsToDuration() {
        // When
        let timer = TimerModel(duration: 180, remainingTime: nil)
        
        // Then
        XCTAssertEqual(timer.remainingTime, 180)
    }
    
    func testDefaultTimer() {
        // When
        let defaultTimer = TimerModel.default
        
        // Then
        XCTAssertEqual(defaultTimer.duration, 300)
        XCTAssertNil(defaultTimer.label)
        XCTAssertEqual(defaultTimer.sound, "Radar")
        XCTAssertFalse(defaultTimer.isRunning)
        XCTAssertEqual(defaultTimer.remainingTime, 300)
        XCTAssertNil(defaultTimer.endTime)
    }
    
    // MARK: - Formatting Tests
    
    func testFormattedDuration() {
        // Given
        let timer1 = TimerModel(duration: 3661) // 1 hour, 1 minute, 1 second
        let timer2 = TimerModel(duration: 125) // 2 minutes, 5 seconds
        let timer3 = TimerModel(duration: 45) // 45 seconds
        
        // Then
        XCTAssertEqual(timer1.formattedDuration, "1:01:01")
        XCTAssertEqual(timer2.formattedDuration, "2:05")
        XCTAssertEqual(timer3.formattedDuration, "0:45")
    }
    
    func testFormattedRemainingTime() {
        // Given
        let timer1 = TimerModel(duration: 3661, remainingTime: 1800) // 30 minutes remaining
        let timer2 = TimerModel(duration: 125, remainingTime: 45) // 45 seconds remaining
        
        // Then
        XCTAssertEqual(timer1.formattedRemainingTime, "30:00") // 30 minutes = 1800 seconds
        XCTAssertEqual(timer2.formattedRemainingTime, "0:45")
    }
    
    func testFormattedDurationComponents() {
        // Given
        let timer1 = TimerModel(duration: 3661) // 1 hour, 1 minute, 1 second
        let timer2 = TimerModel(duration: 125) // 2 minutes, 5 seconds
        let timer3 = TimerModel(duration: 45) // 45 seconds
        let timer4 = TimerModel(duration: 7200) // 2 hours
        
        // Then
        XCTAssertTrue(timer1.formattedDurationComponents.contains("1 hr"))
        XCTAssertTrue(timer1.formattedDurationComponents.contains("1 min"))
        XCTAssertTrue(timer1.formattedDurationComponents.contains("1 sec"))
        
        XCTAssertTrue(timer2.formattedDurationComponents.contains("2 min"))
        XCTAssertTrue(timer2.formattedDurationComponents.contains("5 sec"))
        
        XCTAssertTrue(timer3.formattedDurationComponents.contains("45 sec"))
        
        XCTAssertTrue(timer4.formattedDurationComponents.contains("2 hr"))
        XCTAssertFalse(timer4.formattedDurationComponents.contains("min"))
        XCTAssertFalse(timer4.formattedDurationComponents.contains("sec"))
    }
    
    // MARK: - Equality Tests
    
    func testEqualityWithSameID() {
        // Given
        let id = UUID()
        let createdAt = Date()
        let timer1 = TimerModel(id: id, duration: 300, label: "Test", createdAt: createdAt)
        let timer2 = TimerModel(id: id, duration: 300, label: "Test", createdAt: createdAt)
        
        // Then
        XCTAssertEqual(timer1, timer2)
    }
    
    func testEqualityWithDifferentIDs() {
        // Given
        let timer1 = TimerModel(duration: 300, label: "Test")
        let timer2 = TimerModel(duration: 300, label: "Test")
        
        // Then
        XCTAssertNotEqual(timer1, timer2, "Timers with different IDs should not be equal")
    }
    
    func testEqualityWithDifferentProperties() {
        // Given
        let id = UUID()
        let timer1 = TimerModel(id: id, duration: 300, label: "Test")
        let timer2 = TimerModel(id: id, duration: 600, label: "Test")
        
        // Then
        XCTAssertNotEqual(timer1, timer2, "Timers with different durations should not be equal")
    }
    
    func testContentMatches() {
        // Given
        let timer1 = TimerModel(duration: 300, label: "Coffee", sound: "Radar")
        let timer2 = TimerModel(duration: 300, label: "Coffee", sound: "Radar")
        let timer3 = TimerModel(duration: 600, label: "Coffee", sound: "Radar")
        
        // Then
        XCTAssertTrue(timer1.contentMatches(timer2), "Content should match regardless of ID")
        XCTAssertFalse(timer1.contentMatches(timer3), "Different duration should not match")
    }
    
    func testMatchesDefault() {
        // Given
        let defaultTimer = TimerModel.default
        let nonDefaultTimer = TimerModel(duration: 600, label: "Coffee")
        
        // Then
        XCTAssertTrue(defaultTimer.matchesDefault())
        XCTAssertFalse(nonDefaultTimer.matchesDefault())
    }
    
    // MARK: - Codable Tests
    
    func testEncodingAndDecoding() throws {
        // Given
        let timer = TimerModel(
            id: UUID(),
            duration: 600,
            label: "Coffee Timer",
            sound: "Alarm",
            isRunning: true,
            remainingTime: 245,
            endTime: Date(),
            createdAt: Date()
        )
        
        // When
        let encoder = JSONEncoder()
        let data = try encoder.encode(timer)
        
        let decoder = JSONDecoder()
        let decodedTimer = try decoder.decode(TimerModel.self, from: data)
        
        // Then
        XCTAssertEqual(decodedTimer.id, timer.id)
        XCTAssertEqual(decodedTimer.duration, timer.duration)
        XCTAssertEqual(decodedTimer.label, timer.label)
        XCTAssertEqual(decodedTimer.sound, timer.sound)
        XCTAssertEqual(decodedTimer.isRunning, timer.isRunning)
        XCTAssertEqual(decodedTimer.remainingTime, timer.remainingTime)
        if let endTime = decodedTimer.endTime, let originalEndTime = timer.endTime {
            XCTAssertEqual(endTime.timeIntervalSince1970, originalEndTime.timeIntervalSince1970, accuracy: 0.1)
        }
        XCTAssertEqual(decodedTimer.createdAt.timeIntervalSince1970, timer.createdAt.timeIntervalSince1970, accuracy: 0.1)
    }
    
    func testDecodingWithMissingOptionalFields() throws {
        // Given
        let json = """
        {
            "id": "\(UUID().uuidString)",
            "duration": 300,
            "isRunning": false
        }
        """.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        let timer = try decoder.decode(TimerModel.self, from: json)
        
        // Then
        XCTAssertNil(timer.label)
        XCTAssertEqual(timer.sound, "Radar")
        XCTAssertEqual(timer.remainingTime, 300)
        XCTAssertNil(timer.endTime)
        XCTAssertNotNil(timer.createdAt)
    }
    
    func testDecodingWithNilRemainingTimeDefaultsToDuration() throws {
        // Given
        let id = UUID()
        let json = """
        {
            "id": "\(id.uuidString)",
            "duration": 600,
            "isRunning": false
        }
        """.data(using: .utf8)!
        
        // When
        let decoder = JSONDecoder()
        let timer = try decoder.decode(TimerModel.self, from: json)
        
        // Then
        XCTAssertEqual(timer.remainingTime, 600)
    }
    
    // MARK: - Identifiable Tests
    
    func testIdentifiable() {
        // Given
        let timer = TimerModel(duration: 300)
        
        // Then
        XCTAssertNotNil(timer.id)
        XCTAssertFalse(timer.id.uuidString.isEmpty)
    }
}

