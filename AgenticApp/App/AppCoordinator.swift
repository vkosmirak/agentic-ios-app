//
//  AppCoordinator.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

/// Root coordinator for the app
final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let dependencyContainer: DependencyContainer
    private let clockCoordinator: ClockCoordinator
    
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
        self.clockCoordinator = ClockCoordinator(dependencyContainer: dependencyContainer)
    }
    
    func start() {
        clockCoordinator.start()
        addChild(clockCoordinator)
    }
    
    @ViewBuilder
    func rootView() -> some View {
        clockCoordinator.rootView()
    }
}

