//
//  StopwatchModel.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Model representing stopwatch state
struct StopwatchModel {
    var elapsedTime: TimeInterval // Total elapsed time
    var laps: [Lap] // Recorded laps
    var isRunning: Bool // Whether stopwatch is currently running
    var startTime: Date? // When the stopwatch started (if running)
    var pausedTime: TimeInterval // Accumulated time when paused
    
    init(
        elapsedTime: TimeInterval = 0,
        laps: [Lap] = [],
        isRunning: Bool = false,
        startTime: Date? = nil,
        pausedTime: TimeInterval = 0
    ) {
        self.elapsedTime = elapsedTime
        self.laps = laps
        self.isRunning = isRunning
        self.startTime = startTime
        self.pausedTime = pausedTime
    }
    
    /// Formatted elapsed time (MM:SS,HH format)
    var formattedTime: String {
        elapsedTime.formattedStopwatchTime()
    }
}

