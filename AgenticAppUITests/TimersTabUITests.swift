//
//  TimersTabUITests.swift
//  AgenticAppUITests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest

final class TimersTabUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    @MainActor
    func testTimersTab() throws {
        // Launch the app
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to Timers tab
        let timersTab = app.tabBars.buttons["Timers"]
        XCTAssertTrue(timersTab.waitForExistence(timeout: 2), "Timers tab should exist")
        timersTab.tap()
        
        // Verify the tab is selected
        XCTAssertTrue(timersTab.isSelected, "Timers tab should be selected")
        
        // Verify navigation title
        let navigationTitle = app.navigationBars["Timers"]
        XCTAssertTrue(navigationTitle.waitForExistence(timeout: 2), "Timers navigation title should exist")
        
        // Verify timer picker wheels exist (hours, minutes, seconds)
        // SwiftUI pickers might be exposed as picker wheels or buttons
        let pickers = app.pickers
        XCTAssertTrue(pickers.count >= 3, "Timer pickers should exist (hours, minutes, seconds)")
        
        // Verify control buttons exist
        let resetButton = app.buttons["Reset"]
        let startButton = app.buttons["Start"]
        
        XCTAssertTrue(resetButton.waitForExistence(timeout: 2), "Reset button should exist")
        XCTAssertTrue(startButton.waitForExistence(timeout: 2), "Start button should exist")
        
        // Verify settings section exists
        let nameButton = app.buttons["Name"]
        let whenTimerEndsButton = app.buttons["When Timer Ends"]
        
        XCTAssertTrue(nameButton.waitForExistence(timeout: 2), "Name button should exist")
        XCTAssertTrue(whenTimerEndsButton.waitForExistence(timeout: 2), "When Timer Ends button should exist")
    }
}

