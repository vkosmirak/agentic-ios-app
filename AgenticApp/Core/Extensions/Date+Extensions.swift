//
//  Date+Extensions.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

extension Date {
    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }()
    
    /// Formats time for display (e.g., "12:34 PM")
    func formattedTime(timeZone: TimeZone) -> String {
        Self.timeFormatter.timeZone = timeZone
        return Self.timeFormatter.string(from: self)
    }
    
    /// Formats time difference between two timezones
    static func timeDifference(from sourceTimeZone: TimeZone, to targetTimeZone: TimeZone) -> String {
        let now = Date()
        let sourceOffset = sourceTimeZone.secondsFromGMT(for: now)
        let targetOffset = targetTimeZone.secondsFromGMT(for: now)
        let diffSeconds = targetOffset - sourceOffset
        let hours = diffSeconds / 3600
        
        if hours == 0 {
            return "Same time"
        } else if abs(hours) == 1 {
            return hours > 0 ? "1 hour ahead" : "1 hour behind"
        } else {
            return hours > 0 ? "\(hours) hours ahead" : "\(abs(hours)) hours behind"
        }
    }
}

