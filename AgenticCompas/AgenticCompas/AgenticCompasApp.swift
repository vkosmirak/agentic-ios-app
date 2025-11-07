//
//  AgenticCompasApp.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import SwiftUI

@main
struct AgenticCompasApp: App {
    private let dependencyContainer: DependencyContainer
    private let appCoordinator: AppCoordinator
    
    init() {
        let container = DefaultDependencyContainer()
        container.registerAppServices()
        self.dependencyContainer = container
        
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
