//
//  AlarmsTabUITests.swift
//  AgenticAppUITests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest

final class AlarmsTabUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
        // Navigate to Alarms tab
        let alarmsTab = app.tabBars.buttons["Alarms"]
        XCTAssertTrue(alarmsTab.waitForExistence(timeout: 2), "Alarms tab should exist")
        alarmsTab.tap()
    }
    
    @MainActor
    func testAlarmsTab() throws {
        // Verify the tab is selected
        let alarmsTab = app.tabBars.buttons["Alarms"]
        XCTAssertTrue(alarmsTab.isSelected, "Alarms tab should be selected")
        
        // Verify navigation title
        let navigationTitle = app.navigationBars["Alarms"]
        XCTAssertTrue(navigationTitle.waitForExistence(timeout: 2), "Alarms navigation title should exist")
        
        // Verify the add button exists
        let addButton = app.navigationBars.buttons["plus"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 2), "Add button should exist")
        
        // Verify either empty state or some content is visible
        let emptyStateText = app.staticTexts["No Alarms"]
        let emptyStateHint = app.staticTexts["Tap + to add an alarm"]
        
        if emptyStateText.waitForExistence(timeout: 1) {
            // Verify empty state elements
            XCTAssertTrue(emptyStateText.exists, "Empty state should be visible when no alarms")
            XCTAssertTrue(emptyStateHint.exists, "Empty state hint should be visible")
        } else {
            // If alarms exist, at least verify the screen is not showing empty state
            XCTAssertFalse(emptyStateText.exists, "Empty state should not be visible when alarms exist")
        }
    }
    
    @MainActor
    func testAddAlarm() throws {
        // Tap the add button
        let addButton = app.navigationBars.buttons["plus"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 2), "Add button should exist")
        addButton.tap()
        
        // Verify the Add Alarm sheet is presented
        let addAlarmTitle = app.navigationBars["Add Alarm"]
        XCTAssertTrue(addAlarmTitle.waitForExistence(timeout: 2), "Add Alarm sheet should be presented")
        
        // Find the time picker (DatePicker with wheel style)
        // The DatePicker might be accessible as a picker or as individual wheels
        let timePicker = app.datePickers.firstMatch
        XCTAssertTrue(timePicker.waitForExistence(timeout: 2), "Time picker should exist")
        
        // Set a specific time (e.g., 8:30 AM)
        // For wheel pickers, we need to interact with the individual wheels
        let pickerWheels = app.pickerWheels
        if pickerWheels.count >= 2 {
            // Set hour to 8 (picker expects zero-padded values like "08")
            let hourWheel = pickerWheels.element(boundBy: 0)
            hourWheel.adjust(toPickerWheelValue: "08")
            
            // Set minute to 30
            let minuteWheel = pickerWheels.element(boundBy: 1)
            minuteWheel.adjust(toPickerWheelValue: "30")
        }
        
        // Add a label
        let labelField = app.textFields["Label"]
        XCTAssertTrue(labelField.waitForExistence(timeout: 2), "Label field should exist")
        labelField.tap()
        labelField.typeText("Morning Alarm")
        
        // Select repeat days (e.g., Monday and Wednesday)
        let mondayButton = app.buttons["Monday"]
        if mondayButton.waitForExistence(timeout: 1) {
            mondayButton.tap()
        }
        
        let wednesdayButton = app.buttons["Wednesday"]
        if wednesdayButton.waitForExistence(timeout: 1) {
            wednesdayButton.tap()
        }
        
        // Change sound to "Waves"
        let soundPicker = app.pickers["Sound"]
        if soundPicker.waitForExistence(timeout: 1) {
            soundPicker.tap()
            let wavesOption = app.buttons["Waves"]
            if wavesOption.waitForExistence(timeout: 1) {
                wavesOption.tap()
            }
        }
        
        // Toggle snooze off (if it's on)
        let snoozeToggle = app.switches["Snooze"]
        if snoozeToggle.waitForExistence(timeout: 1) {
            if snoozeToggle.value as? String == "1" {
                snoozeToggle.tap()
            }
        }
        
        // Save the alarm
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2), "Save button should exist")
        saveButton.tap()
        
        // Verify the sheet is dismissed
        XCTAssertFalse(addAlarmTitle.waitForExistence(timeout: 1), "Add Alarm sheet should be dismissed")
        
        // Verify the alarm appears in the list
        // The alarm should show the time we set (8:30 AM format)
        let alarmTime = app.staticTexts.containing(NSPredicate(format: "label CONTAINS '8' OR label CONTAINS '30'")).firstMatch
        XCTAssertTrue(alarmTime.waitForExistence(timeout: 2), "Alarm should appear in the list")
        
        // Verify the label appears
        let alarmLabel = app.staticTexts["Morning Alarm"]
        XCTAssertTrue(alarmLabel.waitForExistence(timeout: 2), "Alarm label should be visible")
    }
    
    @MainActor
    func testEditAlarm() throws {
        // First, add an alarm to edit
        let addButton = app.navigationBars.buttons["plus"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 2), "Add button should exist")
        addButton.tap()
        
        let addAlarmTitle = app.navigationBars["Add Alarm"]
        XCTAssertTrue(addAlarmTitle.waitForExistence(timeout: 2), "Add Alarm sheet should be presented")
        
        // Add a simple alarm
        let labelField = app.textFields["Label"]
        if labelField.waitForExistence(timeout: 2) {
            labelField.tap()
            labelField.typeText("Original Alarm")
        }
        
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2), "Save button should exist")
        saveButton.tap()
        
        // Wait for the alarm to appear
        let originalLabel = app.staticTexts["Original Alarm"]
        XCTAssertTrue(originalLabel.waitForExistence(timeout: 2), "Original alarm should appear")
        
        // Tap on the alarm to edit it
        originalLabel.tap()
        
        // Verify the Edit Alarm sheet is presented
        let editAlarmTitle = app.navigationBars["Edit Alarm"]
        XCTAssertTrue(editAlarmTitle.waitForExistence(timeout: 2), "Edit Alarm sheet should be presented")
        
        // Modify the label
        let editLabelField = app.textFields["Label"]
        XCTAssertTrue(editLabelField.waitForExistence(timeout: 2), "Label field should exist in edit mode")
        editLabelField.tap()
        
        // Clear existing text and type new text
        editLabelField.clearAndEnterText("Updated Alarm")
        
        // Change sound to "Cosmic"
        let soundPicker = app.pickers["Sound"]
        if soundPicker.waitForExistence(timeout: 1) {
            soundPicker.tap()
            let cosmicOption = app.buttons["Cosmic"]
            if cosmicOption.waitForExistence(timeout: 1) {
                cosmicOption.tap()
            }
        }
        
        // Add Friday to repeat days
        let fridayButton = app.buttons["Friday"]
        if fridayButton.waitForExistence(timeout: 1) {
            fridayButton.tap()
        }
        
        // Save the changes
        let editSaveButton = app.buttons["Save"]
        XCTAssertTrue(editSaveButton.waitForExistence(timeout: 2), "Save button should exist")
        editSaveButton.tap()
        
        // Verify the sheet is dismissed
        XCTAssertFalse(editAlarmTitle.waitForExistence(timeout: 1), "Edit Alarm sheet should be dismissed")
        
        // Verify the updated label appears
        let updatedLabel = app.staticTexts["Updated Alarm"]
        XCTAssertTrue(updatedLabel.waitForExistence(timeout: 2), "Updated alarm label should be visible")
        
        // Verify the original label is gone
        XCTAssertFalse(app.staticTexts["Original Alarm"].exists, "Original alarm label should not exist")
    }
    
    @MainActor
    func testDeleteAlarm() throws {
        // First, add an alarm to delete
        let addButton = app.navigationBars.buttons["plus"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 2), "Add button should exist")
        addButton.tap()
        
        let addAlarmTitle = app.navigationBars["Add Alarm"]
        XCTAssertTrue(addAlarmTitle.waitForExistence(timeout: 2), "Add Alarm sheet should be presented")
        
        // Add a simple alarm with a unique label
        let labelField = app.textFields["Label"]
        if labelField.waitForExistence(timeout: 2) {
            labelField.tap()
            labelField.typeText("Alarm To Delete")
        }
        
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2), "Save button should exist")
        saveButton.tap()
        
        // Wait for the alarm to appear
        let alarmToDelete = app.staticTexts["Alarm To Delete"]
        XCTAssertTrue(alarmToDelete.waitForExistence(timeout: 2), "Alarm should appear in the list")
        
        // Find the cell containing the alarm text
        // In SwiftUI List, we can swipe on the static text element itself
        // or find the containing cell
        let cells = app.cells
        var alarmCell: XCUIElement?
        
        for i in 0..<cells.count {
            let cell = cells.element(boundBy: i)
            if cell.staticTexts["Alarm To Delete"].exists {
                alarmCell = cell
                break
            }
        }
        
        // If we found a cell, swipe on it, otherwise swipe on the text element
        let elementToSwipe = alarmCell ?? alarmToDelete
        elementToSwipe.swipeLeft()
        
        // Tap the delete button
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 2), "Delete button should appear")
        deleteButton.tap()
        
        // Verify the alarm is removed
        XCTAssertFalse(alarmToDelete.waitForExistence(timeout: 2), "Alarm should be deleted from the list")
    }
    
    @MainActor
    func testAddEditDeleteFlow() throws {
        // Test complete flow: Add -> Edit -> Delete
        
        // Step 1: Add an alarm
        let addButton = app.navigationBars.buttons["plus"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 2), "Add button should exist")
        addButton.tap()
        
        let addAlarmTitle = app.navigationBars["Add Alarm"]
        XCTAssertTrue(addAlarmTitle.waitForExistence(timeout: 2), "Add Alarm sheet should be presented")
        
        let labelField = app.textFields["Label"]
        if labelField.waitForExistence(timeout: 2) {
            labelField.tap()
            labelField.typeText("Complete Flow Alarm")
        }
        
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 2), "Save button should exist")
        saveButton.tap()
        
        // Verify alarm was added
        let addedAlarm = app.staticTexts["Complete Flow Alarm"]
        XCTAssertTrue(addedAlarm.waitForExistence(timeout: 2), "Alarm should be added")
        
        // Step 2: Edit the alarm
        addedAlarm.tap()
        
        let editAlarmTitle = app.navigationBars["Edit Alarm"]
        XCTAssertTrue(editAlarmTitle.waitForExistence(timeout: 2), "Edit Alarm sheet should be presented")
        
        let editLabelField = app.textFields["Label"]
        if editLabelField.waitForExistence(timeout: 2) {
            editLabelField.tap()
            editLabelField.clearAndEnterText("Edited Flow Alarm")
        }
        
        let editSaveButton = app.buttons["Save"]
        editSaveButton.tap()
        
        // Verify alarm was edited
        let editedAlarm = app.staticTexts["Edited Flow Alarm"]
        XCTAssertTrue(editedAlarm.waitForExistence(timeout: 2), "Alarm should be edited")
        XCTAssertFalse(app.staticTexts["Complete Flow Alarm"].exists, "Original label should be gone")
        
        // Step 3: Delete the alarm
        let cells = app.cells
        var alarmCell: XCUIElement?
        
        for i in 0..<cells.count {
            let cell = cells.element(boundBy: i)
            if cell.staticTexts["Edited Flow Alarm"].exists {
                alarmCell = cell
                break
            }
        }
        
        let elementToSwipe = alarmCell ?? editedAlarm
        elementToSwipe.swipeLeft()
        
        let deleteButton = app.buttons["Delete"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 2), "Delete button should appear")
        deleteButton.tap()
        
        // Verify alarm was deleted
        XCTAssertFalse(editedAlarm.waitForExistence(timeout: 2), "Alarm should be deleted")
    }
}

// Helper extension for text field clearing
extension XCUIElement {
    func clearAndEnterText(_ text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        self.tap()
        
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
        self.typeText(text)
    }
}



