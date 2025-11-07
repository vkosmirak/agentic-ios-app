//
//  CompassView.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import SwiftUI

/// Main compass view combining all sub-views
struct CompassView: View {
    @StateObject private var viewModel: CompassViewModel
    
    init(viewModel: CompassViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top section: Heading display and settings
                VStack(spacing: 16) {
                    // Heading display
                    if let reading = viewModel.compassReading {
                        Text(String(format: "%.0f°", reading.heading))
                            .font(.system(size: 64, weight: .thin, design: .rounded))
                            .foregroundColor(.primary)
                            .accessibilityLabel("Heading: \(String(format: "%.0f degrees", reading.heading))")
                    } else {
                        Text("--°")
                            .font(.system(size: 64, weight: .thin, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    
                    // North type toggle
                    Button(action: viewModel.toggleNorthType) {
                        HStack {
                            Text(viewModel.northType.displayName)
                                .font(.subheadline)
                            Image(systemName: "arrow.2.squarepath")
                                .font(.caption)
                        }
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color(.systemGray6))
                        )
                    }
                    .accessibilityLabel("North type: \(viewModel.northType.displayName). Tap to toggle")
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Compass rose
                CompassRoseView(
                    heading: viewModel.compassReading?.heading ?? 0,
                    bearingLock: viewModel.bearingLock,
                    isDeviating: viewModel.isDeviating
                )
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal, 40)
                
                Spacer()
                
                // Bottom section: Coordinates and bearing lock
                VStack(spacing: 24) {
                    // Coordinates
                    CoordinatesView(
                        locationData: viewModel.locationData,
                        elevationUnit: viewModel.elevationUnit,
                        onTap: viewModel.openLocationInMaps
                    )
                    
                    // Elevation unit toggle
                    Button(action: viewModel.toggleElevationUnit) {
                        Text(viewModel.elevationUnit == .meters ? "Switch to Feet" : "Switch to Meters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .accessibilityLabel("Switch elevation unit to \(viewModel.elevationUnit == .meters ? "feet" : "meters")")
                    
                    // Bearing lock
                    BearingLockView(
                        isLocked: viewModel.bearingLock != nil,
                        isDeviating: viewModel.isDeviating,
                        deviation: viewModel.bearingDeviation,
                        onToggle: {
                            if viewModel.bearingLock != nil {
                                viewModel.unlockBearing()
                            } else {
                                viewModel.lockBearing()
                            }
                        }
                    )
                }
                .padding(.bottom, 40)
            }
            
            // Error message overlay
            if let errorMessage = viewModel.errorMessage {
                VStack {
                    Spacer()
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .shadow(radius: 8)
                        )
                        .padding()
                    Spacer()
                }
            }
            
            // Calibration prompt overlay
            if viewModel.showCalibrationPrompt {
                CalibrationView(
                    needsCalibration: viewModel.needsCalibration,
                    onDismiss: viewModel.dismissCalibrationPrompt
                )
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

#Preview {
    let container = DefaultDependencyContainer()
    container.registerAppServices()
    
    let locationService = container.resolve(LocationServiceProtocol.self)
    let compassService = container.resolve(CompassServiceProtocol.self)
    let calibrationService = container.resolve(CalibrationServiceProtocol.self)
    
    let viewModel = CompassViewModel(
        locationService: locationService,
        compassService: compassService,
        calibrationService: calibrationService
    )
    
    return CompassView(viewModel: viewModel)
}

