//
//  TimerServiceMock.swift
//  AgenticAppTests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation
@testable import AgenticApp

final class TimerServiceMock: TimerServiceProtocol {
    var timers: [TimerModel] = []
    
    var addTimerCallCount = 0
    var updateTimerCallCount = 0
    var deleteTimerCallCount = 0
    var getTimerCallCount = 0
    
    var lastAddedTimer: TimerModel?
    var lastUpdatedTimer: TimerModel?
    var lastDeletedTimerID: UUID?
    
    func loadTimers() -> [TimerModel] {
        return timers
    }
    
    func saveTimers(_ timers: [TimerModel]) {
        self.timers = timers
    }
    
    func addTimer(_ timer: TimerModel) {
        addTimerCallCount += 1
        lastAddedTimer = timer
        timers.append(timer)
    }
    
    func updateTimer(_ timer: TimerModel) {
        updateTimerCallCount += 1
        lastUpdatedTimer = timer
        if let index = timers.firstIndex(where: { $0.id == timer.id }) {
            timers[index] = timer
        }
    }
    
    func deleteTimer(id: UUID) {
        deleteTimerCallCount += 1
        lastDeletedTimerID = id
        timers.removeAll { $0.id == id }
    }
    
    func getTimer(id: UUID) -> TimerModel? {
        getTimerCallCount += 1
        return timers.first { $0.id == id }
    }
}

