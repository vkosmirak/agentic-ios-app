//
//  AlarmsCoordinator.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Coordinator for the Alarms feature
final class AlarmsCoordinator: Coordinator {
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
        let alarmService = dependencyContainer.resolve(AlarmServiceProtocol.self)
        let viewModel = AlarmsViewModel(alarmService: alarmService)
        AlarmsView(viewModel: viewModel)
    }
}


