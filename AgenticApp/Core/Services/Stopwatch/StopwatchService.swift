//
//  StopwatchService.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Service for managing stopwatch state with UserDefaults persistence
final class StopwatchService: StopwatchServiceProtocol {
    private let userDefaults: UserDefaults
    private let stopwatchKey = "com.readdle.AgenticApp.stopwatch"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func loadStopwatch() -> StopwatchModel {
        guard let data = userDefaults.data(forKey: stopwatchKey) else {
            return StopwatchModel()
        }
        
        do {
            return try JSONDecoder().decode(StopwatchModel.self, from: data)
        } catch {
            // Log error for debugging, but don't crash
            print("⚠️ Failed to decode stopwatch: \(error.localizedDescription)")
            // Optionally: clear corrupted data
            userDefaults.removeObject(forKey: stopwatchKey)
            return StopwatchModel()
        }
    }
    
    func saveStopwatch(_ stopwatch: StopwatchModel) {
        do {
            let data = try JSONEncoder().encode(stopwatch)
            userDefaults.set(data, forKey: stopwatchKey)
        } catch {
            print("⚠️ Failed to save stopwatch: \(error.localizedDescription)")
            // Could implement proper error logging/tracking here
        }
    }
    
    func resetStopwatch() {
        userDefaults.removeObject(forKey: stopwatchKey)
    }
}

