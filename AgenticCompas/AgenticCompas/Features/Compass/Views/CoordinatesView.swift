//
//  CoordinatesView.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import SwiftUI

/// View displaying coordinates and elevation
struct CoordinatesView: View {
    let locationData: LocationData?
    let elevationUnit: ElevationUnit
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            if let location = locationData {
                // Coordinates (tappable)
                Button(action: onTap) {
                    Text(location.formattedCoordinates)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.primary)
                        .underline()
                }
                .accessibilityLabel("Coordinates: \(location.formattedCoordinates). Tap to open in Maps")
                
                // Elevation
                Text(location.formattedElevation(unit: elevationUnit))
                    .font(.system(.subheadline, design: .monospaced))
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Elevation: \(location.formattedElevation(unit: elevationUnit))")
            } else {
                Text("Location unavailable")
                    .font(.system(.body))
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    CoordinatesView(
        locationData: LocationData(
            latitude: 37.7749,
            longitude: -122.4194,
            elevation: 52.0,
            accuracy: 10.0,
            timestamp: Date()
        ),
        elevationUnit: .meters,
        onTap: {}
    )
}

