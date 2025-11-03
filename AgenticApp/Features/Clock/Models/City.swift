//
//  City.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Model representing a city with timezone
struct City: Identifiable {
    let id: UUID
    let name: String
    let region: String
    let timeZoneIdentifier: String
    
    init(id: UUID = UUID(), name: String, region: String, timeZoneIdentifier: String) {
        self.id = id
        self.name = name
        self.region = region
        self.timeZoneIdentifier = timeZoneIdentifier
    }
}

extension City {
    /// Common world cities for clock selection
    static let allCities: [City] = [
        // North America
        City(name: "Cupertino", region: "United States", timeZoneIdentifier: "America/Los_Angeles"),
        City(name: "New York", region: "United States", timeZoneIdentifier: "America/New_York"),
        City(name: "Chicago", region: "United States", timeZoneIdentifier: "America/Chicago"),
        City(name: "Denver", region: "United States", timeZoneIdentifier: "America/Denver"),
        City(name: "Toronto", region: "Canada", timeZoneIdentifier: "America/Toronto"),
        City(name: "Vancouver", region: "Canada", timeZoneIdentifier: "America/Vancouver"),
        City(name: "Mexico City", region: "Mexico", timeZoneIdentifier: "America/Mexico_City"),
        
        // South America
        City(name: "São Paulo", region: "Brazil", timeZoneIdentifier: "America/Sao_Paulo"),
        City(name: "Buenos Aires", region: "Argentina", timeZoneIdentifier: "America/Argentina/Buenos_Aires"),
        City(name: "Santiago", region: "Chile", timeZoneIdentifier: "America/Santiago"),
        
        // Europe
        City(name: "London", region: "United Kingdom", timeZoneIdentifier: "Europe/London"),
        City(name: "Paris", region: "France", timeZoneIdentifier: "Europe/Paris"),
        City(name: "Berlin", region: "Germany", timeZoneIdentifier: "Europe/Berlin"),
        City(name: "Rome", region: "Italy", timeZoneIdentifier: "Europe/Rome"),
        City(name: "Madrid", region: "Spain", timeZoneIdentifier: "Europe/Madrid"),
        City(name: "Amsterdam", region: "Netherlands", timeZoneIdentifier: "Europe/Amsterdam"),
        City(name: "Moscow", region: "Russia", timeZoneIdentifier: "Europe/Moscow"),
        City(name: "Istanbul", region: "Turkey", timeZoneIdentifier: "Europe/Istanbul"),
        
        // Asia
        City(name: "Tokyo", region: "Japan", timeZoneIdentifier: "Asia/Tokyo"),
        City(name: "Beijing", region: "China", timeZoneIdentifier: "Asia/Shanghai"),
        City(name: "Hong Kong", region: "China", timeZoneIdentifier: "Asia/Hong_Kong"),
        City(name: "Singapore", region: "Singapore", timeZoneIdentifier: "Asia/Singapore"),
        City(name: "Seoul", region: "South Korea", timeZoneIdentifier: "Asia/Seoul"),
        City(name: "Mumbai", region: "India", timeZoneIdentifier: "Asia/Kolkata"),
        City(name: "Dubai", region: "United Arab Emirates", timeZoneIdentifier: "Asia/Dubai"),
        City(name: "Tel Aviv", region: "Israel", timeZoneIdentifier: "Asia/Jerusalem"),
        City(name: "Bangkok", region: "Thailand", timeZoneIdentifier: "Asia/Bangkok"),
        
        // Oceania
        City(name: "Sydney", region: "Australia", timeZoneIdentifier: "Australia/Sydney"),
        City(name: "Melbourne", region: "Australia", timeZoneIdentifier: "Australia/Melbourne"),
        City(name: "Auckland", region: "New Zealand", timeZoneIdentifier: "Pacific/Auckland"),
        
        // Africa
        City(name: "Cairo", region: "Egypt", timeZoneIdentifier: "Africa/Cairo"),
        City(name: "Johannesburg", region: "South Africa", timeZoneIdentifier: "Africa/Johannesburg"),
        City(name: "Nairobi", region: "Kenya", timeZoneIdentifier: "Africa/Nairobi"),
    ]
}

