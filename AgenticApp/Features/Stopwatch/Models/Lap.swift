//
//  Lap.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Model representing a lap time in the stopwatch
struct Lap: Identifiable, Equatable {
    let id: UUID
    let lapNumber: Int
    let time: TimeInterval // Total elapsed time when lap was recorded
    let lapTime: TimeInterval // Time for this specific lap
    
    init(
        id: UUID = UUID(),
        lapNumber: Int,
        time: TimeInterval,
        lapTime: TimeInterval
    ) {
        self.id = id
        self.lapNumber = lapNumber
        self.time = time
        self.lapTime = lapTime
    }
    
    /// Formatted total time (MM:SS,HH format)
    var formattedTime: String {
        time.formattedStopwatchTime()
    }
    
    /// Formatted lap time (MM:SS,HH format)
    var formattedLapTime: String {
        lapTime.formattedStopwatchTime()
    }
}

