//
//  DependencyContainer.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import Foundation

/// Protocol for dependency injection container
protocol DependencyContainer {
    /// Registers a dependency factory
    func register<T>(_ type: T.Type, factory: @escaping () -> T)
    
    /// Resolves a dependency
    func resolve<T>(_ type: T.Type) -> T
}

/// Concrete implementation of DependencyContainer
final class DefaultDependencyContainer: DependencyContainer {
    private var factories: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        factories[key] = factory
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        
        guard let factory = factories[key] as? () -> T else {
            fatalError("Dependency '\(key)' not registered")
        }
        
        return factory()
    }
}

