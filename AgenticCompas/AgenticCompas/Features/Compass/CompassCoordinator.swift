//
//  CompassCoordinator.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import SwiftUI

/// Coordinator for the Compass feature
final class CompassCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let dependencyContainer: DependencyContainer
    
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }
    
    func start() {
        // No child coordinators for compass feature
    }
    
    @ViewBuilder
    func rootView() -> some View {
        let locationService = dependencyContainer.resolve(LocationServiceProtocol.self)
        let compassService = dependencyContainer.resolve(CompassServiceProtocol.self)
        let calibrationService = dependencyContainer.resolve(CalibrationServiceProtocol.self)
        
        let viewModel = CompassViewModel(
            locationService: locationService,
            compassService: compassService,
            calibrationService: calibrationService
        )
        
        CompassView(viewModel: viewModel)
    }
}

