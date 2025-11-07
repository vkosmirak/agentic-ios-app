//
//  CalibrationServiceProtocol.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import Foundation
import Combine

/// Calibration accuracy level
enum CalibrationAccuracy: Equatable, @unchecked Sendable {
    case excellent
    case good
    case fair
    case poor
    case uncalibrated
}

/// Protocol for calibration operations
protocol CalibrationServiceProtocol {
    /// Publisher for calibration status updates
    var calibrationStatusPublisher: AnyPublisher<CalibrationAccuracy, Never> { get }
    
    /// Current calibration status
    var calibrationStatus: CalibrationAccuracy { get }
    
    /// Whether calibration is needed
    var needsCalibration: Bool { get }
    
    /// Update calibration status based on heading accuracy
    func updateCalibrationStatus(accuracy: Double)
    
    /// Reset calibration status
    func reset()
}

