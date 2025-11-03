//
//  ClockModel.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Model representing a world clock
struct ClockModel: Identifiable, Equatable, Codable {
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
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case id
        case cityName
        case timeZoneIdentifier
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        cityName = try container.decode(String.self, forKey: .cityName)
        let timeZoneIdentifier = try container.decode(String.self, forKey: .timeZoneIdentifier)
        timeZone = TimeZone(identifier: timeZoneIdentifier) ?? TimeZone.current
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(cityName, forKey: .cityName)
        try container.encode(timeZone.identifier, forKey: .timeZoneIdentifier)
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

