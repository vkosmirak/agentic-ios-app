//
//  LocationData.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import Foundation

/// Model representing location data
struct LocationData {
    /// Latitude in degrees
    let latitude: Double
    
    /// Longitude in degrees
    let longitude: Double
    
    /// Elevation in meters
    let elevation: Double
    
    /// Horizontal accuracy in meters (negative if invalid)
    let accuracy: Double
    
    /// Timestamp of the location
    let timestamp: Date
    
    /// Formatted coordinate string
    var formattedCoordinates: String {
        String(format: "%.6f°, %.6f°", latitude, longitude)
    }
    
    /// Formatted elevation string in meters
    func formattedElevation(unit: ElevationUnit = .meters) -> String {
        switch unit {
        case .meters:
            return String(format: "%.1f m", elevation)
        case .feet:
            let feet = elevation * 3.28084
            return String(format: "%.1f ft", feet)
        }
    }
}

/// Elevation unit
enum ElevationUnit: Equatable, @unchecked Sendable {
    case meters
    case feet
}

