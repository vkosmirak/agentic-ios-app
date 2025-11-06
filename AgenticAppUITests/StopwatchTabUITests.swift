//
//  StopwatchTabUITests.swift
//  AgenticAppUITests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest

final class StopwatchTabUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    @MainActor
    func testStopwatchTab() throws {
        // Launch the app
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to Stopwatch tab
        let stopwatchTab = app.tabBars.buttons["Stopwatch"]
        XCTAssertTrue(stopwatchTab.waitForExistence(timeout: 2), "Stopwatch tab should exist")
        stopwatchTab.tap()
        
        // Verify the tab is selected
        XCTAssertTrue(stopwatchTab.isSelected, "Stopwatch tab should be selected")
        
        // Verify navigation title
        let navigationTitle = app.navigationBars["Stopwatch"]
        XCTAssertTrue(navigationTitle.waitForExistence(timeout: 2), "Stopwatch navigation title should exist")
        
        // Verify time display exists (should show "0:00.00" or similar)
        // The time display is a large text element
        let staticTexts = app.staticTexts
        XCTAssertTrue(staticTexts.count > 0, "Time display should exist")
        
        // Verify control buttons exist
        // Check for buttons with "Lap", "Reset", "Start", or "Stop" text
        let lapButton = app.buttons["Lap"]
        let resetButton = app.buttons["Reset"]
        let startButton = app.buttons["Start"]
        let stopButton = app.buttons["Stop"]
        
        let hasLapOrReset = lapButton.waitForExistence(timeout: 2) || resetButton.waitForExistence(timeout: 1)
        let hasStartOrStop = startButton.waitForExistence(timeout: 2) || stopButton.waitForExistence(timeout: 1)
        
        XCTAssertTrue(hasLapOrReset, "Lap/Reset button should exist")
        XCTAssertTrue(hasStartOrStop, "Start/Stop button should exist")
    }
}

