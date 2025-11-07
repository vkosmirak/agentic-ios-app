//
//  DependencyContainer+Registration.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import Foundation

// MARK: - App Service Registration

extension DependencyContainer {
    /// Registers all app services in the dependency container
    func registerAppServices() {
        register(LocationServiceProtocol.self) { LocationService() }
        register(CompassServiceProtocol.self) { CompassService() }
        register(CalibrationServiceProtocol.self) { CalibrationService() }
    }
}

