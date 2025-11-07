//
//  CalibrationView.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import SwiftUI

/// View displaying calibration prompt
struct CalibrationView: View {
    let needsCalibration: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        if needsCalibration {
            VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.orange)
                
                Text("Compass Calibration Needed")
                    .font(.headline)
                
                Text("Move your device in a figure-8 motion to calibrate the compass.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                
                Button("Dismiss", action: onDismiss)
                    .buttonStyle(.bordered)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 8)
            )
            .padding()
            .transition(.scale.combined(with: .opacity))
        }
    }
}

#Preview {
    CalibrationView(needsCalibration: true, onDismiss: {})
}

