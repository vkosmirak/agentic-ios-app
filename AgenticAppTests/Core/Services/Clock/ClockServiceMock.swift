//
//  ClockServiceMock.swift
//  AgenticAppTests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation
@testable import AgenticApp

final class ClockServiceMock: ClockServiceProtocol {
    var clocks: [ClockModel] = []
    
    // Error simulation
    var shouldThrowErrorOnSave = false
    var shouldThrowErrorOnAdd = false
    var shouldThrowErrorOnDelete = false
    var shouldThrowErrorOnDeleteMultiple = false
    
    var loadClocksCallCount = 0
    var saveClocksCallCount = 0
    var addClockCallCount = 0
    var deleteClockCallCount = 0
    var deleteClocksCallCount = 0
    
    var lastAddedClock: ClockModel?
    var lastDeletedClockID: UUID?
    var lastDeletedClockIDs: [UUID]?
    
    func loadClocks() -> [ClockModel] {
        loadClocksCallCount += 1
        return clocks
    }
    
    func saveClocks(_ clocks: [ClockModel]) throws {
        saveClocksCallCount += 1
        if shouldThrowErrorOnSave {
            throw NSError(domain: "ClockServiceMock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock save error"])
        }
        self.clocks = clocks
    }
    
    func addClock(_ clock: ClockModel) throws {
        addClockCallCount += 1
        lastAddedClock = clock
        if shouldThrowErrorOnAdd {
            throw NSError(domain: "ClockServiceMock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock add error"])
        }
        // Prevent duplicates
        guard !clocks.contains(where: { $0.id == clock.id || ($0.cityName == clock.cityName && $0.timeZone.identifier == clock.timeZone.identifier) }) else {
            return
        }
        clocks.append(clock)
        // In real service, addClock saves after adding, but ViewModel calls loadClocks() after addClock
        // So we don't need to explicitly save here - loadClocks() will return the updated array
    }
    
    func deleteClock(id: UUID) throws {
        deleteClockCallCount += 1
        lastDeletedClockID = id
        if shouldThrowErrorOnDelete {
            throw NSError(domain: "ClockServiceMock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock delete error"])
        }
        clocks.removeAll { $0.id == id }
    }
    
    func deleteClocks(ids: [UUID]) throws {
        deleteClocksCallCount += 1
        lastDeletedClockIDs = ids
        if shouldThrowErrorOnDeleteMultiple {
            throw NSError(domain: "ClockServiceMock", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock delete multiple error"])
        }
        clocks.removeAll { ids.contains($0.id) }
    }
    
    func getClock(id: UUID) -> ClockModel? {
        return clocks.first { $0.id == id }
    }
}

