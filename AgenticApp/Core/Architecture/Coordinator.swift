//
//  Coordinator.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation
import SwiftUI

/// Protocol for navigation coordination in MVVM-C architecture
protocol Coordinator: AnyObject {
    /// Starts the coordinator's flow
    func start()
    
    /// Child coordinators managed by this coordinator
    var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {
    /// Adds a child coordinator
    func addChild(_ coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    /// Removes a child coordinator
    func removeChild(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
    
    /// Removes all child coordinators
    func removeAllChildren() {
        childCoordinators.removeAll()
    }
}

