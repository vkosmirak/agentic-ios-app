//
//  CalibrationServiceTests.swift
//  AgenticCompasTests
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import XCTest
import Combine
@testable import AgenticCompas

final class CalibrationServiceTests: XCTestCase {
    var service: CalibrationService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        service = CalibrationService()
        cancellables = []
    }
    
    override func tearDown() {
        cancellables.removeAll()
        cancellables = nil
        service = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    func testInitialStatus_WhenCreated_IsUncalibrated() {
        // Given: Service is initialized
        // When: Checking initial status
        // Then: Should be uncalibrated and need calibration
        XCTAssertEqual(service.calibrationStatus, .uncalibrated, "Initial status should be uncalibrated")
        XCTAssertTrue(service.needsCalibration, "Should need calibration initially")
    }
    
    // MARK: - Calibration Accuracy Tests
    
    func testUpdateCalibrationStatus_WhenAccuracyIsExcellent_SetsStatusToExcellent() {
        // Given: Service is initialized
        // When: Updating with excellent accuracy (≤5°)
        service.updateCalibrationStatus(accuracy: 3.0)
        
        // Then: Status should be excellent and not need calibration
        XCTAssertEqual(service.calibrationStatus, .excellent, "Status should be excellent")
        XCTAssertFalse(service.needsCalibration, "Should not need calibration")
    }
    
    func testUpdateCalibrationStatus_WhenAccuracyIsGood_SetsStatusToGood() {
        // Given: Service is initialized
        // When: Updating with good accuracy (≤15°)
        service.updateCalibrationStatus(accuracy: 10.0)
        
        // Then: Status should be good and not need calibration
        XCTAssertEqual(service.calibrationStatus, .good, "Status should be good")
        XCTAssertFalse(service.needsCalibration, "Should not need calibration")
    }
    
    func testUpdateCalibrationStatus_WhenAccuracyIsFair_SetsStatusToFair() {
        // Given: Service is initialized
        // When: Updating with fair accuracy (≤35°)
        service.updateCalibrationStatus(accuracy: 25.0)
        
        // Then: Status should be fair and not need calibration
        XCTAssertEqual(service.calibrationStatus, .fair, "Status should be fair")
        XCTAssertFalse(service.needsCalibration, "Should not need calibration")
    }
    
    func testUpdateCalibrationStatus_WhenAccuracyIsPoor_SetsStatusToPoor() {
        // Given: Service is initialized
        // When: Updating with poor accuracy (>35°)
        service.updateCalibrationStatus(accuracy: 40.0)
        
        // Then: Status should be poor and need calibration
        XCTAssertEqual(service.calibrationStatus, .poor, "Status should be poor")
        XCTAssertTrue(service.needsCalibration, "Should need calibration")
    }
    
    func testUpdateCalibrationStatus_WhenAccuracyIsInvalid_SetsStatusToUncalibrated() {
        // Given: Service is initialized
        // When: Updating with invalid accuracy (<0)
        service.updateCalibrationStatus(accuracy: -1.0)
        
        // Then: Status should be uncalibrated and need calibration
        XCTAssertEqual(service.calibrationStatus, .uncalibrated, "Status should be uncalibrated")
        XCTAssertTrue(service.needsCalibration, "Should need calibration")
    }
    
    // MARK: - Reset Tests
    
    func testReset_WhenStatusIsExcellent_ResetsToUncalibrated() {
        // Given: Status is excellent
        service.updateCalibrationStatus(accuracy: 5.0)
        XCTAssertEqual(service.calibrationStatus, .excellent)
        
        // When: Resetting
        service.reset()
        
        // Then: Should reset to uncalibrated
        XCTAssertEqual(service.calibrationStatus, .uncalibrated, "Status should reset to uncalibrated")
        XCTAssertTrue(service.needsCalibration, "Should need calibration after reset")
    }
    
    // MARK: - Publisher Tests
    
    func testCalibrationStatusPublisher_WhenStatusChanges_PublishesNewStatus() {
        // Given: Service is initialized
        let expectation = XCTestExpectation(description: "Calibration status updated")
        
        // When: Updating calibration status
        service.calibrationStatusPublisher
            .dropFirst() // Skip initial value
            .sink { status in
                XCTAssertEqual(status, .excellent, "Status should be excellent")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        service.updateCalibrationStatus(accuracy: 2.0)
        
        // Then: Should publish new status
        wait(for: [expectation], timeout: 1.0)
    }
}

