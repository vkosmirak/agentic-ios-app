//
//  TimersCoordinator.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Coordinator for the Timers feature
final class TimersCoordinator: Coordinator {
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
        let timerService = dependencyContainer.resolve(TimerServiceProtocol.self)
        let viewModel = TimersViewModel(timerService: timerService)
        TimersView(viewModel: viewModel)
    }
}

