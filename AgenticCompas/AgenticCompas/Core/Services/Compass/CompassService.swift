//
//  CompassService.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import Foundation
import CoreLocation
import Combine

/// Service for compass operations using CLLocationManager
final class CompassService: NSObject, CompassServiceProtocol {
    var compassReadingPublisher: AnyPublisher<CompassReading?, Never> {
        compassReadingSubject.eraseToAnyPublisher()
    }
    
    var northType: NorthType = .magnetic {
        didSet {
            updateHeading()
        }
    }
    
    private let locationManager: CLLocationManager
    private let compassReadingSubject = PassthroughSubject<CompassReading?, Never>()
    private var lastHeading: CLLocationDirection?
    private var smoothingBuffer: [CLLocationDirection] = []
    private let smoothingBufferSize = 5
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
    }
    
    func startCompassUpdates() {
        guard CLLocationManager.headingAvailable() else {
            print("Heading not available on this device")
            compassReadingSubject.send(nil)
            return
        }
        
        locationManager.startUpdatingHeading()
    }
    
    func stopCompassUpdates() {
        locationManager.stopUpdatingHeading()
    }
    
    private func updateHeading() {
        guard let heading = lastHeading else { return }
        processHeading(heading)
    }
    
    private func processHeading(_ heading: CLLocationDirection) {
        // Apply smoothing filter
        smoothingBuffer.append(heading)
        if smoothingBuffer.count > smoothingBufferSize {
            smoothingBuffer.removeFirst()
        }
        
        let smoothedHeading = smoothingBuffer.reduce(0.0, +) / Double(smoothingBuffer.count)
        
        // Convert to true north if needed
        let finalHeading: Double
        if northType == .true {
            // Get magnetic declination from location if available
            // For now, we'll use a simplified approach
            // In a real app, you'd get this from the current location
            finalHeading = smoothedHeading // TODO: Add magnetic declination calculation
        } else {
            finalHeading = smoothedHeading
        }
        
        // Normalize to 0-360
        let normalizedHeading = (finalHeading + 360).truncatingRemainder(dividingBy: 360)
        
        let reading = CompassReading(
            heading: normalizedHeading,
            accuracy: locationManager.heading?.headingAccuracy ?? -1,
            timestamp: Date()
        )
        
        compassReadingSubject.send(reading)
    }
}

// MARK: - CLLocationManagerDelegate

extension CompassService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        lastHeading = newHeading.magneticHeading
        processHeading(newHeading.magneticHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Compass error: \(error.localizedDescription)")
        compassReadingSubject.send(nil)
    }
}

