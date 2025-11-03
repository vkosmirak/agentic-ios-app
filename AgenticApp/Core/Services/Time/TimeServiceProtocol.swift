//
//  TimeServiceProtocol.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Protocol for time and date operations
protocol TimeServiceProtocol {
    /// Returns current date
    var currentDate: Date { get }
    
    /// Formats time for display
    func formattedTime(_ date: Date, timeZone: TimeZone) -> String
    
    /// Calculates time difference between two timezones
    func timeDifference(from sourceTimeZone: TimeZone, to targetTimeZone: TimeZone) -> String
}

