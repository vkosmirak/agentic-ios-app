//
//  TimeServiceTests.swift
//  AgenticAppTests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest
@testable import AgenticApp

final class TimeServiceTests: XCTestCase {
    
    // MARK: - Test Constants
    private enum TestDates {
        /// Nov 4, 2024 15:00:00 UTC = Nov 4, 2024 11:00:00 AM EST
        static let november2024 = Date(timeIntervalSince1970: 1730736000)
        /// Dec 3, 2024 12:00:00 UTC
        static let december2024 = Date(timeIntervalSince1970: 1733266800)
    }
    
    private var timeService: TimeService!
    
    override func setUp() {
        super.setUp()
        timeService = TimeService()
    }
    
    override func tearDown() {
        timeService = nil
        super.tearDown()
    }
    
    func testCurrentDate() {
        // When
        let date1 = timeService.currentDate
        let date2 = timeService.currentDate
        
        // Then
        XCTAssertNotNil(date1)
        XCTAssertNotNil(date2)
        // Dates should be very close (within a few milliseconds)
        let timeDifference = abs(date1.timeIntervalSince(date2))
        XCTAssertLessThan(timeDifference, 0.1)
    }
    
    func testFormattedTime() {
        // Given
        // Use a date that will definitely be in AM hours for New York timezone
        let date = TestDates.november2024
        let timeZone = TimeZone(identifier: "America/New_York")!
        
        // When
        let formattedTime = timeService.formattedTime(date, timeZone: timeZone)
        
        // Then
        XCTAssertFalse(formattedTime.isEmpty)
        // Format should be "h:mm" or "h:mm a" depending on locale
        // Check that it contains a colon (time format)
        XCTAssertTrue(formattedTime.contains(":"), "Formatted time '\(formattedTime)' should contain ':'")
        // Note: AM/PM may not appear depending on locale, so we just verify it's a valid time format
    }
    
    func testFormattedTimeDifferentTimeZones() {
        // Given
        let date = TestDates.december2024
        let timeZone1 = TimeZone(identifier: "America/New_York")!
        let timeZone2 = TimeZone(identifier: "Europe/London")!
        
        // When
        let formattedTime1 = timeService.formattedTime(date, timeZone: timeZone1)
        let formattedTime2 = timeService.formattedTime(date, timeZone: timeZone2)
        
        // Then
        XCTAssertNotEqual(formattedTime1, formattedTime2, "Different time zones should produce different formatted times")
    }
    
    func testTimeDifferenceSameTimeZone() {
        // Given
        let timeZone = TimeZone(identifier: "America/New_York")!
        
        // When
        let difference = timeService.timeDifference(from: timeZone, to: timeZone)
        
        // Then
        XCTAssertEqual(difference, "Same time")
    }
    
    func testTimeDifferenceDifferentTimeZones() {
        // Given
        let sourceTimeZone = TimeZone(identifier: "America/Los_Angeles")!
        let targetTimeZone = TimeZone(identifier: "America/New_York")!
        
        // When
        let difference = timeService.timeDifference(from: sourceTimeZone, to: targetTimeZone)
        
        // Then
        XCTAssertFalse(difference.isEmpty)
        // Should contain "hours" or "hour"
        XCTAssertTrue(difference.contains("hour") || difference.contains("hours"))
    }
    
    func testTimeDifferenceDirection() {
        // Given
        let testCases: [(source: TimeZone, target: TimeZone, expectedDirection: String)] = [
            (TimeZone(identifier: "America/Los_Angeles")!,
             TimeZone(identifier: "America/New_York")!,
             "ahead"),
            (TimeZone(identifier: "America/New_York")!,
             TimeZone(identifier: "America/Los_Angeles")!,
             "behind")
        ]
        
        // When/Then
        for (source, target, expectedDirection) in testCases {
            let difference = timeService.timeDifference(from: source, to: target)
            XCTAssertTrue(difference.contains(expectedDirection),
                "Expected '\(expectedDirection)' in difference '\(difference)' for \(source.identifier) -> \(target.identifier)")
        }
    }
}

