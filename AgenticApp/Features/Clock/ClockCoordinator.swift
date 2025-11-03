//
//  ClockCoordinator.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Coordinator for the Clock feature
final class ClockCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let dependencyContainer: DependencyContainer
    
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }
    
    func start() {
        // No-op: view creation happens in rootView()
    }
    
    @ViewBuilder
    func rootView() -> some View {
        let timeService = dependencyContainer.resolve(TimeServiceProtocol.self)
        let viewModel = ClockViewModel(timeService: timeService)
        ClockView(viewModel: viewModel)
    }
}

