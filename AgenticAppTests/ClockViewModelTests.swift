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
    private var mockTimeService: MockTimeService!
    private var mockClockService: MockClockService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockTimeService = MockTimeService()
        mockClockService = MockClockService()
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
    
    func testInitialization() {
        // Then
        XCTAssertFalse(viewModel.clocks.isEmpty)
        XCTAssertEqual(viewModel.clocks.count, ClockModel.defaultClocks.count)
    }
    
//    func testInitializationWithCustomTimeZone() {
//        // Given
//        let customTimeZone = TimeZone(identifier: "Europe/Paris")!
//        
//        // When
//        let customViewModel = ClockViewModel(timeService: mockTimeService, localTimeZone: customTimeZone)
//        
//        // Then - just verify initialization completes without crashing
//        XCTAssertNotNil(customViewModel)
//        
//        // Cleanup - ensure timer is stopped before deallocation
//        customViewModel.onDisappear()
//    }
    
//    func testInitializationWithCustomTimeZoneSetsClocks() {
//        // Given
//        let customTimeZone = TimeZone(identifier: "Europe/Paris")!
//        
//        // When
//        let customViewModel = ClockViewModel(timeService: mockTimeService, localTimeZone: customTimeZone)
//        
//        // Then
//        XCTAssertFalse(customViewModel.clocks.isEmpty)
//        XCTAssertEqual(customViewModel.clocks.count, ClockModel.defaultClocks.count)
//        
//        // Cleanup
//        customViewModel.onDisappear()
//    }
//    
//    func testOnAppearStartsTimer() {
//        // Given
//        let expectation = expectation(description: "Timer should update currentDate")
//        var dateUpdates: [Date] = []
//        
//        viewModel.$currentDate
//            .dropFirst() // Skip initial value
//            .sink { date in
//                dateUpdates.append(date)
//                if dateUpdates.count >= 2 {
//                    expectation.fulfill()
//                }
//            }
//            .store(in: &cancellables)
//        
//        // When
//        viewModel.onAppear()
//        
//        // Then
//        wait(for: [expectation], timeout: timerTimeout)
//        XCTAssertTrue(dateUpdates.count >= 2, "Timer should fire at least twice")
//        
//        // Verify dates are different (timer is updating)
//        XCTAssertNotEqual(dateUpdates[0], dateUpdates[1], "Timer should update dates")
//    }
//    
//    func testOnDisappearCancelsTimer() {
//        // Given
//        viewModel.onAppear()
//        
//        // Wait briefly to ensure timer starts and fires at least once
//        let initialExpectation = expectation(description: "Timer should fire initially")
//        var initialDate: Date?
//        viewModel.$currentDate
//            .dropFirst()
//            .sink { date in
//                initialDate = date
//                initialExpectation.fulfill()
//            }
//            .store(in: &cancellables)
//        
//        wait(for: [initialExpectation], timeout: 1.5)
//        
//        // Capture date after timer has fired
//        guard let beforeDisappearDate = initialDate else {
//            XCTFail("Timer should have fired at least once")
//            return
//        }
//        
//        // When - cancel timer
//        viewModel.onDisappear()
//        
//        // Wait to ensure timer doesn't fire after cancellation
//        Thread.sleep(forTimeInterval: timerCancellationTimeout)
//        
//        // Then - verify timer was cancelled
//        XCTAssertTrue(viewModel.cancellables.isEmpty, "Cancellables should be empty after onDisappear")
//        
//        // Verify date hasn't changed significantly (timer stopped)
//        let afterDisappearDate = viewModel.currentDate
//        let timeDifference = abs(afterDisappearDate.timeIntervalSince(beforeDisappearDate))
//        // Date should not have updated more than a small amount (timer stopped)
//        XCTAssertLessThan(timeDifference, 0.5, "Date should not update significantly after timer cancellation")
//    }
//    
//    func testFormattedTime() {
//        // Given
//        let testTimeZone = TimeZone(identifier: "America/New_York")!
//        let clock = ClockModel(cityName: "New York", timeZone: testTimeZone)
//        let expectedFormattedTime = "12:00 PM"
//        
//        mockTimeService.formattedTimeResult = expectedFormattedTime
//        
//        // When
//        let formattedTime = viewModel.formattedTime(for: clock)
//        
//        // Then
//        XCTAssertEqual(formattedTime, expectedFormattedTime)
//        XCTAssertEqual(mockTimeService.lastFormattedDate, viewModel.currentDate)
//        XCTAssertEqual(mockTimeService.lastFormattedTimeZone, testTimeZone)
//    }
//    
//    func testTimeDifference() {
//        // Given
//        let localTimeZone = TimeZone(identifier: "America/Los_Angeles")!
//        let targetTimeZone = TimeZone(identifier: "America/New_York")!
//        let clock = ClockModel(cityName: "New York", timeZone: targetTimeZone)
//        let expectedDifference = "3 hours ahead"
//        
//        mockTimeService.timeDifferenceResult = expectedDifference
//        
//        // Create new viewModel with custom timezone (don't modify instance variable)
//        let customViewModel = ClockViewModel(timeService: mockTimeService, localTimeZone: localTimeZone)
//        
//        // When
//        let difference = customViewModel.timeDifference(for: clock)
//        
//        // Then
//        XCTAssertEqual(difference, expectedDifference)
//        XCTAssertEqual(mockTimeService.lastDifferenceSource, localTimeZone)
//        XCTAssertEqual(mockTimeService.lastDifferenceTarget, targetTimeZone)
//        
//        // Cleanup
//        customViewModel.onDisappear()
//    }
//    
//    func testClocksPropertyIsPublished() {
//        // Given
//        let expectation = expectation(description: "Clocks should be published")
//        var receivedClocks: [ClockModel] = []
//        
//        viewModel.$clocks
//            .sink { clocks in
//                receivedClocks = clocks
//                expectation.fulfill()
//            }
//            .store(in: &cancellables)
//        
//        // When
//        wait(for: [expectation], timeout: publishedPropertyTimeout)
//        
//        // Then
//        XCTAssertFalse(receivedClocks.isEmpty, "Published clocks should not be empty")
//    }
}

// MARK: - Mock Services

private class MockTimeService: TimeServiceProtocol {
    var currentDate: Date = Date()
    var formattedTimeResult: String = "12:00 AM"
    var timeDifferenceResult: String = "Same time"
    
    var lastFormattedDate: Date?
    var lastFormattedTimeZone: TimeZone?
    var lastDifferenceSource: TimeZone?
    var lastDifferenceTarget: TimeZone?
    
    func formattedTime(_ date: Date, timeZone: TimeZone) -> String {
        lastFormattedDate = date
        lastFormattedTimeZone = timeZone
        return formattedTimeResult
    }
    
    func timeDifference(from sourceTimeZone: TimeZone, to targetTimeZone: TimeZone) -> String {
        lastDifferenceSource = sourceTimeZone
        lastDifferenceTarget = targetTimeZone
        return timeDifferenceResult
    }
}

private class MockClockService: ClockServiceProtocol {
    var clocks: [ClockModel] = []
    
    func loadClocks() -> [ClockModel] {
        return clocks.isEmpty ? ClockModel.defaultClocks : clocks
    }
    
    func saveClocks(_ clocks: [ClockModel]) throws {
        self.clocks = clocks
    }
    
    func addClock(_ clock: ClockModel) throws {
        if clocks.contains(where: { $0.id == clock.id || ($0.cityName == clock.cityName && $0.timeZone.identifier == clock.timeZone.identifier) }) {
            return
        }
        clocks.append(clock)
    }
    
    func deleteClock(id: UUID) throws {
        clocks.removeAll { $0.id == id }
    }
    
    func deleteClocks(ids: [UUID]) throws {
        clocks.removeAll { ids.contains($0.id) }
    }
    
    func getClock(id: UUID) -> ClockModel? {
        return clocks.first { $0.id == id }
    }
}

