//
//  CompassServiceMock.swift
//  AgenticCompasTests
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import Foundation
import Combine
@testable import AgenticCompas

final class CompassServiceMock: CompassServiceProtocol {
    var compassReadingPublisher: AnyPublisher<CompassReading?, Never> {
        compassReadingSubject.eraseToAnyPublisher()
    }
    
    var northType: NorthType = .magnetic
    
    // Test tracking properties
    var startCompassUpdatesCallCount = 0
    var stopCompassUpdatesCallCount = 0
    
    private let compassReadingSubject = PassthroughSubject<CompassReading?, Never>()
    
    func startCompassUpdates() {
        startCompassUpdatesCallCount += 1
        let reading = CompassReading(
            heading: 45.0,
            accuracy: 5.0,
            timestamp: Date()
        )
        compassReadingSubject.send(reading)
    }
    
    func stopCompassUpdates() {
        stopCompassUpdatesCallCount += 1
    }
}

