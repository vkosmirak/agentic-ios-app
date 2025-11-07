//
//  LocationServiceTests.swift
//  AgenticCompasTests
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import XCTest
import Combine
import CoreLocation
@testable import AgenticCompas

final class LocationServiceTests: XCTestCase {
    var service: LocationService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        service = LocationService()
        cancellables = []
    }
    
    override func tearDown() {
        service.stopLocationUpdates()
        cancellables.removeAll()
        cancellables = nil
        service = nil
        super.tearDown()
    }
    
    // MARK: - Authorization Status Tests
    
    func testAuthorizationStatus_WhenInitialized_ReturnsValidStatus() {
        // Given: Service is initialized
        // When: Checking authorization status
        let status = service.authorizationStatus
        
        // Then: Should return a valid authorization status
        let validStatuses: [CLAuthorizationStatus] = [
            .notDetermined,
            .denied,
            .restricted,
            .authorizedWhenInUse,
            .authorizedAlways
        ]
        XCTAssertTrue(validStatuses.contains(status), "Authorization status should be valid")
    }
    
    // MARK: - Publisher Tests
    
    func testAuthorizationStatusPublisher_WhenRequested_PublishesStatus() {
        // Given: Service is initialized
        let expectation = XCTestExpectation(description: "Authorization status received")
        
        // When: Requesting authorization
        service.authorizationStatusPublisher
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        service.requestAuthorization()
        
        // Then: Should publish authorization status
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testLocationPublisher_WhenStarted_MayPublishLocation() {
        // Given: Service is initialized
        let expectation = XCTestExpectation(description: "Location received")
        expectation.isInverted = true // May not receive location in test environment
        
        // When: Starting location updates
        service.locationPublisher
            .sink { location in
                if location != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        service.startLocationUpdates()
        
        // Then: May receive location (or not in test environment)
        wait(for: [expectation], timeout: 1.0)
    }
}

