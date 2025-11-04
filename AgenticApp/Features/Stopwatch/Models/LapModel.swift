//
//  LapModel.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Model representing a lap time in a stopwatch
struct LapModel: Identifiable, Codable, Equatable {
    let id: UUID
    let lapNumber: Int
    let lapTime: TimeInterval // Time for this lap
    let totalTime: TimeInterval // Total elapsed time when this lap was recorded
    
    init(
        id: UUID = UUID(),
        lapNumber: Int,
        lapTime: TimeInterval,
        totalTime: TimeInterval
    ) {
        self.id = id
        self.lapNumber = lapNumber
        self.lapTime = lapTime
        self.totalTime = totalTime
    }
    
    /// Formatted lap time string (e.g., "1:23.45")
    var formattedLapTime: String {
        formatTimeInterval(lapTime)
    }
    
    /// Formatted total time string (e.g., "5:23.45")
    var formattedTotalTime: String {
        formatTimeInterval(totalTime)
    }
    
    /// Helper to format time interval as MM:SS.mm
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        let milliseconds = Int(round((interval.truncatingRemainder(dividingBy: 1)) * 100))
        
        return String(format: "%d:%02d.%02d", minutes, seconds, milliseconds)
    }
}

