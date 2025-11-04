//
//  TimerService.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Service for managing timers with UserDefaults persistence
final class TimerService: TimerServiceProtocol {
    private let userDefaults: UserDefaults
    private let timersKey = "com.readdle.AgenticApp.timers"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func loadTimers() -> [TimerModel] {
        guard let data = userDefaults.data(forKey: timersKey) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([TimerModel].self, from: data)
        } catch {
            // Log error for debugging, but don't crash
            print("⚠️ Failed to decode timers: \(error.localizedDescription)")
            // Optionally: clear corrupted data
            userDefaults.removeObject(forKey: timersKey)
            return []
        }
    }
    
    func saveTimers(_ timers: [TimerModel]) {
        do {
            let data = try JSONEncoder().encode(timers)
            userDefaults.set(data, forKey: timersKey)
        } catch {
            print("Failed to save timers: \(error.localizedDescription)")
            // Could implement proper error logging/tracking here
        }
    }
    
    func addTimer(_ timer: TimerModel) {
        var timers = loadTimers()
        timers.append(timer)
        saveTimers(timers)
    }
    
    func updateTimer(_ timer: TimerModel) {
        var timers = loadTimers()
        if let index = timers.firstIndex(where: { $0.id == timer.id }) {
            timers[index] = timer
            saveTimers(timers)
        }
    }
    
    func deleteTimer(id: UUID) {
        var timers = loadTimers()
        timers.removeAll { $0.id == id }
        saveTimers(timers)
    }
    
    func getTimer(id: UUID) -> TimerModel? {
        return loadTimers().first { $0.id == id }
    }
}

