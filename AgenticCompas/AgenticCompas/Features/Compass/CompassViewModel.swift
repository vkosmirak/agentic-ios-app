//
//  CompassViewModel.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import Foundation
import Combine
import CoreLocation
import UIKit

/// ViewModel for the Compass feature
final class CompassViewModel: ViewModel {
    @Published var compassReading: CompassReading?
    @Published var locationData: LocationData?
    @Published var bearingLock: BearingLock?
    @Published var northType: NorthType = .magnetic
    @Published var elevationUnit: ElevationUnit = .meters
    @Published var calibrationStatus: CalibrationAccuracy = .uncalibrated
    @Published var needsCalibration: Bool = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var errorMessage: String?
    @Published var showCalibrationPrompt: Bool = false
    
    var cancellables: Set<AnyCancellable> = []
    
    private let locationService: LocationServiceProtocol
    private var compassService: CompassServiceProtocol
    private let calibrationService: CalibrationServiceProtocol
    
    init(
        locationService: LocationServiceProtocol,
        compassService: CompassServiceProtocol,
        calibrationService: CalibrationServiceProtocol
    ) {
        self.locationService = locationService
        self.compassService = compassService
        self.calibrationService = calibrationService
    }
    
    func onAppear() {
        setupSubscriptions()
        requestPermissions()
    }
    
    func onDisappear() {
        locationService.stopLocationUpdates()
        compassService.stopCompassUpdates()
        cancellables.removeAll()
    }
    
    // MARK: - Public Methods
    
    func requestPermissions() {
        locationService.requestAuthorization()
    }
    
    func toggleNorthType() {
        northType = northType == .magnetic ? .`true` : .magnetic
        compassService.northType = northType
    }
    
    func toggleElevationUnit() {
        elevationUnit = elevationUnit == .meters ? .feet : .meters
    }
    
    func lockBearing() {
        guard let reading = compassReading else { return }
        bearingLock = BearingLock(bearing: reading.heading)
    }
    
    func unlockBearing() {
        bearingLock = nil
    }
    
    func openLocationInMaps() {
        guard let location = locationData else { return }
        let urlString = "http://maps.apple.com/?ll=\(location.latitude),\(location.longitude)"
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
    func dismissCalibrationPrompt() {
        showCalibrationPrompt = false
    }
    
    // MARK: - Private Methods
    
    private func setupSubscriptions() {
        // Location updates
        locationService.locationPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] location in
                self?.locationData = location
            }
            .store(in: &cancellables)
        
        // Authorization status
        locationService.authorizationStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.authorizationStatus = status
                self?.handleAuthorizationStatus(status)
            }
            .store(in: &cancellables)
        
        // Compass readings
        compassService.compassReadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reading in
                self?.compassReading = reading
                if let reading = reading {
                    self?.calibrationService.updateCalibrationStatus(accuracy: reading.accuracy)
                }
            }
            .store(in: &cancellables)
        
        // Calibration status
        calibrationService.calibrationStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.calibrationStatus = status
                self?.needsCalibration = self?.calibrationService.needsCalibration ?? false
                
                if status == .poor || status == .uncalibrated {
                    self?.showCalibrationPrompt = true
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            locationService.startLocationUpdates()
            compassService.startCompassUpdates()
            errorMessage = nil
        case .denied, .restricted:
            errorMessage = "Location access is required for compass functionality. Please enable it in Settings."
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    /// Calculate deviation from locked bearing
    var bearingDeviation: Double? {
        guard let lock = bearingLock, let reading = compassReading else { return nil }
        return lock.deviation(from: reading.heading)
    }
    
    /// Whether currently deviating from locked bearing
    var isDeviating: Bool {
        guard let lock = bearingLock, let reading = compassReading else { return false }
        return lock.isDeviating(from: reading.heading)
    }
}

