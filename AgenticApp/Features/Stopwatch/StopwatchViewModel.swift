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
    @Published var elapsedTime: TimeInterval = 0
    @Published var laps: [Lap] = []
    @Published var isRunning: Bool = false
    
    var cancellables: Set<AnyCancellable> = []
    
    private let stopwatchService: StopwatchServiceProtocol
    private var updateTimer: Timer?
    private var startTime: Date?
    private var pausedTime: TimeInterval = 0
    
    // MARK: - Constants
    
    private enum Constants {
        /// Timer update interval for smooth centisecond display (10ms)
        static let timerUpdateInterval: TimeInterval = 0.01
    }
    
    init(stopwatchService: StopwatchServiceProtocol) {
        self.stopwatchService = stopwatchService
    }
    
    deinit {
        stopTimerUpdates()
    }
    
    func onAppear() {
        // No-op: stopwatch starts fresh each time
    }
    
    func onDisappear() {
        stopTimerUpdates()
    }
    
    // MARK: - Computed Properties
    
    /// Formatted elapsed time (MM:SS,HH format)
    var formattedTime: String {
        elapsedTime.formattedStopwatchTime()
    }
    
    /// Fastest lap (shortest lap time)
    var fastestLap: Lap? {
        guard !laps.isEmpty else { return nil }
        return laps.min(by: { $0.lapTime < $1.lapTime })
    }
    
    /// Slowest lap (longest lap time)
    var slowestLap: Lap? {
        guard !laps.isEmpty else { return nil }
        return laps.max(by: { $0.lapTime < $1.lapTime })
    }
    
    // MARK: - Public Methods
    
    /// Starts the stopwatch
    func start() {
        guard !isRunning else { return }
        
        // Validate state before starting
        guard pausedTime >= 0 else {
            // Reset if paused time is invalid
            reset()
            return
        }
        
        isRunning = true
        startTime = Date()
        startTimerUpdates()
    }
    
    /// Stops the stopwatch
    func stop() {
        guard isRunning else { return }
        isRunning = false
        stopTimerUpdates()
        
        // Save paused time
        if let start = startTime {
            pausedTime += Date().timeIntervalSince(start)
        }
        startTime = nil
    }
    
    /// Records a lap time
    func lap() {
        guard isRunning else { return }
        
        // Calculate current elapsed time
        let currentElapsed: TimeInterval
        if let start = startTime {
            currentElapsed = pausedTime + Date().timeIntervalSince(start)
        } else {
            currentElapsed = pausedTime
        }
        
        // Validate elapsed time is non-negative
        guard currentElapsed >= 0 else { return }
        
        // Calculate lap time
        let previousLapTime = laps.last?.time ?? 0
        let lapTime = currentElapsed - previousLapTime
        
        // Validate lap time is non-negative
        guard lapTime >= 0 else { return }
        
        // Create new lap
        let newLap = Lap(
            lapNumber: laps.count + 1,
            time: currentElapsed,
            lapTime: lapTime
        )
        
        laps.append(newLap)
    }
    
    /// Resets the stopwatch
    func reset() {
        isRunning = false
        stopTimerUpdates()
        elapsedTime = 0
        laps = []
        startTime = nil
        pausedTime = 0
    }
    
    // MARK: - Private Methods
    
    /// Starts periodic timer updates (every 10ms for smooth centisecond display)
    private func startTimerUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: Constants.timerUpdateInterval, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateElapsedTime()
            }
        }
        
        guard let timer = updateTimer else { return }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    /// Stops timer updates
    private func stopTimerUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    /// Updates elapsed time based on current state
    private func updateElapsedTime() {
        guard isRunning, let start = startTime else { return }
        elapsedTime = pausedTime + Date().timeIntervalSince(start)
    }
}

