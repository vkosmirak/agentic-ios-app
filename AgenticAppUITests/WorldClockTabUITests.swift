//
//  WorldClockTabUITests.swift
//  AgenticAppUITests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest

final class WorldClockTabUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    @MainActor
    func testWorldClockTab() throws {
        // Launch the app
        let app = XCUIApplication()
        app.launch()
        
        // Navigate to World Clock tab (it might be selected by default)
        let worldClockTab = app.tabBars.buttons["World Clock"]
        XCTAssertTrue(worldClockTab.waitForExistence(timeout: 2), "World Clock tab should exist")
        
        // Tap the tab if not already selected
        if !worldClockTab.isSelected {
            worldClockTab.tap()
        }
        
        // Verify the tab is selected
        XCTAssertTrue(worldClockTab.isSelected, "World Clock tab should be selected")
        
        // Verify navigation title
        let navigationTitle = app.navigationBars["World Clock"]
        XCTAssertTrue(navigationTitle.waitForExistence(timeout: 2), "World Clock navigation title should exist")
        
        // Verify the add button exists
        let addButton = app.navigationBars.buttons["plus"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 2), "Add button should exist")
        
        // Verify either empty state or some content is visible
        // The view should show either empty state or clock list
        let emptyStateText = app.staticTexts["No Clocks"]
        let emptyStateHint = app.staticTexts["Tap + to add a world clock"]
        
        if emptyStateText.waitForExistence(timeout: 1) {
            // Verify empty state elements
            XCTAssertTrue(emptyStateText.exists, "Empty state should be visible when no clocks")
            XCTAssertTrue(emptyStateHint.exists, "Empty state hint should be visible")
        } else {
            // If clocks exist, at least verify the screen is not showing empty state
            XCTAssertFalse(emptyStateText.exists, "Empty state should not be visible when clocks exist")
        }
    }
}


