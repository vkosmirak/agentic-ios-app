//
//  AlarmServiceProtocol.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Protocol for alarm management service
protocol AlarmServiceProtocol {
    /// Loads all alarms from persistent storage
    func loadAlarms() -> [AlarmModel]
    
    /// Saves all alarms to persistent storage
    func saveAlarms(_ alarms: [AlarmModel])
    
    /// Adds a new alarm
    func addAlarm(_ alarm: AlarmModel)
    
    /// Updates an existing alarm
    func updateAlarm(_ alarm: AlarmModel)
    
    /// Deletes an alarm by ID
    func deleteAlarm(id: UUID)
    
    /// Gets an alarm by ID
    func getAlarm(id: UUID) -> AlarmModel?
}







