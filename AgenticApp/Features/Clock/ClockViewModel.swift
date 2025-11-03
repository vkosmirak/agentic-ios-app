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
    
    var cancellables: Set<AnyCancellable> = []
    
    private let timeService: TimeServiceProtocol
    private let localTimeZone: TimeZone
    
    init(timeService: TimeServiceProtocol, localTimeZone: TimeZone = .current) {
        self.timeService = timeService
        self.localTimeZone = localTimeZone
        setupInitialClocks()
    }
    
    func onAppear() {
        startTimer()
    }
    
    func onDisappear() {
        cancellables.removeAll()
    }
    
    // MARK: - Private Methods
    
    private func setupInitialClocks() {
        clocks = ClockModel.defaultClocks
    }
    
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

