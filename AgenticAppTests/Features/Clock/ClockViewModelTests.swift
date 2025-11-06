//
//  ClockViewModelTests.swift
//  AgenticAppTests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest
import Combine
@testable import AgenticApp
import Foundation

final class ClockViewModelTests: XCTestCase {
    
    // MARK: - Constants
    private let timerTimeout: TimeInterval = 3.0
    private let timerCancellationTimeout: TimeInterval = 2.0
    private let publishedPropertyTimeout: TimeInterval = 0.1
    
    private var viewModel: ClockViewModel!
    private var mockTimeService: TimeServiceMock!
    private var mockClockService: ClockServiceMock!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockTimeService = TimeServiceMock()
        mockClockService = ClockServiceMock()
        viewModel = ClockViewModel(timeService: mockTimeService, clockService: mockClockService)
    }
    
    override func tearDown() {
        viewModel.onDisappear()
        viewModel = nil
        mockTimeService = nil
        mockClockService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() {
        // Then
        XCTAssertFalse(viewModel.clocks.isEmpty)
        XCTAssertEqual(viewModel.clocks.count, ClockModel.defaultClocks.count)
    }
    
    func testInitializationWithCustomTimeZone() {
        // Given
        let customTimeZone = TimeZone(identifier: "Europe/Paris")!
        let customTimeService = TimeServiceMock()
        let customClockService = ClockServiceMock()
        
        // When - use fresh mock services with custom timezone
        let customViewModel = ClockViewModel(timeService: customTimeService, clockService: customClockService, localTimeZone: customTimeZone)
        
        // Then - just verify initialization completes without crashing
        XCTAssertNotNil(customViewModel)
        XCTAssertFalse(customViewModel.clocks.isEmpty)
        
        // Cleanup - ensure timer is stopped before deallocation
        customViewModel.onDisappear()
    }
    
    func testInitializationWithCustomTimeZoneSetsClocks() {
        // Given
        let customTimeZone = TimeZone(identifier: "Europe/Paris")!
        let customTimeService = TimeServiceMock()
        let customClockService = ClockServiceMock()
        
        // When - use fresh mock services with custom timezone
        let customViewModel = ClockViewModel(timeService: customTimeService, clockService: customClockService, localTimeZone: customTimeZone)
        
        // Then
        XCTAssertFalse(customViewModel.clocks.isEmpty)
        XCTAssertEqual(customViewModel.clocks.count, ClockModel.defaultClocks.count)
        
        // Cleanup
        customViewModel.onDisappear()
    }
    
    // MARK: - Lifecycle Tests
    
    func testOnAppearStartsTimer() {
        // Given
        let expectation = expectation(description: "Timer should update currentDate")
        expectation.expectedFulfillmentCount = 2
        var dateUpdates: [Date] = []
        
        viewModel.$currentDate
            .dropFirst() // Skip initial value
            .sink { date in
                dateUpdates.append(date)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewModel.onAppear()
        
        // Then
        wait(for: [expectation], timeout: timerTimeout)
        XCTAssertTrue(dateUpdates.count >= 2, "Timer should fire at least twice")
        
        // Verify dates are different (timer is updating)
        XCTAssertNotEqual(dateUpdates[0], dateUpdates[1], "Timer should update dates")
    }
    
    func testOnDisappearCancelsTimer() {
        // Given
        viewModel.onAppear()
        
        // Wait briefly to ensure timer starts and fires at least once
        let initialExpectation = expectation(description: "Timer should fire initially")
        var initialDate: Date?
        viewModel.$currentDate
            .dropFirst()
            .sink { date in
                initialDate = date
                initialExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [initialExpectation], timeout: 1.5)
        
        // Capture date after timer has fired
        guard let beforeDisappearDate = initialDate else {
            XCTFail("Timer should have fired at least once")
            return
        }
        
        // When - cancel timer
        viewModel.onDisappear()
        
        // Then - verify timer was cancelled using inverted expectation
        let noUpdateExpectation = expectation(description: "Timer should not update after cancellation")
        noUpdateExpectation.isInverted = true
        
        let lastElapsedTime = viewModel.currentDate.timeIntervalSince1970
        viewModel.$currentDate
            .dropFirst()
            .sink { date in
                let timeDifference = abs(date.timeIntervalSince1970 - lastElapsedTime)
                if timeDifference > 0.5 {
                    noUpdateExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        wait(for: [noUpdateExpectation], timeout: timerCancellationTimeout)
        
        // Verify date hasn't changed significantly (timer stopped)
        let afterDisappearDate = viewModel.currentDate
        let timeDifference = abs(afterDisappearDate.timeIntervalSince(beforeDisappearDate))
        // Date should not have updated more than a small amount (timer stopped)
        XCTAssertLessThan(timeDifference, 0.5, "Date should not update significantly after timer cancellation")
    }
    
    // MARK: - Load Clocks Tests
    
    func testLoadClocks() {
        // Given
        let clock1 = ClockModel(cityName: "Paris", timeZoneIdentifier: "Europe/Paris")
        let clock2 = ClockModel(cityName: "Berlin", timeZoneIdentifier: "Europe/Berlin")
        mockClockService.clocks = [clock1, clock2]
        
        // When
        viewModel.loadClocks()
        
        // Then
        XCTAssertEqual(viewModel.clocks.count, 2)
        XCTAssertTrue(viewModel.clocks.contains { $0.id == clock1.id })
        XCTAssertTrue(viewModel.clocks.contains { $0.id == clock2.id })
    }
    
    func testLoadClocksUsesDefaultsWhenEmpty() {
        // Given - create a fresh mock service with empty clocks
        let freshClockService = ClockServiceMock()
        freshClockService.clocks = []
        let freshTimeService = TimeServiceMock()
        
        // When - init will call loadClocks, which should set defaults
        let freshViewModel = ClockViewModel(timeService: freshTimeService, clockService: freshClockService)
        
        // Then
        XCTAssertEqual(freshViewModel.clocks.count, ClockModel.defaultClocks.count)
        XCTAssertEqual(freshClockService.saveClocksCallCount, 1)
        
        // Cleanup
        freshViewModel.onDisappear()
    }
    
    func testLoadClocksCalledOnAppear() {
        // Given
        let initialCallCount = mockClockService.loadClocksCallCount
        
        // When
        viewModel.onAppear()
        
        // Then
        XCTAssertGreaterThan(mockClockService.loadClocksCallCount, initialCallCount)
    }
    
    // MARK: - Add Clock Tests
    
    func testAddClock() {
        // Given
        // ViewModel init already loaded defaults and saved them to mock service
        // Verify initial state - mock should have defaults after init
        let initialCount = viewModel.clocks.count
        XCTAssertEqual(initialCount, ClockModel.defaultClocks.count)
        XCTAssertEqual(mockClockService.clocks.count, ClockModel.defaultClocks.count, "Mock service should have defaults saved after init")
        
        // Use a city that's not in defaults to avoid duplicate check
        let clock = ClockModel(cityName: "Paris", timeZoneIdentifier: "Europe/Paris")
        
        // When
        viewModel.addClock(clock)
        
        // Then
        XCTAssertEqual(mockClockService.addClockCallCount, 1)
        XCTAssertEqual(mockClockService.lastAddedClock?.id, clock.id)
        XCTAssertEqual(mockClockService.clocks.count, initialCount + 1, "Mock service should have the new clock added")
        XCTAssertEqual(viewModel.clocks.count, initialCount + 1, "ViewModel should have the new clock after reload")
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testAddClockReloadsClocks() {
        // Given
        let clock = ClockModel(cityName: "Moscow", timeZoneIdentifier: "Europe/Moscow")
        let initialLoadCount = mockClockService.loadClocksCallCount
        
        // When
        viewModel.addClock(clock)
        
        // Then
        XCTAssertGreaterThan(mockClockService.loadClocksCallCount, initialLoadCount)
    }
    
    func testAddClockSetsErrorMessageOnError() {
        // Given
        mockClockService.shouldThrowErrorOnAdd = true
        let clock = ClockModel(cityName: "Test", timeZoneIdentifier: "America/New_York")
        
        // When
        viewModel.addClock(clock)
        
        // Then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Failed to add clock. Please try again.")
    }
    
    func testAddClockClearsErrorMessageOnSuccess() {
        // Given
        viewModel.errorMessage = "Previous error"
        let clock = ClockModel(cityName: "Paris", timeZoneIdentifier: "Europe/Paris")
        
        // When
        viewModel.addClock(clock)
        
        // Then
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // MARK: - Delete Clock Tests
    
    func testDeleteClock() {
        // Given
        let clock = ClockModel(cityName: "London", timeZoneIdentifier: "Europe/London")
        mockClockService.clocks = ClockModel.defaultClocks + [clock]
        viewModel.loadClocks()
        let initialCount = viewModel.clocks.count
        
        // When
        viewModel.deleteClock(clock)
        
        // Then
        XCTAssertEqual(mockClockService.deleteClockCallCount, 1)
        XCTAssertEqual(mockClockService.lastDeletedClockID, clock.id)
        XCTAssertEqual(viewModel.clocks.count, initialCount - 1)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testDeleteClockReloadsClocks() {
        // Given
        let clock = ClockModel(cityName: "Sydney", timeZoneIdentifier: "Australia/Sydney")
        mockClockService.clocks = ClockModel.defaultClocks + [clock]
        viewModel.loadClocks()
        let initialLoadCount = mockClockService.loadClocksCallCount
        
        // When
        viewModel.deleteClock(clock)
        
        // Then
        XCTAssertGreaterThan(mockClockService.loadClocksCallCount, initialLoadCount)
    }
    
    func testDeleteClockSetsErrorMessageOnError() {
        // Given
        mockClockService.shouldThrowErrorOnDelete = true
        let clock = ClockModel(cityName: "Test", timeZoneIdentifier: "America/New_York")
        
        // When
        viewModel.deleteClock(clock)
        
        // Then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Failed to delete clock. Please try again.")
    }
    
    func testDeleteClockClearsErrorMessageOnSuccess() {
        // Given
        let clock = ClockModel(cityName: "Berlin", timeZoneIdentifier: "Europe/Berlin")
        mockClockService.clocks = ClockModel.defaultClocks + [clock]
        viewModel.loadClocks()
        viewModel.errorMessage = "Previous error"
        
        // When
        viewModel.deleteClock(clock)
        
        // Then
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // MARK: - Delete Clocks Tests
    
    func testDeleteClocks() {
        // Given
        let clock1 = ClockModel(cityName: "Paris", timeZoneIdentifier: "Europe/Paris")
        let clock2 = ClockModel(cityName: "Berlin", timeZoneIdentifier: "Europe/Berlin")
        mockClockService.clocks = ClockModel.defaultClocks + [clock1, clock2]
        viewModel.loadClocks()
        let initialCount = viewModel.clocks.count
        
        // When
        viewModel.deleteClocks([clock1, clock2])
        
        // Then
        XCTAssertEqual(mockClockService.deleteClocksCallCount, 1)
        XCTAssertEqual(mockClockService.lastDeletedClockIDs?.count, 2)
        XCTAssertTrue(mockClockService.lastDeletedClockIDs?.contains(clock1.id) ?? false)
        XCTAssertTrue(mockClockService.lastDeletedClockIDs?.contains(clock2.id) ?? false)
        XCTAssertEqual(viewModel.clocks.count, initialCount - 2)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testDeleteClocksReloadsClocks() {
        // Given
        let clock = ClockModel(cityName: "Tokyo", timeZoneIdentifier: "Asia/Tokyo")
        mockClockService.clocks = ClockModel.defaultClocks + [clock]
        viewModel.loadClocks()
        let initialLoadCount = mockClockService.loadClocksCallCount
        
        // When
        viewModel.deleteClocks([clock])
        
        // Then
        XCTAssertGreaterThan(mockClockService.loadClocksCallCount, initialLoadCount)
    }
    
    func testDeleteClocksSetsErrorMessageOnError() {
        // Given
        mockClockService.shouldThrowErrorOnDeleteMultiple = true
        let clock = ClockModel(cityName: "Test", timeZoneIdentifier: "America/New_York")
        
        // When
        viewModel.deleteClocks([clock])
        
        // Then
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Failed to delete clocks. Please try again.")
    }
    
    func testDeleteClocksClearsErrorMessageOnSuccess() {
        // Given
        let clock = ClockModel(cityName: "Moscow", timeZoneIdentifier: "Europe/Moscow")
        mockClockService.clocks = ClockModel.defaultClocks + [clock]
        viewModel.loadClocks()
        viewModel.errorMessage = "Previous error"
        
        // When
        viewModel.deleteClocks([clock])
        
        // Then
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // MARK: - Formatted Time Tests
    
    func testFormattedTime() {
        // Given
        let testTimeZone = TimeZone(identifier: "America/New_York")!
        let clock = ClockModel(cityName: "New York", timeZone: testTimeZone)
        let expectedFormattedTime = "12:00 PM"
        
        mockTimeService.formattedTimeResult = expectedFormattedTime
        
        // When
        let formattedTime = viewModel.formattedTime(for: clock)
        
        // Then
        XCTAssertEqual(formattedTime, expectedFormattedTime)
        XCTAssertEqual(mockTimeService.lastFormattedDate, viewModel.currentDate)
        XCTAssertEqual(mockTimeService.lastFormattedTimeZone, testTimeZone)
    }
    
    // MARK: - Time Difference Tests
    
    func testTimeDifference() {
        // Given
        let localTimeZone = TimeZone(identifier: "America/Los_Angeles")!
        let targetTimeZone = TimeZone(identifier: "America/New_York")!
        let clock = ClockModel(cityName: "New York", timeZone: targetTimeZone)
        let expectedDifference = "3 hours ahead"
        
        let customTimeService = TimeServiceMock()
        customTimeService.timeDifferenceResult = expectedDifference
        let customClockService = ClockServiceMock()
        
        // When - use fresh mock services with custom timezone
        let customViewModel = ClockViewModel(timeService: customTimeService, clockService: customClockService, localTimeZone: localTimeZone)
        let difference = customViewModel.timeDifference(for: clock)
        
        // Then
        XCTAssertEqual(difference, expectedDifference)
        XCTAssertEqual(customTimeService.lastDifferenceSource, localTimeZone)
        XCTAssertEqual(customTimeService.lastDifferenceTarget, targetTimeZone)
        
        // Cleanup
        customViewModel.onDisappear()
    }
    
    // MARK: - Published Properties Tests
    
    func testClocksPropertyIsPublished() {
        // Given
        let expectation = expectation(description: "Clocks should be published")
        var receivedClocks: [ClockModel] = []
        
        viewModel.$clocks
            .sink { clocks in
                receivedClocks = clocks
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        wait(for: [expectation], timeout: publishedPropertyTimeout)
        
        // Then
        XCTAssertFalse(receivedClocks.isEmpty, "Published clocks should not be empty")
    }
    
    func testCurrentDateIsPublished() {
        // Given
        let expectation = expectation(description: "Current date should be published")
        
        viewModel.$currentDate
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        wait(for: [expectation], timeout: publishedPropertyTimeout)
        
        // Then
        XCTAssertNotNil(viewModel.currentDate)
    }
    
    func testErrorMessageIsPublished() {
        // Given
        let expectation = expectation(description: "Error message should be published")
        var receivedMessage: String?
        
        viewModel.$errorMessage
            .dropFirst() // Skip initial nil value
            .sink { message in
                receivedMessage = message
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        // When
        viewModel.errorMessage = "Test error"
        
        // Then
        wait(for: [expectation], timeout: publishedPropertyTimeout)
        XCTAssertEqual(receivedMessage, "Test error")
    }
}
