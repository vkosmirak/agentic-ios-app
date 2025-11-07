//
//  CalibrationServiceMock.swift
//  AgenticCompasTests
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import Foundation
import Combine
@testable import AgenticCompas

final class CalibrationServiceMock: CalibrationServiceProtocol {
    var calibrationStatusPublisher: AnyPublisher<CalibrationAccuracy, Never> {
        calibrationStatusSubject.eraseToAnyPublisher()
    }
    
    var calibrationStatus: CalibrationAccuracy = .uncalibrated
    
    var needsCalibration: Bool {
        calibrationStatus == .poor || calibrationStatus == .uncalibrated
    }
    
    // Test tracking properties
    var updateCalibrationStatusCallCount = 0
    var lastAccuracyValue: Double?
    var resetCallCount = 0
    
    private let calibrationStatusSubject = CurrentValueSubject<CalibrationAccuracy, Never>(.uncalibrated)
    
    func updateCalibrationStatus(accuracy: Double) {
        updateCalibrationStatusCallCount += 1
        lastAccuracyValue = accuracy
        
        let newStatus: CalibrationAccuracy
        if accuracy < 0 {
            newStatus = .uncalibrated
        } else if accuracy <= 5 {
            newStatus = .excellent
        } else if accuracy <= 15 {
            newStatus = .good
        } else if accuracy <= 35 {
            newStatus = .fair
        } else {
            newStatus = .poor
        }
        calibrationStatusSubject.send(newStatus)
    }
    
    func reset() {
        resetCallCount += 1
        calibrationStatusSubject.send(.uncalibrated)
    }
}

