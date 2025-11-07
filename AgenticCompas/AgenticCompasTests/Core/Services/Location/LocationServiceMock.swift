//
//  LocationServiceMock.swift
//  AgenticCompasTests
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import Foundation
import Combine
import CoreLocation
@testable import AgenticCompas

final class LocationServiceMock: LocationServiceProtocol {
    var locationPublisher: AnyPublisher<LocationData?, Never> {
        locationSubject.eraseToAnyPublisher()
    }
    
    var authorizationStatusPublisher: AnyPublisher<CLAuthorizationStatus, Never> {
        authorizationStatusSubject.eraseToAnyPublisher()
    }
    
    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    // Test tracking properties
    var requestAuthorizationCallCount = 0
    var startLocationUpdatesCallCount = 0
    var stopLocationUpdatesCallCount = 0
    
    private let locationSubject = PassthroughSubject<LocationData?, Never>()
    private let authorizationStatusSubject = PassthroughSubject<CLAuthorizationStatus, Never>()
    
    func requestAuthorization() {
        requestAuthorizationCallCount += 1
        authorizationStatus = .authorizedWhenInUse
        authorizationStatusSubject.send(.authorizedWhenInUse)
    }
    
    func startLocationUpdates() {
        startLocationUpdatesCallCount += 1
        let location = LocationData(
            latitude: 37.7749,
            longitude: -122.4194,
            elevation: 52.0,
            accuracy: 10.0,
            timestamp: Date()
        )
        locationSubject.send(location)
    }
    
    func stopLocationUpdates() {
        stopLocationUpdatesCallCount += 1
    }
}

