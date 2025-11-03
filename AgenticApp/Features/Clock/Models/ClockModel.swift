//
//  ClockModel.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Model representing a world clock
struct ClockModel: Identifiable, Equatable {
    let id: UUID
    let cityName: String
    let timeZone: TimeZone
    
    init(id: UUID = UUID(), cityName: String, timeZoneIdentifier: String) {
        self.id = id
        self.cityName = cityName
        self.timeZone = TimeZone(identifier: timeZoneIdentifier) ?? TimeZone.current
    }
    
    init(id: UUID = UUID(), cityName: String, timeZone: TimeZone) {
        self.id = id
        self.cityName = cityName
        self.timeZone = timeZone
    }
}

extension ClockModel {
    /// Default world clocks for initial setup
    static let defaultClocks: [ClockModel] = [
        ClockModel(cityName: "Cupertino", timeZoneIdentifier: "America/Los_Angeles"),
        ClockModel(cityName: "New York", timeZoneIdentifier: "America/New_York"),
        ClockModel(cityName: "London", timeZoneIdentifier: "Europe/London"),
        ClockModel(cityName: "Tokyo", timeZoneIdentifier: "Asia/Tokyo"),
        ClockModel(cityName: "Sydney", timeZoneIdentifier: "Australia/Sydney")
    ]
}

