//
//  StopwatchTabUITests.swift
//  AgenticAppUITests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest

final class StopwatchTabUITests: AgenticUITestCase {
    
    @MainActor
    func testStopwatchTab() throws {
        // 1. Launch the app
        app.launch()
        
        // 2. Navigate to Stopwatch tab
        let stopwatchTab = app.tabBars.buttons["Stopwatch"]
        stopwatchTab
            .assertExistence()
            .tap()
        stopwatchTab.assertSelected()
        
        // 3. Verify navigation title
        app.navigationBars["Stopwatch"]
            .assertExistence()
        
        // 4. Verify time display exists
        XCTAssertTrue(app.staticTexts.count > 0, "Time display should exist")
        
        // 5. Verify control buttons exist
        // The buttons use accessibility labels, so we check for those or the button text
        // Lap/Reset button: accessibilityLabel "Record lap time" or "Reset stopwatch", or text "Lap"/"Reset"
        let lapButton = app.buttons["Record lap time"]
        let resetButton = app.buttons["Reset stopwatch"]
        let lapTextButton = app.buttons["Lap"]
        let resetTextButton = app.buttons["Reset"]
        
        let hasLapOrReset = lapButton.waitForExistence(timeout: 1) ||
                           resetButton.waitForExistence(timeout: 1) ||
                           lapTextButton.waitForExistence(timeout: 1) ||
                           resetTextButton.waitForExistence(timeout: 1)
        XCTAssertTrue(hasLapOrReset, "Lap/Reset button should exist")
        
        // Start/Stop button: accessibilityLabel "Start stopwatch" or "Stop stopwatch", or text "Start"/"Stop"
        let startButton = app.buttons["Start stopwatch"]
        let stopButton = app.buttons["Stop stopwatch"]
        let startTextButton = app.buttons["Start"]
        let stopTextButton = app.buttons["Stop"]
        
        let hasStartOrStop = startButton.waitForExistence(timeout: 1) ||
                            stopButton.waitForExistence(timeout: 1) ||
                            startTextButton.waitForExistence(timeout: 1) ||
                            stopTextButton.waitForExistence(timeout: 1)
        XCTAssertTrue(hasStartOrStop, "Start/Stop button should exist")
    }
}

