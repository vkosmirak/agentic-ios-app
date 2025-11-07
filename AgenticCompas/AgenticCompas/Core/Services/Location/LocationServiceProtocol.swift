//
//  LocationServiceProtocol.swift
//  AgenticCompas
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import Foundation
import CoreLocation
import Combine

/// Protocol for location operations
protocol LocationServiceProtocol {
    /// Publisher for location updates
    var locationPublisher: AnyPublisher<LocationData?, Never> { get }
    
    /// Publisher for authorization status updates
    var authorizationStatusPublisher: AnyPublisher<CLAuthorizationStatus, Never> { get }
    
    /// Current authorization status
    var authorizationStatus: CLAuthorizationStatus { get }
    
    /// Request location permission
    func requestAuthorization()
    
    /// Start location updates
    func startLocationUpdates()
    
    /// Stop location updates
    func stopLocationUpdates()
}

