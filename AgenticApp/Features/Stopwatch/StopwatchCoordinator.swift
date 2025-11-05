//
//  StopwatchCoordinator.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Coordinator for the Stopwatch feature
final class StopwatchCoordinator: Coordinator {
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
        let stopwatchService = dependencyContainer.resolve(StopwatchServiceProtocol.self)
        let viewModel = StopwatchViewModel(stopwatchService: stopwatchService)
        StopwatchView(viewModel: viewModel)
    }
}


