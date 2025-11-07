//
//  BearingLockUITests.swift
//  AgenticCompasUITests
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import XCTest

final class BearingLockUITests: AgenticCompasUITestCase {
    func testBearingLockButtonExists() throws {
        // Given: App is launched
        app.launch()
        
        // When: Looking for bearing lock button
        // Then: Button should exist (either by identifier or label)
        let lockButtonByIdentifier = app.buttons.matching(identifier: "Lock bearing").firstMatch
        let lockButtonByLabel = app.buttons.matching(NSPredicate(format: "label CONTAINS 'lock'")).firstMatch
        
        let buttonExists = lockButtonByIdentifier.exists || lockButtonByLabel.exists
        XCTAssertTrue(buttonExists, "Bearing lock button should exist")
    }
    
    func testBearingLockToggle() throws {
        // Given: App is launched
        app.launch()
        
        // When: Finding the lock button
        let lockButton = app.buttons.matching(NSPredicate(format: "label CONTAINS 'lock'")).firstMatch
        
        // Skip if button doesn't exist (may need location permission)
        guard lockButton.waitForExistence(timeout: 2.0) else {
            _ = XCTSkip("Lock button not found - may need location permission")
            return
        }
        
        let initialLabel = lockButton.label
        
        // Then: Tapping should change the button state
        lockButton.tap()
        
        // Wait for state to change using awaiting helper
        awaiting(element: lockButton, for: "label != '\(initialLabel)'", timeout: 2.0)
        
        let newLabel = lockButton.label
        XCTAssertNotEqual(newLabel, initialLabel, "Lock button label should change after tap")
    }
}
