//
//  AgenticAppApp.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import SwiftUI

@main
struct AgenticAppApp: App {
    private let dependencyContainer: DependencyContainer
    private let appCoordinator: AppCoordinator
    
    init() {
        // Initialize dependency container
        let container = DefaultDependencyContainer()
        
        // Register services
        container.register(TimeServiceProtocol.self) {
            TimeService() as TimeServiceProtocol
        }
        
        container.register(AlarmServiceProtocol.self) {
            AlarmService() as AlarmServiceProtocol
        }
        
        self.dependencyContainer = container
        
        // Initialize and start app coordinator
        let coordinator = AppCoordinator(dependencyContainer: container)
        coordinator.start()
        self.appCoordinator = coordinator
    }
    
    var body: some Scene {
        WindowGroup {
            appCoordinator.rootView()
        }
    }
}
