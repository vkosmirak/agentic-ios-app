//
//  DependencyContainer+Registration.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

// MARK: - App Service Registration

extension DependencyContainer {
    /// Registers all app services in the dependency container
    func registerAppServices() {
        register(TimeServiceProtocol.self) { TimeService() }
        register(AlarmServiceProtocol.self) { AlarmService() }
        register(ClockServiceProtocol.self) { ClockService() }
        register(TimerServiceProtocol.self) { TimerService() }
        register(StopwatchServiceProtocol.self) { StopwatchService() }
    }
}

