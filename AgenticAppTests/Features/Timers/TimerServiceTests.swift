//
//  TimerServiceTests.swift
//  AgenticAppTests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest
@testable import AgenticApp

final class TimerServiceTests: XCTestCase {
    
    private var timerService: TimerService!
    private var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        // Use a separate UserDefaults suite for testing to avoid conflicts
        userDefaults = UserDefaults(suiteName: "com.readdle.AgenticApp.tests")
        userDefaults?.removePersistentDomain(forName: "com.readdle.AgenticApp.tests")
        timerService = TimerService(userDefaults: userDefaults)
    }
    
    override func tearDown() {
        // Clean up test data
        userDefaults?.removePersistentDomain(forName: "com.readdle.AgenticApp.tests")
        timerService = nil
        userDefaults = nil
        super.tearDown()
    }
    
    // MARK: - Load Tests
    
    func testLoadTimersEmpty() {
        // When
        let timers = timerService.loadTimers()
        
        // Then
        XCTAssertTrue(timers.isEmpty)
    }
    
    func testLoadTimers() {
        // Given
        let timer1 = TimerModel(duration: 300, label: "Timer 1")
        let timer2 = TimerModel(duration: 600, label: "Timer 2")
        timerService.addTimer(timer1)
        timerService.addTimer(timer2)
        
        // When
        let loadedTimers = timerService.loadTimers()
        
        // Then
        XCTAssertEqual(loadedTimers.count, 2)
        XCTAssertTrue(loadedTimers.contains { $0.id == timer1.id })
        XCTAssertTrue(loadedTimers.contains { $0.id == timer2.id })
    }
    
    // MARK: - Add Tests
    
    func testAddTimer() {
        // Given
        let timer = TimerModel(duration: 300, label: "Test Timer")
        
        // When
        timerService.addTimer(timer)
        
        // Then
        let timers = timerService.loadTimers()
        XCTAssertEqual(timers.count, 1)
        XCTAssertEqual(timers.first?.id, timer.id)
        XCTAssertEqual(timers.first?.duration, timer.duration)
        XCTAssertEqual(timers.first?.label, timer.label)
    }
    
    func testAddMultipleTimers() {
        // Given
        let timer1 = TimerModel(duration: 300)
        let timer2 = TimerModel(duration: 600)
        let timer3 = TimerModel(duration: 900)
        
        // When
        timerService.addTimer(timer1)
        timerService.addTimer(timer2)
        timerService.addTimer(timer3)
        
        // Then
        let timers = timerService.loadTimers()
        XCTAssertEqual(timers.count, 3)
    }
    
    // MARK: - Update Tests
    
    func testUpdateTimer() {
        // Given
        let timer = TimerModel(duration: 300, label: "Original")
        timerService.addTimer(timer)
        
        // When
        var updatedTimer = timer
        updatedTimer.label = "Updated"
        updatedTimer.duration = 600
        timerService.updateTimer(updatedTimer)
        
        // Then
        let timers = timerService.loadTimers()
        XCTAssertEqual(timers.count, 1)
        XCTAssertEqual(timers.first?.id, timer.id)
        XCTAssertEqual(timers.first?.label, "Updated")
        XCTAssertEqual(timers.first?.duration, 600)
    }
    
    func testUpdateTimerNotInList() {
        // Given
        let timer = TimerModel(duration: 300)
        let nonExistentTimer = TimerModel(duration: 600)
        
        timerService.addTimer(timer)
        
        // When
        timerService.updateTimer(nonExistentTimer)
        
        // Then
        let timers = timerService.loadTimers()
        XCTAssertEqual(timers.count, 1)
        XCTAssertEqual(timers.first?.id, timer.id)
        XCTAssertEqual(timers.first?.duration, 300)
    }
    
    func testUpdateTimerPreservesOtherTimers() {
        // Given
        let timer1 = TimerModel(duration: 300, label: "Timer 1")
        let timer2 = TimerModel(duration: 600, label: "Timer 2")
        timerService.addTimer(timer1)
        timerService.addTimer(timer2)
        
        // When
        var updatedTimer = timer1
        updatedTimer.label = "Updated Timer 1"
        timerService.updateTimer(updatedTimer)
        
        // Then
        let timers = timerService.loadTimers()
        XCTAssertEqual(timers.count, 2)
        let updated = timers.first { $0.id == timer1.id }
        let unchanged = timers.first { $0.id == timer2.id }
        XCTAssertEqual(updated?.label, "Updated Timer 1")
        XCTAssertEqual(unchanged?.label, "Timer 2")
    }
    
    // MARK: - Delete Tests
    
    func testDeleteTimer() {
        // Given
        let timer = TimerModel(duration: 300)
        timerService.addTimer(timer)
        
        // When
        timerService.deleteTimer(id: timer.id)
        
        // Then
        let timers = timerService.loadTimers()
        XCTAssertTrue(timers.isEmpty)
    }
    
    func testDeleteTimerById() {
        // Given
        let timer1 = TimerModel(duration: 300)
        let timer2 = TimerModel(duration: 600)
        timerService.addTimer(timer1)
        timerService.addTimer(timer2)
        
        // When
        timerService.deleteTimer(id: timer1.id)
        
        // Then
        let timers = timerService.loadTimers()
        XCTAssertEqual(timers.count, 1)
        XCTAssertEqual(timers.first?.id, timer2.id)
    }
    
    func testDeleteTimerNotInList() {
        // Given
        let timer = TimerModel(duration: 300)
        timerService.addTimer(timer)
        
        // When
        timerService.deleteTimer(id: UUID())
        
        // Then
        let timers = timerService.loadTimers()
        XCTAssertEqual(timers.count, 1)
    }
    
    // MARK: - Get Tests
    
    func testGetTimer() {
        // Given
        let timer = TimerModel(duration: 300, label: "Test")
        timerService.addTimer(timer)
        
        // When
        let retrievedTimer = timerService.getTimer(id: timer.id)
        
        // Then
        XCTAssertNotNil(retrievedTimer)
        XCTAssertEqual(retrievedTimer?.id, timer.id)
        XCTAssertEqual(retrievedTimer?.duration, timer.duration)
        XCTAssertEqual(retrievedTimer?.label, timer.label)
    }
    
    func testGetTimerNotFound() {
        // When
        let timer = timerService.getTimer(id: UUID())
        
        // Then
        XCTAssertNil(timer)
    }
    
    // MARK: - Persistence Tests
    
    func testSaveTimers() {
        // Given
        let timer1 = TimerModel(duration: 300)
        let timer2 = TimerModel(duration: 600)
        let timers = [timer1, timer2]
        
        // When
        timerService.saveTimers(timers)
        
        // Then
        let loadedTimers = timerService.loadTimers()
        XCTAssertEqual(loadedTimers.count, 2)
        XCTAssertTrue(loadedTimers.contains { $0.id == timer1.id })
        XCTAssertTrue(loadedTimers.contains { $0.id == timer2.id })
    }
    
    func testSaveTimersOverwritesExisting() {
        // Given
        let timer1 = TimerModel(duration: 300)
        timerService.addTimer(timer1)
        
        let timer2 = TimerModel(duration: 600)
        let timer3 = TimerModel(duration: 900)
        
        // When
        timerService.saveTimers([timer2, timer3])
        
        // Then
        let timers = timerService.loadTimers()
        XCTAssertEqual(timers.count, 2)
        XCTAssertTrue(timers.contains { $0.id == timer2.id })
        XCTAssertTrue(timers.contains { $0.id == timer3.id })
        XCTAssertFalse(timers.contains { $0.id == timer1.id })
    }
}

