//
//  StopwatchServiceProtocol.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Protocol for stopwatch service operations
/// Note: Intentionally minimal - stopwatch is ephemeral and doesn't require persistence.
/// This protocol exists for architectural consistency with other features, enabling
/// future extensibility (e.g., history, statistics) without breaking existing code.
protocol StopwatchServiceProtocol {
    // Currently empty - stopwatch state is managed in ViewModel
    // Future methods could include: saveHistory(), getStatistics(), etc.
}

