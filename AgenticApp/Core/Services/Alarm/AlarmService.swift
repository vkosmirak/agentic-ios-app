//
//  AlarmService.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Service for managing alarms with UserDefaults persistence
final class AlarmService: AlarmServiceProtocol {
    private let userDefaults: UserDefaults
    private let alarmsKey = "com.readdle.AgenticApp.alarms"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func loadAlarms() -> [AlarmModel] {
        guard let data = userDefaults.data(forKey: alarmsKey),
              let alarms = try? JSONDecoder().decode([AlarmModel].self, from: data) else {
            return []
        }
        return alarms
    }
    
    func saveAlarms(_ alarms: [AlarmModel]) {
        do {
            let data = try JSONEncoder().encode(alarms)
            userDefaults.set(data, forKey: alarmsKey)
        } catch {
            print("Failed to save alarms: \(error.localizedDescription)")
            // Could implement proper error logging/tracking here
        }
    }
    
    func addAlarm(_ alarm: AlarmModel) {
        var alarms = loadAlarms()
        alarms.append(alarm)
        saveAlarms(alarms)
    }
    
    func updateAlarm(_ alarm: AlarmModel) {
        var alarms = loadAlarms()
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index] = alarm
            saveAlarms(alarms)
        }
    }
    
    func deleteAlarm(id: UUID) {
        var alarms = loadAlarms()
        alarms.removeAll { $0.id == id }
        saveAlarms(alarms)
    }
    
    func getAlarm(id: UUID) -> AlarmModel? {
        return loadAlarms().first { $0.id == id }
    }
}

