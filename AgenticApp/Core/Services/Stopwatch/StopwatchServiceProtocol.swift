//
//  StopwatchServiceProtocol.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Protocol for stopwatch management service
protocol StopwatchServiceProtocol {
    /// Loads the stopwatch state from persistent storage
    func loadStopwatch() -> StopwatchModel
    
    /// Saves the stopwatch state to persistent storage
    func saveStopwatch(_ stopwatch: StopwatchModel)
    
    /// Resets the stopwatch state
    func resetStopwatch()
}

