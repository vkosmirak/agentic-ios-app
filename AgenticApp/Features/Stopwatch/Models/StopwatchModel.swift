//
//  StopwatchModel.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Model representing stopwatch state
struct StopwatchModel: Identifiable, Codable, Equatable {
    let id: UUID
    var elapsedTime: TimeInterval // Total elapsed time in seconds
    var isRunning: Bool
    var startTime: Date? // When the stopwatch was started (for running state)
    var pausedTime: TimeInterval // Accumulated time when paused
    var laps: [LapModel] // List of lap times
    var createdAt: Date
    var lastUpdated: Date
    
    init(
        id: UUID = UUID(),
        elapsedTime: TimeInterval = 0,
        isRunning: Bool = false,
        startTime: Date? = nil,
        pausedTime: TimeInterval = 0,
        laps: [LapModel] = [],
        createdAt: Date = Date(),
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.elapsedTime = elapsedTime
        self.isRunning = isRunning
        self.startTime = startTime
        self.pausedTime = pausedTime
        self.laps = laps
        self.createdAt = createdAt
        self.lastUpdated = lastUpdated
    }
    
    /// Formatted elapsed time string (e.g., "1:23.45")
    var formattedElapsedTime: String {
        formatTimeInterval(elapsedTime)
    }
    
    /// Helper to format time interval as MM:SS.mm
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        let milliseconds = Int(round((interval.truncatingRemainder(dividingBy: 1)) * 100))
        
        return String(format: "%d:%02d.%02d", minutes, seconds, milliseconds)
    }
    
    /// Gets the current elapsed time including running time
    func currentElapsedTime(now: Date = Date()) -> TimeInterval {
        if isRunning, let startTime = startTime {
            return pausedTime + now.timeIntervalSince(startTime)
        }
        return elapsedTime
    }
}

