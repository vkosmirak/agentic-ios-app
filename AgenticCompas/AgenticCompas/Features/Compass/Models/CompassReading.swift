//
//  CompassReading.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import Foundation

/// Model representing a compass reading
struct CompassReading {
    /// Heading in degrees (0-360)
    let heading: Double
    
    /// Accuracy in degrees (negative if invalid)
    let accuracy: Double
    
    /// Timestamp of the reading
    let timestamp: Date
}

