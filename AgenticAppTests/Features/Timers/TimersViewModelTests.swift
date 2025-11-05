//
//  TimersViewModelTests.swift
//  AgenticAppTests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest
import Combine
@testable import AgenticApp

final class TimersViewModelTests: XCTestCase {
    
    private var viewModel: TimersViewModel!
    private var mockTimerService: TimerServiceMock!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockTimerService = TimerServiceMock()
        viewModel = TimersViewModel(timerService: mockTimerService)
    }
    
    override func tearDown() {
        viewModel.onDisappear()
        viewModel = nil
        mockTimerService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        // Then
        XCTAssertTrue(viewModel.timers.isEmpty)
        XCTAssertNil(viewModel.activeTimer)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // MARK: - Load Tests
    
    func testLoadTimers() {
        // Given
        let timer1 = TimerModel(duration: 300, label: "Timer 1")
        let timer2 = TimerModel(duration: 600, label: "Timer 2")
        mockTimerService.timers = [timer1, timer2]
        
        // When
        viewModel.loadTimers()
        
        // Then
        XCTAssertEqual(viewModel.timers.count, 2)
        XCTAssertTrue(viewModel.timers.contains { $0.id == timer1.id })
        XCTAssertTrue(viewModel.timers.contains { $0.id == timer2.id })
    }
    
    func testLoadTimersSetsActiveTimer() {
        // Given
        var runningTimer = TimerModel(duration: 300)
        runningTimer.isRunning = true
        runningTimer.endTime = Date().addingTimeInterval(300)
        mockTimerService.timers = [runningTimer]
        
        // When
        viewModel.loadTimers()
        
        // Then
        XCTAssertNotNil(viewModel.activeTimer)
        XCTAssertEqual(viewModel.activeTimer?.id, runningTimer.id)
    }
    
    func testLoadTimersClearsErrorMessage() {
        // Given
        viewModel.errorMessage = "Previous error"
        
        // When
        viewModel.loadTimers()
        
        // Then
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // MARK: - Start Timer Tests
    
    func testStartNewTimer() {
        // Given
        let timer = TimerModel(duration: 300, label: "New Timer")
        
        // When
        viewModel.startNewTimer(timer)
        
        // Then
        XCTAssertEqual(mockTimerService.addTimerCallCount, 1)
        let addedTimer = mockTimerService.lastAddedTimer
        XCTAssertNotNil(addedTimer)
        XCTAssertTrue(addedTimer?.isRunning ?? false)
        XCTAssertEqual(addedTimer?.duration, 300)
        XCTAssertNotNil(addedTimer?.endTime)
    }
    
    func testStartNewTimerCancelsExistingActiveTimer() {
        // Given
        var activeTimer = TimerModel(duration: 300)
        activeTimer.isRunning = true
        mockTimerService.timers = [activeTimer]
        viewModel.loadTimers()
        
        let newTimer = TimerModel(duration: 600)
        
        // When
        viewModel.startNewTimer(newTimer)
        
        // Then
        XCTAssertEqual(mockTimerService.updateTimerCallCount, 1)
        let updatedTimer = mockTimerService.lastUpdatedTimer
        XCTAssertNotNil(updatedTimer)
        XCTAssertEqual(updatedTimer?.id, activeTimer.id)
        XCTAssertFalse(updatedTimer?.isRunning ?? true)
    }
    
    func testStartNewTimerSetsEndTime() {
        // Given
        let timer = TimerModel(duration: 300)
        let beforeStart = Date()
        
        // When
        viewModel.startNewTimer(timer)
        
        // Then
        let addedTimer = mockTimerService.lastAddedTimer
        XCTAssertNotNil(addedTimer?.endTime)
        if let endTime = addedTimer?.endTime {
            let expectedEndTime = beforeStart.addingTimeInterval(300)
            XCTAssertEqual(endTime.timeIntervalSince1970, expectedEndTime.timeIntervalSince1970, accuracy: 1.0)
        }
    }
    
    func testStartTimerFromRecent() {
        // Given
        let timer = TimerModel(duration: 300)
        
        // When
        viewModel.startTimerFromRecent(timer)
        
        // Then
        XCTAssertEqual(mockTimerService.addTimerCallCount, 1)
    }
    
    // MARK: - Cancel Timer Tests
    
    func testCancelActiveTimer() {
        // Given
        var timer = TimerModel(duration: 300)
        timer.isRunning = true
        timer.remainingTime = 150
        timer.endTime = Date().addingTimeInterval(150)
        mockTimerService.timers = [timer]
        viewModel.loadTimers()
        
        // When
        viewModel.cancelActiveTimer()
        
        // Then
        XCTAssertEqual(mockTimerService.updateTimerCallCount, 1)
        let updatedTimer = mockTimerService.lastUpdatedTimer
        XCTAssertNotNil(updatedTimer)
        XCTAssertFalse(updatedTimer?.isRunning ?? true)
        XCTAssertEqual(updatedTimer?.remainingTime, 300)
        XCTAssertNil(updatedTimer?.endTime)
        XCTAssertNil(viewModel.activeTimer)
    }
    
    func testCancelActiveTimerWhenNoActiveTimer() {
        // Given
        XCTAssertNil(viewModel.activeTimer)
        
        // When
        viewModel.cancelActiveTimer()
        
        // Then
        XCTAssertEqual(mockTimerService.updateTimerCallCount, 0)
    }
    
    // MARK: - Pause Timer Tests
    
    func testPauseActiveTimer() {
        // Given
        var timer = TimerModel(duration: 300)
        timer.isRunning = true
        timer.remainingTime = 150
        timer.endTime = Date().addingTimeInterval(150)
        mockTimerService.timers = [timer]
        viewModel.loadTimers()
        
        // When
        viewModel.pauseActiveTimer()
        
        // Then
        XCTAssertEqual(mockTimerService.updateTimerCallCount, 1)
        let updatedTimer = mockTimerService.lastUpdatedTimer
        XCTAssertNotNil(updatedTimer)
        XCTAssertFalse(updatedTimer?.isRunning ?? true)
        XCTAssertNil(updatedTimer?.endTime)
        XCTAssertNil(viewModel.activeTimer)
    }
    
    func testPauseActiveTimerWhenNoActiveTimer() {
        // Given
        XCTAssertNil(viewModel.activeTimer)
        
        // When
        viewModel.pauseActiveTimer()
        
        // Then
        XCTAssertEqual(mockTimerService.updateTimerCallCount, 0)
    }
    
    // MARK: - Resume Timer Tests
    
    func testResumeActiveTimer() {
        // Given
        var timer = TimerModel(duration: 300)
        timer.isRunning = false
        timer.remainingTime = 150
        mockTimerService.timers = [timer]
        viewModel.loadTimers()
        
        // Set activeTimer manually since loadTimers won't set it for non-running timer
        viewModel.activeTimer = timer
        
        // When
        viewModel.resumeActiveTimer()
        
        // Then
        XCTAssertEqual(mockTimerService.updateTimerCallCount, 1)
        let updatedTimer = mockTimerService.lastUpdatedTimer
        XCTAssertNotNil(updatedTimer)
        XCTAssertTrue(updatedTimer?.isRunning ?? false)
        XCTAssertNotNil(updatedTimer?.endTime)
    }
    
    func testResumeActiveTimerSetsEndTime() {
        // Given
        var timer = TimerModel(duration: 300)
        timer.isRunning = false
        timer.remainingTime = 150
        mockTimerService.timers = [timer]
        viewModel.loadTimers()
        viewModel.activeTimer = timer
        
        let beforeResume = Date()
        
        // When
        viewModel.resumeActiveTimer()
        
        // Then
        let updatedTimer = mockTimerService.lastUpdatedTimer
        XCTAssertNotNil(updatedTimer?.endTime)
        if let endTime = updatedTimer?.endTime {
            let expectedEndTime = beforeResume.addingTimeInterval(150)
            XCTAssertEqual(endTime.timeIntervalSince1970, expectedEndTime.timeIntervalSince1970, accuracy: 1.0)
        }
    }
    
    // MARK: - Add Timer Tests
    
    func testAddTimer() {
        // Given
        let timer = TimerModel(duration: 300)
        
        // When
        viewModel.addTimer(timer)
        
        // Then
        XCTAssertEqual(mockTimerService.addTimerCallCount, 1)
        XCTAssertEqual(mockTimerService.lastAddedTimer?.id, timer.id)
    }
    
    // MARK: - Update Timer Tests
    
    func testUpdateTimer() {
        // Given
        let timer = TimerModel(duration: 300, label: "Original")
        mockTimerService.timers = [timer]
        viewModel.loadTimers()
        
        var updatedTimer = timer
        updatedTimer.label = "Updated"
        
        // When
        viewModel.updateTimer(updatedTimer)
        
        // Then
        XCTAssertEqual(mockTimerService.updateTimerCallCount, 1)
        XCTAssertEqual(mockTimerService.lastUpdatedTimer?.label, "Updated")
    }
    
    func testUpdateTimerUpdatesActiveTimerIfRunning() {
        // Given
        var timer = TimerModel(duration: 300)
        timer.isRunning = true
        mockTimerService.timers = [timer]
        viewModel.loadTimers()
        
        var updatedTimer = timer
        updatedTimer.remainingTime = 150
        
        // When
        viewModel.updateTimer(updatedTimer)
        
        // Then
        XCTAssertEqual(viewModel.activeTimer?.remainingTime, 150)
    }
    
    // MARK: - Delete Timer Tests
    
    func testDeleteTimer() {
        // Given
        let timer = TimerModel(duration: 300)
        mockTimerService.timers = [timer]
        viewModel.loadTimers()
        
        // When
        viewModel.deleteTimer(timer)
        
        // Then
        XCTAssertEqual(mockTimerService.deleteTimerCallCount, 1)
        XCTAssertEqual(mockTimerService.lastDeletedTimerID, timer.id)
    }
    
    // MARK: - Toggle Timer Tests
    
    func testToggleTimerFromRunningToPaused() {
        // Given
        var timer = TimerModel(duration: 300)
        timer.isRunning = true
        timer.endTime = Date().addingTimeInterval(300)
        
        // When
        viewModel.toggleTimer(timer)
        
        // Then
        XCTAssertEqual(mockTimerService.updateTimerCallCount, 1)
        let updatedTimer = mockTimerService.lastUpdatedTimer
        XCTAssertNotNil(updatedTimer)
        XCTAssertFalse(updatedTimer?.isRunning ?? true)
        XCTAssertNil(updatedTimer?.endTime)
    }
    
    func testToggleTimerFromPausedToRunning() {
        // Given
        var timer = TimerModel(duration: 300)
        timer.isRunning = false
        
        // When
        viewModel.toggleTimer(timer)
        
        // Then
        XCTAssertEqual(mockTimerService.updateTimerCallCount, 1)
        let updatedTimer = mockTimerService.lastUpdatedTimer
        XCTAssertNotNil(updatedTimer)
        XCTAssertTrue(updatedTimer?.isRunning ?? false)
        XCTAssertNotNil(updatedTimer?.endTime)
    }
    
    // MARK: - Reset Timer Tests
    
    func testResetTimer() {
        // Given
        var timer = TimerModel(duration: 300)
        timer.isRunning = true
        timer.remainingTime = 150
        timer.endTime = Date().addingTimeInterval(150)
        
        // When
        viewModel.resetTimer(timer)
        
        // Then
        XCTAssertEqual(mockTimerService.updateTimerCallCount, 1)
        let updatedTimer = mockTimerService.lastUpdatedTimer
        XCTAssertNotNil(updatedTimer)
        XCTAssertFalse(updatedTimer?.isRunning ?? true)
        XCTAssertEqual(updatedTimer?.remainingTime, 300)
        XCTAssertNil(updatedTimer?.endTime)
    }
    
    // MARK: - Get Timer Tests
    
    func testGetTimer() {
        // Given
        let timer = TimerModel(duration: 300)
        mockTimerService.timers = [timer]
        viewModel.loadTimers()
        
        // When
        let retrievedTimer = viewModel.getTimer(id: timer.id)
        
        // Then
        XCTAssertNotNil(retrievedTimer)
        XCTAssertEqual(retrievedTimer?.id, timer.id)
    }
    
    func testGetTimerNotFound() {
        // When
        let timer = viewModel.getTimer(id: UUID())
        
        // Then
        XCTAssertNil(timer)
    }
    
    func testGetTimerFallsBackToService() {
        // Given
        let timer = TimerModel(duration: 300)
        mockTimerService.timers = [timer]
        // Don't load timers, so in-memory array is empty
        
        // When
        let retrievedTimer = viewModel.getTimer(id: timer.id)
        
        // Then
        XCTAssertNotNil(retrievedTimer)
        XCTAssertEqual(retrievedTimer?.id, timer.id)
        XCTAssertEqual(mockTimerService.getTimerCallCount, 1)
    }
    
    // MARK: - Recent Timers Tests
    
    func testRecentTimers() {
        // Given
        let timer1 = TimerModel(duration: 300, createdAt: Date().addingTimeInterval(-100))
        let timer2 = TimerModel(duration: 600, createdAt: Date().addingTimeInterval(-200))
        let timer3 = TimerModel(duration: 900, createdAt: Date().addingTimeInterval(-300))
        var runningTimer = TimerModel(duration: 1200, createdAt: Date().addingTimeInterval(-400))
        runningTimer.isRunning = true
        
        mockTimerService.timers = [timer1, timer2, timer3, runningTimer]
        viewModel.loadTimers()
        
        // When
        let recentTimers = viewModel.recentTimers
        
        // Then
        XCTAssertEqual(recentTimers.count, 3)
        XCTAssertFalse(recentTimers.contains { $0.isRunning })
        XCTAssertEqual(recentTimers.first?.id, timer1.id) // Most recent first
    }
    
    func testRecentTimersLimitedToFive() {
        // Given
        let timers = (0..<10).map { index in
            TimerModel(duration: 300, createdAt: Date().addingTimeInterval(-Double(index * 100)))
        }
        mockTimerService.timers = timers
        viewModel.loadTimers()
        
        // When
        let recentTimers = viewModel.recentTimers
        
        // Then
        XCTAssertEqual(recentTimers.count, 5)
    }
    
    func testRecentTimersEmptyWhenAllRunning() {
        // Given
        var timer1 = TimerModel(duration: 300)
        timer1.isRunning = true
        var timer2 = TimerModel(duration: 600)
        timer2.isRunning = true
        
        mockTimerService.timers = [timer1, timer2]
        viewModel.loadTimers()
        
        // When
        let recentTimers = viewModel.recentTimers
        
        // Then
        XCTAssertTrue(recentTimers.isEmpty)
    }
    
    // MARK: - Timer Updates Tests
    
    func testOnAppearStartsTimerUpdates() {
        // Given
        var timer = TimerModel(duration: 2) // Short timer for testing
        timer.isRunning = true
        timer.endTime = Date().addingTimeInterval(2)
        mockTimerService.timers = [timer]
        viewModel.loadTimers()
        
        let expectation = expectation(description: "Timer should update")
        expectation.expectedFulfillmentCount = 2
        
        viewModel.$timers
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewModel.onAppear()
        
        // Then
        wait(for: [expectation], timeout: 3.0)
        XCTAssertGreaterThanOrEqual(mockTimerService.updateTimerCallCount, 1)
    }
    
    func testOnDisappearStopsTimerUpdates() {
        // Given
        viewModel.onAppear()
        
        // When
        viewModel.onDisappear()
        
        // Then - timer should be stopped (no updates after brief delay)
        let expectation = expectation(description: "No updates after stop")
        expectation.isInverted = true
        
        viewModel.$timers
            .dropFirst()
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateRunningTimersDecrementsRemainingTime() {
        // Given
        var timer = TimerModel(duration: 10)
        timer.isRunning = true
        timer.remainingTime = 5
        timer.endTime = Date().addingTimeInterval(5)
        mockTimerService.timers = [timer]
        viewModel.loadTimers()
        
        viewModel.onAppear()
        
        // When - wait for timer update
        let expectation = expectation(description: "Timer should update")
        expectation.expectedFulfillmentCount = 1
        
        viewModel.$timers
            .dropFirst()
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
        
        // Then
        let updatedTimer = viewModel.timers.first { $0.id == timer.id }
        XCTAssertNotNil(updatedTimer)
        if let updated = updatedTimer {
            XCTAssertLessThan(updated.remainingTime, 5)
        }
    }
    
    func testTimerCompletionStopsTimer() {
        // Given
        var timer = TimerModel(duration: 1)
        timer.isRunning = true
        timer.remainingTime = 0.5
        timer.endTime = Date().addingTimeInterval(0.5)
        mockTimerService.timers = [timer]
        viewModel.loadTimers()
        
        viewModel.onAppear()
        
        // When - wait for timer to complete
        let expectation = expectation(description: "Timer should complete")
        expectation.expectedFulfillmentCount = 1
        
        viewModel.$timers
            .dropFirst()
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 2.0)
        
        // Then - wait a bit more for completion
        Thread.sleep(forTimeInterval: 1.0)
        
        let completedTimer = viewModel.timers.first { $0.id == timer.id }
        XCTAssertNotNil(completedTimer)
        if let completed = completedTimer {
            XCTAssertFalse(completed.isRunning)
            XCTAssertEqual(completed.remainingTime, completed.duration)
            XCTAssertNil(completed.endTime)
        }
    }
    
    // MARK: - Published Properties Tests
    
    func testTimersIsPublished() {
        // Given
        let expectation = expectation(description: "Timers should be published")
        var receivedTimers: [TimerModel] = []
        
        viewModel.$timers
            .sink { timers in
                receivedTimers = timers
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        wait(for: [expectation], timeout: 0.1)
        
        // Then
        XCTAssertNotNil(receivedTimers)
    }
    
    func testActiveTimerIsPublished() {
        // Given
        var timer = TimerModel(duration: 300)
        timer.isRunning = true
        mockTimerService.timers = [timer]
        
        let expectation = expectation(description: "Active timer should be published")
        var receivedActiveTimer: TimerModel?
        
        viewModel.$activeTimer
            .dropFirst()
            .sink { activeTimer in
                receivedActiveTimer = activeTimer
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewModel.loadTimers()
        
        // Then
        wait(for: [expectation], timeout: 0.1)
        XCTAssertNotNil(receivedActiveTimer)
    }
}