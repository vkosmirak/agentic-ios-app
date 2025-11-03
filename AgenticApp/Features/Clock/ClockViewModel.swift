//
//  ClockViewModel.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation
import Combine

/// ViewModel for the Clock feature
final class ClockViewModel: ViewModel {
    @Published var clocks: [ClockModel] = []
    @Published var currentDate: Date = Date()
    @Published var errorMessage: String?
    
    var cancellables: Set<AnyCancellable> = []
    
    private let timeService: TimeServiceProtocol
    private let clockService: ClockServiceProtocol
    private let localTimeZone: TimeZone
    
    init(timeService: TimeServiceProtocol, clockService: ClockServiceProtocol, localTimeZone: TimeZone = .current) {
        self.timeService = timeService
        self.clockService = clockService
        self.localTimeZone = localTimeZone
    }
    
    func onAppear() {
        loadClocks()
        startTimer()
    }
    
    func onDisappear() {
        cancellables.removeAll()
    }
    
    // MARK: - Public Methods
    
    /// Loads clocks from the service
    func loadClocks() {
        let loaded = clockService.loadClocks()
        
        // If no clocks saved, use defaults and save them
        if loaded.isEmpty {
            clocks = ClockModel.defaultClocks
            do {
                try clockService.saveClocks(clocks)
            } catch {
                print("Failed to save default clocks: \(error)")
            }
        } else {
            clocks = loaded
        }
    }
    
    /// Adds a new clock
    func addClock(_ clock: ClockModel) {
        do {
            try clockService.addClock(clock)
            loadClocks()
            errorMessage = nil
        } catch {
            errorMessage = "Failed to add clock. Please try again."
            print("Error adding clock: \(error)")
        }
    }
    
    /// Deletes a clock
    func deleteClock(_ clock: ClockModel) {
        do {
            try clockService.deleteClock(id: clock.id)
            loadClocks()
            errorMessage = nil
        } catch {
            errorMessage = "Failed to delete clock. Please try again."
            print("Error deleting clock: \(error)")
        }
    }
    
    /// Deletes multiple clocks
    func deleteClocks(_ clocks: [ClockModel]) {
        do {
            try clockService.deleteClocks(ids: clocks.map { $0.id })
            loadClocks()
            errorMessage = nil
        } catch {
            errorMessage = "Failed to delete clocks. Please try again."
            print("Error deleting clocks: \(error)")
        }
    }
    
    // MARK: - Private Methods
    
    private func startTimer() {
        Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] date in
                self?.currentDate = date
            }
            .store(in: &cancellables)
    }
    
    /// Gets formatted time for a clock
    func formattedTime(for clock: ClockModel) -> String {
        timeService.formattedTime(currentDate, timeZone: clock.timeZone)
    }
    
    /// Gets time difference for a clock
    func timeDifference(for clock: ClockModel) -> String {
        timeService.timeDifference(from: localTimeZone, to: clock.timeZone)
    }
}

