//
//  TimerModel.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

/// Model representing a timer
struct TimerModel: Identifiable, Codable, Equatable {
    let id: UUID
    var duration: TimeInterval // Duration in seconds
    var label: String?
    var sound: String // Sound name for when timer ends
    var isRunning: Bool
    var remainingTime: TimeInterval // Remaining time in seconds
    var endTime: Date? // When the timer will end (if running)
    var createdAt: Date // When the timer was created (for recent timers)
    
    init(
        id: UUID = UUID(),
        duration: TimeInterval,
        label: String? = nil,
        sound: String = "Radar",
        isRunning: Bool = false,
        remainingTime: TimeInterval? = nil,
        endTime: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.duration = duration
        self.label = label
        self.sound = sound
        self.isRunning = isRunning
        self.remainingTime = remainingTime ?? duration
        self.endTime = endTime
        self.createdAt = createdAt
    }
    
    // MARK: - Codable
    
    enum CodingKeys: String, CodingKey {
        case id, duration, label, sound, isRunning, remainingTime, endTime, createdAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        duration = try container.decode(TimeInterval.self, forKey: .duration)
        label = try container.decodeIfPresent(String.self, forKey: .label)
        sound = try container.decodeIfPresent(String.self, forKey: .sound) ?? "Radar"
        isRunning = try container.decode(Bool.self, forKey: .isRunning)
        remainingTime = try container.decodeIfPresent(TimeInterval.self, forKey: .remainingTime) ?? duration
        endTime = try container.decodeIfPresent(Date.self, forKey: .endTime)
        createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(duration, forKey: .duration)
        try container.encodeIfPresent(label, forKey: .label)
        try container.encode(sound, forKey: .sound)
        try container.encode(isRunning, forKey: .isRunning)
        try container.encode(remainingTime, forKey: .remainingTime)
        try container.encodeIfPresent(endTime, forKey: .endTime)
        try container.encode(createdAt, forKey: .createdAt)
    }
    
    /// Standard Equatable implementation for Identifiable compatibility
    /// Note: For content comparison ignoring ID, use contentMatches(_:) method
    static func == (lhs: TimerModel, rhs: TimerModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.duration == rhs.duration &&
        lhs.label == rhs.label &&
        lhs.sound == rhs.sound &&
        lhs.isRunning == rhs.isRunning &&
        lhs.remainingTime == rhs.remainingTime &&
        lhs.endTime == rhs.endTime &&
        lhs.createdAt == rhs.createdAt
    }
    
    /// Checks if timer content matches (ignoring ID and timestamps)
    func contentMatches(_ other: TimerModel) -> Bool {
        duration == other.duration &&
        label == other.label &&
        sound == other.sound &&
        isRunning == other.isRunning &&
        remainingTime == other.remainingTime &&
        endTime == other.endTime
    }
    
    /// Formatted duration string (e.g., "1:30:00" or "5:00")
    var formattedDuration: String {
        formatTimeInterval(duration)
    }
    
    /// Formatted remaining time string
    var formattedRemainingTime: String {
        formatTimeInterval(remainingTime)
    }
    
    /// Helper to format time interval as HH:MM:SS or MM:SS
    private func formatTimeInterval(_ interval: TimeInterval) -> String {
        let hours = Int(interval) / 3600
        let minutes = (Int(interval) % 3600) / 60
        let seconds = Int(interval) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
    
    /// Creates a default timer with 5 minutes duration
    static var `default`: TimerModel {
        TimerModel(duration: 300) // 5 minutes
    }
    
    /// Checks if timer matches default characteristics (ignoring UUID)
    func matchesDefault() -> Bool {
        duration == 300 &&
        label == nil &&
        sound == "Radar" &&
        isRunning == false &&
        remainingTime == duration &&
        endTime == nil
    }
    
    /// Formatted duration for recent timers (e.g., "15 хв, 38 с")
    var formattedDurationComponents: String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        let seconds = Int(duration) % 60
        
        var components: [String] = []
        if hours > 0 {
            components.append("\(hours) hr")
        }
        if minutes > 0 {
            components.append("\(minutes) min")
        }
        if seconds > 0 || components.isEmpty {
            components.append("\(seconds) sec")
        }
        return components.joined(separator: ", ")
    }
}

