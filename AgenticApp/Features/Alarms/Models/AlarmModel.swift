//
//  AlarmModel.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Represents a day of the week for alarm repeat schedule
enum Weekday: Int, Codable, CaseIterable, Identifiable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    var id: Int { rawValue }
    
    var shortName: String {
        switch self {
        case .sunday: return "S"
        case .monday: return "M"
        case .tuesday: return "Tu"
        case .wednesday: return "W"
        case .thursday: return "Th"
        case .friday: return "F"
        case .saturday: return "S"
        }
    }
    
    var fullName: String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monday"
        case .tuesday: return "Tuesday"
        case .wednesday: return "Wednesday"
        case .thursday: return "Thursday"
        case .friday: return "Friday"
        case .saturday: return "Saturday"
        }
    }
}

/// Model representing an alarm
struct AlarmModel: Identifiable, Codable, Equatable {
    let id: UUID
    var time: Date
    var label: String?
    var isEnabled: Bool
    var repeatDays: Set<Weekday>
    var sound: String
    var snooze: Bool
    
    init(
        id: UUID = UUID(),
        time: Date,
        label: String? = nil,
        isEnabled: Bool = true,
        repeatDays: Set<Weekday> = [],
        sound: String = "Radar",
        snooze: Bool = true
    ) {
        self.id = id
        self.time = time
        self.label = label
        self.isEnabled = isEnabled
        self.repeatDays = repeatDays
        self.sound = sound
        self.snooze = snooze
    }
    
    /// Formatted time string (e.g., "8:30 AM")
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
    
    /// Formatted repeat days string (e.g., "Mon, Wed, Fri" or "Never")
    var formattedRepeatDays: String {
        guard !repeatDays.isEmpty else {
            return "Never"
        }
        
        if repeatDays.count == 7 {
            return "Every Day"
        }
        
        let sortedDays = repeatDays.sorted { $0.rawValue < $1.rawValue }
        return sortedDays.map { $0.shortName }.joined(separator: ", ")
    }
}

