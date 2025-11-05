//
//  TimeInterval+Extensions.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation

extension TimeInterval {
    /// Formats time interval as MM:SS,HH (minutes:seconds,centiseconds) for stopwatch display
    func formattedStopwatchTime() -> String {
        enum Constants {
            static let centisecondsPerSecond = 100
            static let centisecondsPerMinute = 6000
        }
        
        let totalCentiseconds = Int(self * Double(Constants.centisecondsPerSecond))
        let minutes = totalCentiseconds / Constants.centisecondsPerMinute
        let seconds = (totalCentiseconds % Constants.centisecondsPerMinute) / Constants.centisecondsPerSecond
        let centiseconds = totalCentiseconds % Constants.centisecondsPerSecond
        
        return String(format: "%02d:%02d,%02d", minutes, seconds, centiseconds)
    }
}


