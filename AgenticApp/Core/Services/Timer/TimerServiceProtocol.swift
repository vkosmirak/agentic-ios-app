//
//  TimerServiceProtocol.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Protocol for timer management service
protocol TimerServiceProtocol {
    /// Loads all timers from persistent storage
    func loadTimers() -> [TimerModel]
    
    /// Saves all timers to persistent storage
    func saveTimers(_ timers: [TimerModel])
    
    /// Adds a new timer
    func addTimer(_ timer: TimerModel)
    
    /// Updates an existing timer
    func updateTimer(_ timer: TimerModel)
    
    /// Deletes a timer by ID
    func deleteTimer(id: UUID)
    
    /// Gets a timer by ID
    func getTimer(id: UUID) -> TimerModel?
}



