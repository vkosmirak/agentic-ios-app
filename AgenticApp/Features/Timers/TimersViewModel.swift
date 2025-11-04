//
//  TimersViewModel.swift
//  AgenticApp
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import Foundation
import Combine
import UserNotifications

/// ViewModel for the Timers feature
final class TimersViewModel: ViewModel {
    @Published var timers: [TimerModel] = []
    @Published var activeTimer: TimerModel?
    @Published var errorMessage: String?
    
    var cancellables: Set<AnyCancellable> = []
    
    private let timerService: TimerServiceProtocol
    private var updateTimer: Timer?
    
    init(timerService: TimerServiceProtocol) {
        self.timerService = timerService
    }
    
    deinit {
        stopTimerUpdates()
    }
    
    func onAppear() {
        loadTimers()
        startTimerUpdates()
    }
    
    func onDisappear() {
        stopTimerUpdates()
    }
    
    // MARK: - Computed Properties
    
    /// Recent timers (non-running, sorted by creation date, limit 5)
    var recentTimers: [TimerModel] {
        timers
            .filter { !$0.isRunning }
            .sorted { $0.createdAt > $1.createdAt }
            .prefix(5)
            .map { $0 }
    }
    
    // MARK: - Public Methods
    
    /// Loads timers from the service
    func loadTimers() {
        timers = timerService.loadTimers()
        // Find active timer (running timer)
        activeTimer = timers.first { $0.isRunning }
        // Clear any previous error messages
        errorMessage = nil
    }
    
    /// Starts a new timer
    func startNewTimer(_ timer: TimerModel) {
        // Cancel any existing active timer
        if let existingActive = activeTimer {
            cancelTimer(existingActive)
        }
        
        // Create and start new timer
        var newTimer = timer
        newTimer.isRunning = true
        newTimer.endTime = Date().addingTimeInterval(newTimer.remainingTime)
        
        timerService.addTimer(newTimer)
        loadTimers()
    }
    
    /// Starts a timer from recent list
    func startTimerFromRecent(_ timer: TimerModel) {
        startNewTimer(timer)
    }
    
    /// Cancels the active timer
    func cancelActiveTimer() {
        guard let active = activeTimer else { return }
        // Find the timer in the array by ID to ensure we have the latest version
        guard let index = timers.firstIndex(where: { $0.id == active.id }) else { return }
        
        // Use a transaction-like approach: update and persist atomically
        var updatedTimer = timers[index]
        updatedTimer.isRunning = false
        updatedTimer.remainingTime = updatedTimer.duration
        updatedTimer.endTime = nil
        
        // Persist first, then update state
        timerService.updateTimer(updatedTimer)
        
        // Update state after persistence
        timers[index] = updatedTimer
        activeTimer = nil
    }
    
    /// Pauses the active timer
    func pauseActiveTimer() {
        guard let active = activeTimer else { return }
        // Find the timer in the array by ID to ensure we have the latest version
        guard let index = timers.firstIndex(where: { $0.id == active.id }) else { return }
        
        var updatedTimer = timers[index]
        updatedTimer.isRunning = false
        updatedTimer.endTime = nil
        
        timerService.updateTimer(updatedTimer)
        loadTimers()
        // Update activeTimer reference after pause
        activeTimer = nil
    }
    
    /// Resumes the active timer
    func resumeActiveTimer() {
        guard let active = activeTimer else { return }
        // Find the timer in the array by ID to ensure we have the latest version
        guard let index = timers.firstIndex(where: { $0.id == active.id }) else { return }
        
        var updatedTimer = timers[index]
        updatedTimer.isRunning = true
        updatedTimer.endTime = Date().addingTimeInterval(updatedTimer.remainingTime)
        
        timerService.updateTimer(updatedTimer)
        loadTimers()
        // Update activeTimer reference after resume
        activeTimer = timers.first { $0.id == updatedTimer.id && $0.isRunning }
    }
    
    /// Adds a new timer (for persistence)
    func addTimer(_ timer: TimerModel) {
        timerService.addTimer(timer)
        loadTimers()
    }
    
    /// Updates an existing timer
    func updateTimer(_ timer: TimerModel) {
        timerService.updateTimer(timer)
        loadTimers()
        // Ensure activeTimer is properly synced
        activeTimer = timers.first { $0.id == timer.id && $0.isRunning }
    }
    
    /// Deletes a timer
    func deleteTimer(_ timer: TimerModel) {
        timerService.deleteTimer(id: timer.id)
        loadTimers()
    }
    
    /// Starts or pauses a timer
    func toggleTimer(_ timer: TimerModel) {
        var updatedTimer = timer
        
        if timer.isRunning {
            // Pause: save remaining time
            updatedTimer.isRunning = false
            updatedTimer.endTime = nil
        } else {
            // Start: calculate end time
            updatedTimer.isRunning = true
            updatedTimer.endTime = Date().addingTimeInterval(updatedTimer.remainingTime)
        }
        
        updateTimer(updatedTimer)
    }
    
    /// Resets a timer to its original duration
    func resetTimer(_ timer: TimerModel) {
        var updatedTimer = timer
        updatedTimer.isRunning = false
        updatedTimer.remainingTime = updatedTimer.duration
        updatedTimer.endTime = nil
        updateTimer(updatedTimer)
    }
    
    /// Cancels a timer (stops and resets) - used internally
    private func cancelTimer(_ timer: TimerModel) {
        guard let index = timers.firstIndex(where: { $0.id == timer.id }) else { return }
        
        var updatedTimer = timers[index]
        updatedTimer.isRunning = false
        updatedTimer.remainingTime = updatedTimer.duration
        updatedTimer.endTime = nil
        
        timerService.updateTimer(updatedTimer)
        loadTimers()
        activeTimer = nil
    }
    
    /// Gets timer by ID
    func getTimer(id: UUID) -> TimerModel? {
        // Check in-memory array first
        return timers.first { $0.id == id } ?? timerService.getTimer(id: id)
    }
    
    // MARK: - Private Methods
    
    /// Starts periodic timer updates for running timers
    private func startTimerUpdates() {
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateRunningTimers()
        }
    }
    
    /// Stops timer updates
    private func stopTimerUpdates() {
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    /// Updates remaining time for running timers
    private func updateRunningTimers() {
        var hasChanges = false
        var updatedTimers = timers
        var timersToPersist: [TimerModel] = []
        
        for (index, timer) in updatedTimers.enumerated() {
            if timer.isRunning, let endTime = timer.endTime {
                let now = Date()
                let remaining = max(0, endTime.timeIntervalSince(now))
                
                var timerChanged = false
                
                if remaining != timer.remainingTime {
                    updatedTimers[index].remainingTime = remaining
                    hasChanges = true
                    timerChanged = true
                }
                
                // Timer finished
                if remaining <= 0 {
                    updatedTimers[index].isRunning = false
                    updatedTimers[index].remainingTime = timer.duration
                    updatedTimers[index].endTime = nil
                    hasChanges = true
                    timerChanged = true
                    
                    // Trigger timer completion notification
                    scheduleTimerCompletionNotification(for: updatedTimers[index])
                }
                
                // Track timers that changed and need persistence
                if timerChanged {
                    timersToPersist.append(updatedTimers[index])
                }
            }
        }
        
        if hasChanges {
            timers = updatedTimers
            activeTimer = timers.first { $0.isRunning }
            
            // Only persist changed timers, not all timers
            for timer in timersToPersist {
                timerService.updateTimer(timer)
            }
        }
    }
    
    /// Schedules a local notification for timer completion
    private func scheduleTimerCompletionNotification(for timer: TimerModel) {
        let content = UNMutableNotificationContent()
        content.title = timer.label ?? "Timer"
        content.body = "Timer completed"
        // Use default sound for now - custom sound names would need to be mapped to actual sound files
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: timer.id.uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("⚠️ Failed to schedule timer notification: \(error.localizedDescription)")
            }
        }
    }
}

