//
//  DateExtensionsTests.swift
//  AgenticAppTests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest
@testable import AgenticApp

final class DateExtensionsTests: XCTestCase {
    
    // MARK: - Test Constants
    private enum TestDates {
        /// Nov 4, 2024 15:00:00 UTC = Nov 4, 2024 11:00:00 AM EST
        static let november2024 = Date(timeIntervalSince1970: 1730736000)
        /// Dec 3, 2024 12:00:00 UTC
        static let december2024 = Date(timeIntervalSince1970: 1733266800)
    }
    
    func testFormattedTime() {
        // Given
        // Use a date that will definitely produce AM/PM for New York timezone
        let date = TestDates.november2024
        let timeZone = TimeZone(identifier: "America/New_York")!
        
        // When
        let formattedTime = date.formattedTime(timeZone: timeZone)
        
        // Then
        XCTAssertFalse(formattedTime.isEmpty)
        // Format should be "h:mm" or "h:mm a" depending on locale
        // Check that it contains a colon (time format)
        XCTAssertTrue(formattedTime.contains(":"), "Formatted time '\(formattedTime)' should contain ':'")
        // Note: AM/PM may not appear depending on locale, so we just verify it's a valid time format
    }
    
    func testFormattedTimeFormat() {
        // Given
        // Use a date that will definitely produce AM/PM for New York timezone
        let date = TestDates.november2024
        let timeZone = TimeZone(identifier: "America/New_York")!
        
        // When
        let formattedTime = date.formattedTime(timeZone: timeZone)
        
        // Then
        // Should match format "h:mm a" (e.g., "12:00 PM")
        // Validate format: should contain colon, have hour and minute components
        let components = formattedTime.split(separator: ":")
        XCTAssertEqual(components.count, 2, "Should have format 'h:mm a'")
        
        // Verify hour component exists and is valid
        let hourComponent = String(components[0])
        XCTAssertFalse(hourComponent.isEmpty, "Hour component should not be empty")
        
        // Verify minute component exists (may include AM/PM)
        let minuteComponent = String(components[1])
        XCTAssertFalse(minuteComponent.isEmpty, "Minute component should not be empty")
        
        // Verify format contains time pattern (colon separator)
        XCTAssertTrue(formattedTime.contains(":"), "Formatted time should contain ':' separator")
        
        // Additional validation: verify format matches expected pattern using regex
        // Pattern accepts: 1-2 digits : 2 digits optional space AM/PM
        let timePattern = #"^\d{1,2}:\d{2}(\s*(AM|PM))?$"#
        let regex = try? NSRegularExpression(pattern: timePattern, options: .caseInsensitive)
        let range = NSRange(formattedTime.startIndex..., in: formattedTime)
        XCTAssertNotNil(regex?.firstMatch(in: formattedTime, range: range),
            "Formatted time '\(formattedTime)' should match pattern 'h:mm a'")
    }
    
    func testFormattedTimeDifferentTimeZones() {
        // Given
        let date = TestDates.november2024
        let timeZone1 = TimeZone(identifier: "America/New_York")!
        let timeZone2 = TimeZone(identifier: "Europe/London")!
        
        // When
        let formattedTime1 = date.formattedTime(timeZone: timeZone1)
        let formattedTime2 = date.formattedTime(timeZone: timeZone2)
        
        // Then
        XCTAssertNotEqual(formattedTime1, formattedTime2, "Different time zones should produce different formatted times")
    }
    
    func testTimeDifferenceSameTimeZone() {
        // Given
        let timeZone = TimeZone(identifier: "America/New_York")!
        
        // When
        let difference = Date.timeDifference(from: timeZone, to: timeZone)
        
        // Then
        XCTAssertEqual(difference, "Same time")
    }
    
    func testTimeDifferenceOneHourAhead() {
        // Given
        // Using UTC and UTC+1 for testing
        let sourceTimeZone = TimeZone(secondsFromGMT: 0)! // UTC
        let targetTimeZone = TimeZone(secondsFromGMT: 3600)! // UTC+1
        
        // When
        let difference = Date.timeDifference(from: sourceTimeZone, to: targetTimeZone)
        
        // Then
        XCTAssertEqual(difference, "1 hour ahead")
    }
    
    func testTimeDifferenceOneHourBehind() {
        // Given
        let sourceTimeZone = TimeZone(secondsFromGMT: 3600)! // UTC+1
        let targetTimeZone = TimeZone(secondsFromGMT: 0)! // UTC
        
        // When
        let difference = Date.timeDifference(from: sourceTimeZone, to: targetTimeZone)
        
        // Then
        XCTAssertEqual(difference, "1 hour behind")
    }
    
    func testTimeDifferenceMultipleHoursAhead() {
        // Given
        let sourceTimeZone = TimeZone(secondsFromGMT: 0)! // UTC
        let targetTimeZone = TimeZone(secondsFromGMT: 10800)! // UTC+3
        
        // When
        let difference = Date.timeDifference(from: sourceTimeZone, to: targetTimeZone)
        
        // Then
        XCTAssertEqual(difference, "3 hours ahead")
    }
    
    func testTimeDifferenceMultipleHoursBehind() {
        // Given
        let sourceTimeZone = TimeZone(secondsFromGMT: 10800)! // UTC+3
        let targetTimeZone = TimeZone(secondsFromGMT: 0)! // UTC
        
        // When
        let difference = Date.timeDifference(from: sourceTimeZone, to: targetTimeZone)
        
        // Then
        XCTAssertEqual(difference, "3 hours behind")
    }
    
    func testTimeDifferenceRealWorldExample() {
        // Given
        // Los Angeles (PST/PDT) to New York (EST/EDT)
        // Typical difference is 3 hours
        let losAngeles = TimeZone(identifier: "America/Los_Angeles")!
        let newYork = TimeZone(identifier: "America/New_York")!
        
        // When
        let difference = Date.timeDifference(from: losAngeles, to: newYork)
        
        // Then
        XCTAssertFalse(difference.isEmpty)
        XCTAssertTrue(difference.contains("hour") || difference.contains("hours"))
        XCTAssertTrue(difference.contains("ahead"))
    }
    
    func testTimeDifferenceEuropeToAsia() {
        // Given
        let london = TimeZone(identifier: "Europe/London")!
        let tokyo = TimeZone(identifier: "Asia/Tokyo")!
        
        // When
        let difference = Date.timeDifference(from: london, to: tokyo)
        
        // Then
        XCTAssertFalse(difference.isEmpty)
        XCTAssertTrue(difference.contains("hour") || difference.contains("hours"))
        XCTAssertTrue(difference.contains("ahead"))
    }
}

