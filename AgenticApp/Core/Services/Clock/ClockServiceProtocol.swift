//
//  ClockServiceProtocol.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Protocol for clock management service
protocol ClockServiceProtocol {
    /// Loads all clocks from persistent storage
    func loadClocks() -> [ClockModel]
    
    /// Saves all clocks to persistent storage
    func saveClocks(_ clocks: [ClockModel]) throws
    
    /// Adds a new clock
    func addClock(_ clock: ClockModel) throws
    
    /// Deletes a clock by ID
    func deleteClock(id: UUID) throws
    
    /// Deletes multiple clocks by IDs
    func deleteClocks(ids: [UUID]) throws
    
    /// Gets a clock by ID
    func getClock(id: UUID) -> ClockModel?
}

