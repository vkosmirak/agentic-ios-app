//
//  TimersTabUITests.swift
//  AgenticAppUITests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest

final class TimersTabUITests: AgenticUITestCase {
    
    @MainActor
    func testTimersTab() throws {
        // 1. Launch the app
        app.launch()
        
        // 2. Navigate to Timers tab
        let timersTab = app.tabBars.buttons["Timers"]
        timersTab
            .assertExistence()
            .tap()
        timersTab.assertSelected()
        
        // 3. Verify navigation title
        app.navigationBars["Timers"]
            .assertExistence()
        
        // 4. Verify timer picker wheels exist (hours, minutes, seconds)
        XCTAssertTrue(app.pickers.count >= 3, "Timer pickers should exist (hours, minutes, seconds)")
        
        // 5. Verify control buttons exist
        app.buttons["Reset"]
            .assertExistence()
        
        app.buttons["Start"]
            .assertExistence()
        
        // 6. Verify settings section exists
        app.buttons["Name"]
            .assertExistence()
        
        app.buttons["When Timer Ends"]
            .assertExistence()
    }
}
