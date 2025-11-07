//
//  CalibrationService.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import Foundation
import Combine

/// Service for compass calibration management
final class CalibrationService: CalibrationServiceProtocol {
    var calibrationStatusPublisher: AnyPublisher<CalibrationAccuracy, Never> {
        calibrationStatusSubject.eraseToAnyPublisher()
    }
    
    var calibrationStatus: CalibrationAccuracy {
        calibrationStatusSubject.value
    }
    
    var needsCalibration: Bool {
        calibrationStatus == .poor || calibrationStatus == .uncalibrated
    }
    
    private let calibrationStatusSubject: CurrentValueSubject<CalibrationAccuracy, Never>
    
    init() {
        self.calibrationStatusSubject = CurrentValueSubject<CalibrationAccuracy, Never>(.uncalibrated)
    }
    
    func updateCalibrationStatus(accuracy: Double) {
        let newStatus: CalibrationAccuracy
        
        if accuracy < 0 {
            // Invalid accuracy
            newStatus = .uncalibrated
        } else if accuracy <= 5 {
            // Excellent: within 5 degrees
            newStatus = .excellent
        } else if accuracy <= 15 {
            // Good: within 15 degrees
            newStatus = .good
        } else if accuracy <= 35 {
            // Fair: within 35 degrees
            newStatus = .fair
        } else {
            // Poor: greater than 35 degrees
            newStatus = .poor
        }
        
        if newStatus != calibrationStatusSubject.value {
            calibrationStatusSubject.send(newStatus)
        }
    }
    
    func reset() {
        calibrationStatusSubject.send(.uncalibrated)
    }
}

