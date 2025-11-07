//
//  CompassServiceProtocol.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import Foundation
import Combine

/// Protocol for compass operations
protocol CompassServiceProtocol {
    /// Publisher for compass reading updates
    var compassReadingPublisher: AnyPublisher<CompassReading?, Never> { get }
    
    /// Current north type (magnetic or true)
    var northType: NorthType { get set }
    
    /// Start compass updates
    func startCompassUpdates()
    
    /// Stop compass updates
    func stopCompassUpdates()
}

