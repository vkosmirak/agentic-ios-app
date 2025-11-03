//
//  ClockModelTests.swift
//  AgenticAppTests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest
@testable import AgenticApp

@MainActor
final class ClockModelTests: XCTestCase {
    
    func testInitializationWithTimeZoneIdentifier() {
        // Given
        let identifier = "America/New_York"
        let cityName = "New York"
        
        // When
        let clock = ClockModel(cityName: cityName, timeZoneIdentifier: identifier)
        
        // Then
        XCTAssertEqual(clock.cityName, cityName)
        XCTAssertNotNil(clock.timeZone)
        XCTAssertEqual(clock.timeZone.identifier, identifier)
    }
    
    func testInitializationWithInvalidTimeZoneIdentifier() {
        // Given
        let invalidIdentifier = "Invalid/TimeZone"
        let cityName = "Unknown City"
        
        // When
        let clock = ClockModel(cityName: cityName, timeZoneIdentifier: invalidIdentifier)
        
        // Then
        XCTAssertEqual(clock.cityName, cityName)
        // Should fall back to current timezone
        XCTAssertEqual(clock.timeZone, TimeZone.current)
    }
    
    func testInitializationWithTimeZone() {
        // Given
        let timeZone = TimeZone(identifier: "Europe/London")!
        let cityName = "London"
        
        // When
        let clock = ClockModel(cityName: cityName, timeZone: timeZone)
        
        // Then
        XCTAssertEqual(clock.cityName, cityName)
        XCTAssertEqual(clock.timeZone, timeZone)
    }
    
    func testInitializationWithCustomID() {
        // Given
        let customID = UUID()
        let cityName = "Tokyo"
        let timeZone = TimeZone(identifier: "Asia/Tokyo")!
        
        // When
        let clock = ClockModel(id: customID, cityName: cityName, timeZone: timeZone)
        
        // Then
        XCTAssertEqual(clock.id, customID)
        XCTAssertEqual(clock.cityName, cityName)
        XCTAssertEqual(clock.timeZone, timeZone)
    }
    
    func testDefaultClocks() {
        // When
        let defaultClocks = ClockModel.defaultClocks
        
        // Then
        XCTAssertEqual(defaultClocks.count, 5)
        XCTAssertTrue(defaultClocks.contains { $0.cityName == "Cupertino" })
        XCTAssertTrue(defaultClocks.contains { $0.cityName == "New York" })
        XCTAssertTrue(defaultClocks.contains { $0.cityName == "London" })
        XCTAssertTrue(defaultClocks.contains { $0.cityName == "Tokyo" })
        XCTAssertTrue(defaultClocks.contains { $0.cityName == "Sydney" })
    }
    
    func testDefaultClocksHaveValidTimeZones() {
        // When
        let defaultClocks = ClockModel.defaultClocks
        
        // Then
        for clock in defaultClocks {
            XCTAssertNotNil(clock.timeZone)
            XCTAssertNotEqual(clock.timeZone.identifier, "")
        }
    }
    
    func testEquality() {
        // Given
        let id = UUID()
        let timeZone = TimeZone(identifier: "America/New_York")!
        
        // When
        let clock1 = ClockModel(id: id, cityName: "New York", timeZone: timeZone)
        let clock2 = ClockModel(id: id, cityName: "New York", timeZone: timeZone)
        let clock3 = ClockModel(cityName: "New York", timeZone: timeZone)
        
        // Then
        XCTAssertEqual(clock1, clock2, "Clocks with same ID should be equal")
        // Different IDs means different instances
        XCTAssertNotEqual(clock1.id, clock3.id, "Clocks with different IDs should have different IDs")
        XCTAssertNotEqual(clock1, clock3, "Clocks with different IDs should not be equal")
    }
    
    func testIdentifiable() {
        // Given
        let clock = ClockModel(cityName: "London", timeZoneIdentifier: "Europe/London")
        
        // Then
        XCTAssertNotNil(clock.id)
        // Verify it's a UUID by checking it's not empty
        XCTAssertFalse(clock.id.uuidString.isEmpty)
    }
}

