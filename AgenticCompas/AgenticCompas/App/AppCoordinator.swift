//
//  AppCoordinator.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import SwiftUI

/// Root coordinator for the app
final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    private let dependencyContainer: DependencyContainer
    private let compassCoordinator: CompassCoordinator
    
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
        self.compassCoordinator = CompassCoordinator(dependencyContainer: dependencyContainer)
    }
    
    func start() {
        compassCoordinator.start()
        addChild(compassCoordinator)
    }
    
    @ViewBuilder
    func rootView() -> some View {
        compassCoordinator.rootView()
    }
}

