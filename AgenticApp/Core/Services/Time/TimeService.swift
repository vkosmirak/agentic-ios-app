//
//  TimeService.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Service for time and date operations
final class TimeService: TimeServiceProtocol {
    var currentDate: Date {
        Date()
    }
    
    func formattedTime(_ date: Date, timeZone: TimeZone) -> String {
        date.formattedTime(timeZone: timeZone)
    }
    
    func timeDifference(from sourceTimeZone: TimeZone, to targetTimeZone: TimeZone) -> String {
        Date.timeDifference(from: sourceTimeZone, to: targetTimeZone)
    }
}

