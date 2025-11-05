//
//  TimeServiceMock.swift
//  AgenticAppTests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation
@testable import AgenticApp

final class TimeServiceMock: TimeServiceProtocol {
    var currentDate: Date = Date()
    var formattedTimeResult: String = "12:00 AM"
    var timeDifferenceResult: String = "Same time"
    
    var lastFormattedDate: Date?
    var lastFormattedTimeZone: TimeZone?
    var lastDifferenceSource: TimeZone?
    var lastDifferenceTarget: TimeZone?
    
    func formattedTime(_ date: Date, timeZone: TimeZone) -> String {
        lastFormattedDate = date
        lastFormattedTimeZone = timeZone
        return formattedTimeResult
    }
    
    func timeDifference(from sourceTimeZone: TimeZone, to targetTimeZone: TimeZone) -> String {
        lastDifferenceSource = sourceTimeZone
        lastDifferenceTarget = targetTimeZone
        return timeDifferenceResult
    }
}

