//
//  WorldClockTabUITests.swift
//  AgenticAppUITests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest

final class WorldClockTabUITests: AgenticUITestCase {
    
    @MainActor
    func testWorldClockTab() throws {
        // 1. Launch the app
        app.launch()
        
        // 2. Navigate to World Clock tab
        let worldClockTab = app.tabBars.buttons["World Clock"]
        worldClockTab
            .assertExistence()
        
        // 3. Tap the tab if not already selected
        if !worldClockTab.isSelected {
            worldClockTab.tap()
        }
        worldClockTab.assertSelected()
        
        // 4. Verify navigation title
        app.navigationBars["World Clock"]
            .assertExistence()
        
        // 5. Verify the add button exists
        app.navigationBars.buttons["plus"]
            .assertExistence()
        
        // 6. Verify either empty state or some content is visible
        let emptyStateText = app.staticTexts["No Clocks"]
        let emptyStateHint = app.staticTexts["Tap + to add a world clock"]
        
        if emptyStateText.waitForExistence(timeout: 1) {
            emptyStateText.assertExistence()
            emptyStateHint.assertExistence()
        } else {
            emptyStateText.assertNonExistence()
        }
    }
}
