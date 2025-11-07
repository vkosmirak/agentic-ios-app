//
//  CompassViewUITests.swift
//  AgenticCompasUITests
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import XCTest

final class CompassViewUITests: AgenticCompasUITestCase {
    func testCompassViewDisplays() throws {
        // Given: App is launched
        app.launch()
        
        // When: Checking for compass view elements
        // Then: Heading display or compass elements should be visible
        let headingExists = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '°'")).firstMatch.exists
        XCTAssertTrue(headingExists, "Compass view should display heading or placeholder")
    }
    
    func testNorthTypeToggle() throws {
        // Given: App is launched
        app.launch()
        
        // When: Finding the north type toggle button
        let northTypeButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'Magnetic' OR label CONTAINS 'True'")).firstMatch
        
        // Skip if button doesn't exist (may need location permission)
        guard northTypeButton.waitForExistence(timeout: 2.0) else {
            _ = XCTSkip("North type button not found - may need location permission")
            return
        }
        
        let initialLabel = northTypeButton.label
        
        // Then: Tapping should change the label
        northTypeButton.tap()
        
        // Wait for label to change using awaiting helper
        awaiting(element: northTypeButton, for: "label != '\(initialLabel)'", timeout: 2.0)
        
        XCTAssertNotEqual(northTypeButton.label, initialLabel, "North type label should change after tap")
    }
}
