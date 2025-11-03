//
//  AlarmsViewModel.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation
import Combine

/// ViewModel for the Alarms feature
final class AlarmsViewModel: ViewModel {
    @Published var alarms: [AlarmModel] = []
    
    var cancellables: Set<AnyCancellable> = []
    
    private let alarmService: AlarmServiceProtocol
    
    init(alarmService: AlarmServiceProtocol) {
        self.alarmService = alarmService
    }
    
    func onAppear() {
        loadAlarms()
    }
    
    // MARK: - Public Methods
    
    /// Loads alarms from the service
    func loadAlarms() {
        alarms = alarmService.loadAlarms()
            .sorted { $0.time < $1.time }
    }
    
    /// Adds a new alarm
    func addAlarm(_ alarm: AlarmModel) {
        alarmService.addAlarm(alarm)
        loadAlarms()
    }
    
    /// Updates an existing alarm
    func updateAlarm(_ alarm: AlarmModel) {
        alarmService.updateAlarm(alarm)
        loadAlarms()
    }
    
    /// Deletes an alarm
    func deleteAlarm(_ alarm: AlarmModel) {
        alarmService.deleteAlarm(id: alarm.id)
        loadAlarms()
    }
    
    /// Toggles alarm enabled state
    func toggleAlarm(_ alarm: AlarmModel) {
        var updatedAlarm = alarm
        updatedAlarm.isEnabled.toggle()
        updateAlarm(updatedAlarm)
    }
    
    /// Gets alarm by ID
    func getAlarm(id: UUID) -> AlarmModel? {
        return alarmService.getAlarm(id: id)
    }
}

