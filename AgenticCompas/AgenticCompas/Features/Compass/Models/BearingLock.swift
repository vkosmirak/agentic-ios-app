//
//  BearingLock.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import Foundation

/// Model representing a locked bearing
struct BearingLock {
    /// Locked bearing in degrees (0-360)
    let bearing: Double
    
    /// Calculate deviation from current heading
    func deviation(from currentHeading: Double) -> Double {
        let diff = abs(currentHeading - bearing)
        return min(diff, 360 - diff)
    }
    
    /// Whether the deviation exceeds the threshold
    func isDeviating(from currentHeading: Double, threshold: Double = 5.0) -> Bool {
        deviation(from: currentHeading) > threshold
    }
}

