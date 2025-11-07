//
//  CompassViewModelTests.swift
//  AgenticCompasTests
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import XCTest
import Combine
import CoreLocation
@testable import AgenticCompas

final class CompassViewModelTests: XCTestCase {
    var viewModel: CompassViewModel!
    var mockLocationService: LocationServiceMock!
    var mockCompassService: CompassServiceMock!
    var mockCalibrationService: CalibrationServiceMock!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockLocationService = LocationServiceMock()
        mockCompassService = CompassServiceMock()
        mockCalibrationService = CalibrationServiceMock()
        
        viewModel = CompassViewModel(
            locationService: mockLocationService,
            compassService: mockCompassService,
            calibrationService: mockCalibrationService
        )
        cancellables = []
    }
    
    override func tearDown() {
        viewModel.onDisappear()
        cancellables.removeAll()
        cancellables = nil
        viewModel = nil
        mockCalibrationService = nil
        mockCompassService = nil
        mockLocationService = nil
        super.tearDown()
    }
    
    // MARK: - Initial State Tests
    
    @MainActor
    func testInitialState_AllPropertiesAreSetToDefaults() {
        // Given: ViewModel is initialized
        // When: Checking initial state
        // Then: All properties should have default values
        XCTAssertNil(viewModel.compassReading, "Compass reading should be nil initially")
        XCTAssertNil(viewModel.locationData, "Location data should be nil initially")
        XCTAssertNil(viewModel.bearingLock, "Bearing lock should be nil initially")
        XCTAssertEqual(viewModel.northType, .magnetic, "North type should default to magnetic")
        XCTAssertEqual(viewModel.elevationUnit, .meters, "Elevation unit should default to meters")
    }
    
    // MARK: - North Type Toggle Tests
    
    @MainActor
    func testToggleNorthType_WhenMagnetic_ChangesToTrue() {
        // Given: North type is magnetic
        XCTAssertEqual(viewModel.northType, .magnetic)
        
        // When: Toggling north type
        viewModel.toggleNorthType()
        
        // Then: Should change to true north
        XCTAssertEqual(viewModel.northType, .`true`, "North type should change to true")
        XCTAssertEqual(mockCompassService.northType, .`true`, "Compass service should be updated")
    }
    
    @MainActor
    func testToggleNorthType_WhenTrue_ChangesToMagnetic() {
        // Given: North type is true
        viewModel.northType = .`true`
        mockCompassService.northType = .`true`
        
        // When: Toggling north type
        viewModel.toggleNorthType()
        
        // Then: Should change to magnetic
        XCTAssertEqual(viewModel.northType, .magnetic, "North type should change to magnetic")
        XCTAssertEqual(mockCompassService.northType, .magnetic, "Compass service should be updated")
    }
    
    // MARK: - Elevation Unit Toggle Tests
    
    @MainActor
    func testToggleElevationUnit_WhenMeters_ChangesToFeet() {
        // Given: Elevation unit is meters
        XCTAssertEqual(viewModel.elevationUnit, .meters)
        
        // When: Toggling elevation unit
        viewModel.toggleElevationUnit()
        
        // Then: Should change to feet
        XCTAssertEqual(viewModel.elevationUnit, .feet, "Elevation unit should change to feet")
    }
    
    @MainActor
    func testToggleElevationUnit_WhenFeet_ChangesToMeters() {
        // Given: Elevation unit is feet
        viewModel.elevationUnit = .feet
        
        // When: Toggling elevation unit
        viewModel.toggleElevationUnit()
        
        // Then: Should change to meters
        XCTAssertEqual(viewModel.elevationUnit, .meters, "Elevation unit should change to meters")
    }
    
    // MARK: - Bearing Lock Tests
    
    @MainActor
    func testLockBearing_WhenCompassReadingExists_LocksCurrentHeading() throws {
        // Given: Compass reading is available
        mockCompassService.startCompassUpdates()
        viewModel.onAppear()
        
        let expectation = XCTestExpectation(description: "Compass reading received")
        viewModel.$compassReading
            .dropFirst()
            .sink { reading in
                if reading != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        // When: Locking bearing
        viewModel.lockBearing()
        
        // Then: Bearing should be locked at current heading
        let bearingLock = try XCTUnwrap(viewModel.bearingLock, "Bearing lock should not be nil")
        XCTAssertEqual(bearingLock.bearing, 45.0, accuracy: 0.1, "Bearing should be locked at 45 degrees")
    }
    
    @MainActor
    func testLockBearing_WhenNoCompassReading_DoesNotLock() {
        // Given: No compass reading available
        XCTAssertNil(viewModel.compassReading)
        
        // When: Attempting to lock bearing
        viewModel.lockBearing()
        
        // Then: Bearing should remain nil
        XCTAssertNil(viewModel.bearingLock, "Bearing lock should remain nil when no reading available")
    }
    
    @MainActor
    func testUnlockBearing_WhenLocked_RemovesBearingLock() {
        // Given: Bearing is locked
        mockCompassService.startCompassUpdates()
        viewModel.onAppear()
        
        let expectation = XCTestExpectation(description: "Compass reading received")
        viewModel.$compassReading
            .dropFirst()
            .sink { reading in
                if reading != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        viewModel.lockBearing()
        XCTAssertNotNil(viewModel.bearingLock, "Bearing should be locked")
        
        // When: Unlocking bearing
        viewModel.unlockBearing()
        
        // Then: Bearing lock should be removed
        XCTAssertNil(viewModel.bearingLock, "Bearing lock should be removed")
    }
    
    @MainActor
    func testBearingDeviation_WhenLockedAtCurrentHeading_ReturnsZero() throws {
        // Given: Bearing is locked at current heading (45°)
        mockCompassService.startCompassUpdates()
        viewModel.onAppear()
        
        let expectation = XCTestExpectation(description: "Compass reading received")
        viewModel.$compassReading
            .dropFirst()
            .sink { reading in
                if reading != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
        
        viewModel.lockBearing()
        
        // When: Checking deviation
        // Then: Deviation should be zero and not deviating
        let deviation = try XCTUnwrap(viewModel.bearingDeviation, "Deviation should not be nil")
        XCTAssertEqual(deviation, 0.0, accuracy: 0.1, "Deviation should be zero when locked at current heading")
        XCTAssertFalse(viewModel.isDeviating, "Should not be deviating when locked at current heading")
    }
}
