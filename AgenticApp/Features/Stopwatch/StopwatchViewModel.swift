//
//  StopwatchViewModel.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation
import Combine

/// ViewModel for the Stopwatch feature
final class StopwatchViewModel: ViewModel {
    @Published var stopwatch: StopwatchModel
    @Published var errorMessage: String?
    
    var cancellables: Set<AnyCancellable> = []
    
    private let stopwatchService: StopwatchServiceProtocol
    private var updateTimer: Timer?
    
    init(stopwatchService: StopwatchServiceProtocol) {
        self.stopwatchService = stopwatchService
        self.stopwatch = stopwatchService.loadStopwatch()
        
        // If stopwatch was running when app closed, reset it (don't auto-resume)
        if stopwatch.isRunning {
            self.stopwatch = StopwatchModel()
            stopwatchService.saveStopwatch(self.stopwatch)
        }
    }
    
    deinit {
        stopTimerUpdates()
    }
    
    func onAppear() {
        startTimerUpdates()
    }
    
    func onDisappear() {
        stopTimerUpdates()
        // Save state when leaving view
        stopwatchService.saveStopwatch(stopwatch)
    }
    
    // MARK: - Public Methods
    
    /// Starts the stopwatch
    func start() {
        guard !stopwatch.isRunning else { return }
        
        stopwatch.isRunning = true
        stopwatch.startTime = Date()
        stopwatch.pausedTime = stopwatch.elapsedTime
        
        stopwatchService.saveStopwatch(stopwatch)
    }
    
    /// Stops/pauses the stopwatch
    func stop() {
        guard stopwatch.isRunning else { return }
        
        if let startTime = stopwatch.startTime {
            stopwatch.elapsedTime = stopwatch.pausedTime + Date().timeIntervalSince(startTime)
        }
        stopwatch.isRunning = false
        stopwatch.startTime = nil
        stopwatch.pausedTime = stopwatch.elapsedTime
        
        stopwatchService.saveStopwatch(stopwatch)
    }
    
    /// Resets the stopwatch to zero
    func reset() {
        stopwatch = StopwatchModel()
        stopwatchService.saveStopwatch(stopwatch)
    }
    
    /// Records a lap time
    func recordLap() {
        guard stopwatch.isRunning || stopwatch.elapsedTime > 0 else { return }
        
        let currentElapsed = stopwatch.currentElapsedTime()
        let lapNumber = stopwatch.laps.count + 1
        
        // Calculate lap time
        let previousTotalTime = stopwatch.laps.last?.totalTime ?? 0
        let lapTime = currentElapsed - previousTotalTime
        
        let lap = LapModel(
            lapNumber: lapNumber,
            lapTime: lapTime,
            totalTime: currentElapsed
        )
        
        stopwatch.laps.append(lap)
        stopwatch.lastUpdated = Date()
        
        stopwatchService.saveStopwatch(stopwatch)
    }
    
    /// Clears all lap times
    func clearLaps() {
        stopwatch.laps = []
        stopwatch.lastUpdated = Date()
        stopwatchService.saveStopwatch(stopwatch)
    }
    
    /// Gets the current elapsed time
    var currentElapsedTime: TimeInterval {
        stopwatch.currentElapsedTime()
    }
    
    /// Gets formatted current elapsed time
    var formattedCurrentElapsedTime: String {
        stopwatch.currentElapsedTime().formattedElapsedTime
    }
    
    // MARK: - Private Methods
    
    /// Starts periodic timer updates for running stopwatch
    private func startTimerUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateRunningStopwatch()
        }
    }
    
    /// Stops timer updates
    private func stopTimerUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    /// Updates elapsed time for running stopwatch
    private func updateRunningStopwatch() {
        guard stopwatch.isRunning else { return }
        
        let newElapsedTime = stopwatch.currentElapsedTime()
        if abs(newElapsedTime - stopwatch.elapsedTime) > 0.05 {
            stopwatch.elapsedTime = newElapsedTime
            stopwatch.lastUpdated = Date()
        }
    }
}

// MARK: - TimeInterval Extension

private extension TimeInterval {
    /// Formatted elapsed time string (e.g., "1:23.45")
    var formattedElapsedTime: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        let fractionalPart = self.truncatingRemainder(dividingBy: 1)
        let milliseconds = Int((fractionalPart * 100).rounded())
        
        return String(format: "%d:%02d.%02d", minutes, seconds, milliseconds)
    }
}

