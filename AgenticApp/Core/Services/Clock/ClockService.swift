//
//  ClockService.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Service for managing clocks with UserDefaults persistence
final class ClockService: ClockServiceProtocol {
    private let userDefaults: UserDefaults
    private let clocksKey = "com.readdle.AgenticApp.clocks"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func loadClocks() -> [ClockModel] {
        guard let data = userDefaults.data(forKey: clocksKey),
              let clocks = try? JSONDecoder().decode([ClockModel].self, from: data) else {
            // Return empty array if no saved data exists
            return []
        }
        return clocks
    }
    
    func saveClocks(_ clocks: [ClockModel]) throws {
        let data = try JSONEncoder().encode(clocks)
        userDefaults.set(data, forKey: clocksKey)
    }
    
    func addClock(_ clock: ClockModel) throws {
        var clocks = loadClocks()
        // Prevent duplicates
        guard !clocks.contains(where: { $0.id == clock.id || ($0.cityName == clock.cityName && $0.timeZone.identifier == clock.timeZone.identifier) }) else {
            return
        }
        clocks.append(clock)
        try saveClocks(clocks)
    }
    
    func deleteClock(id: UUID) throws {
        var clocks = loadClocks()
        clocks.removeAll { $0.id == id }
        try saveClocks(clocks)
    }
    
    func deleteClocks(ids: [UUID]) throws {
        var clocks = loadClocks()
        clocks.removeAll { ids.contains($0.id) }
        try saveClocks(clocks)
    }
    
    func getClock(id: UUID) -> ClockModel? {
        return loadClocks().first { $0.id == id }
    }
}

