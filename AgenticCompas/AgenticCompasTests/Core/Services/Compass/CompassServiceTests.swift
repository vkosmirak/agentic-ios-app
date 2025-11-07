//
//  CompassServiceTests.swift
//  AgenticCompasTests
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import XCTest
import Combine
@testable import AgenticCompas

final class CompassServiceTests: XCTestCase {
    var service: CompassService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        service = CompassService()
        cancellables = []
    }
    
    override func tearDown() {
        service.stopCompassUpdates()
        cancellables.removeAll()
        cancellables = nil
        service = nil
        super.tearDown()
    }
    
    // MARK: - North Type Tests
    
    func testNorthTypeDefault_WhenInitialized_IsMagnetic() {
        // Given: Service is initialized
        // When: Checking default north type
        // Then: Should be magnetic
        XCTAssertEqual(service.northType, .magnetic, "Default north type should be magnetic")
    }
    
    func testNorthType_WhenSetToTrue_UpdatesCorrectly() {
        // Given: Service is initialized with magnetic north
        XCTAssertEqual(service.northType, .magnetic)
        
        // When: Setting north type to true
        service.northType = .`true`
        
        // Then: Should be true north
        XCTAssertEqual(service.northType, .`true`, "North type should be true")
    }
    
    func testNorthType_WhenSetToMagnetic_UpdatesCorrectly() {
        // Given: North type is true
        service.northType = .`true`
        
        // When: Setting north type to magnetic
        service.northType = .magnetic
        
        // Then: Should be magnetic
        XCTAssertEqual(service.northType, .magnetic, "North type should be magnetic")
    }
    
    // MARK: - Compass Reading Publisher Tests
    
    func testCompassReadingPublisher_WhenStarted_PublishesReadings() {
        // Given: Service is initialized
        let expectation = XCTestExpectation(description: "Compass reading received")
        
        // When: Starting compass updates
        service.compassReadingPublisher
            .sink { reading in
                // On simulator, heading may not be available
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        service.startCompassUpdates()
        
        // Then: Should receive reading (or nil if unavailable)
        wait(for: [expectation], timeout: 2.0)
    }
}

