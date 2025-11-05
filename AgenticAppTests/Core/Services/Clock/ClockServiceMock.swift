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
    
    func loadClocks() -> [ClockModel] {
        return clocks.isEmpty ? ClockModel.defaultClocks : clocks
    }
    
    func saveClocks(_ clocks: [ClockModel]) throws {
        self.clocks = clocks
    }
    
    func addClock(_ clock: ClockModel) throws {
        if clocks.contains(where: { $0.id == clock.id || ($0.cityName == clock.cityName && $0.timeZone.identifier == clock.timeZone.identifier) }) {
            return
        }
        clocks.append(clock)
    }
    
    func deleteClock(id: UUID) throws {
        clocks.removeAll { $0.id == id }
    }
    
    func deleteClocks(ids: [UUID]) throws {
        clocks.removeAll { ids.contains($0.id) }
    }
    
    func getClock(id: UUID) -> ClockModel? {
        return clocks.first { $0.id == id }
    }
}

