//
//  AlarmsTabUITests.swift
//  AgenticAppUITests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest

final class AlarmsTabUITests: AgenticUITestCase {
    
    @MainActor
    func testAlarmsTab() throws {
        // 1. Launch the app
        app.launch()
        
        // 2. Navigate to Alarms tab
        let alarmsTab = app.tabBars.buttons["Alarms"]
        alarmsTab
            .assertExistence()
            .tap()
        alarmsTab.assertSelected()
        
        // 3. Verify navigation title
        app.navigationBars["Alarms"]
            .assertExistence()
        
        // 4. Verify the add button exists
        app.navigationBars.buttons["plus"]
            .assertExistence()
        
        // 5. Verify either empty state or some content is visible
        let emptyStateText = app.staticTexts["No Alarms"]
        let emptyStateHint = app.staticTexts["Tap + to add an alarm"]
        
        if emptyStateText.waitForExistence(timeout: 1) {
            emptyStateText.assertExistence()
            emptyStateHint.assertExistence()
        } else {
            emptyStateText.assertNonExistence()
        }
    }
    
    @MainActor
    func testAddAlarm() throws {
        // 1. Launch the app and navigate to Alarms tab
        app.launch()
        app.tabBars.buttons["Alarms"]
            .assertExistence()
            .tap()
        
        // 2. Tap the add button
        app.navigationBars.buttons["plus"]
            .assertExistence()
            .tap()
        
        // 3. Verify the Add Alarm sheet is presented
        app.navigationBars["Add Alarm"]
            .assertExistence()
        
        // 4. Verify time picker exists
        app.datePickers.firstMatch
            .assertExistence()
        
        // 5. Set a specific time (8:30 AM)
        let pickerWheels = app.pickerWheels
        if pickerWheels.count >= 2 {
            pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "08")
            pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "30")
        }
        
        // 6. Add a label
        app.textFields["Label"]
            .assertExistence()
            .tapAnd()
            .typeText("Morning Alarm")
        
        // 7. Select repeat days (Monday and Wednesday)
        app.buttons["Monday"]
            .assertExistence()
            .tap()
        
        let wednesdayButton = app.buttons["Wednesday"]
        if wednesdayButton.waitForExistence(timeout: 1) {
            wednesdayButton.tap()
        }
        
        // 8. Change sound to "Waves"
        let soundPicker = app.pickers["Sound"]
        if soundPicker.waitForExistence(timeout: 1) {
            soundPicker.tap()
            let wavesOption = app.buttons["Waves"]
            if wavesOption.waitForExistence(timeout: 1) {
                wavesOption.tap()
            }
        }
        
        // 9. Toggle snooze off (if it's on)
        let snoozeToggle = app.switches["Snooze"]
        if snoozeToggle.waitForExistence(timeout: 1) {
            if snoozeToggle.value as? String == "1" {
                snoozeToggle.tap()
            }
        }
        
        // 10. Save the alarm
        app.buttons["Save"]
            .assertExistence()
            .tap()
        
        // 11. Verify the sheet is dismissed
        app.navigationBars["Add Alarm"]
            .assertNonExistence()
        
        // 12. Verify the alarm appears in the list
        app.staticTexts.containing(NSPredicate(format: "label CONTAINS '8' OR label CONTAINS '30'"))
            .firstMatch
            .assertExistence()
        
        // 13. Verify the label appears
        app.staticTexts["Morning Alarm"]
            .assertExistence()
    }
    
    @MainActor
    func testEditAlarm() throws {
        // 1. Launch the app and navigate to Alarms tab
        app.launch()
        app.tabBars.buttons["Alarms"]
            .assertExistence()
            .tap()
        
        // 2. Add an alarm to edit
        app.navigationBars.buttons["plus"]
            .assertExistence()
            .tap()
        
        app.navigationBars["Add Alarm"]
            .assertExistence()
        
        app.textFields["Label"]
            .assertExistence()
            .tapAnd()
            .typeText("Original Alarm")
        
        app.buttons["Save"]
            .assertExistence()
            .tap()
        
        // 3. Wait for the alarm to appear
        let originalLabel = app.staticTexts["Original Alarm"]
        originalLabel.assertExistence()
        
        // 4. Tap on the alarm to edit it
        originalLabel.tap()
        
        // 5. Verify the Edit Alarm sheet is presented
        app.navigationBars["Edit Alarm"]
            .assertExistence()
        
        // 6. Modify the label
        app.textFields["Label"]
            .assertExistence()
            .tapAnd()
            .clearAndEnterText("Updated Alarm")
        
        // 7. Change sound to "Cosmic"
        let soundPicker = app.pickers["Sound"]
        if soundPicker.waitForExistence(timeout: 1) {
            soundPicker.tap()
            let cosmicOption = app.buttons["Cosmic"]
            if cosmicOption.waitForExistence(timeout: 1) {
                cosmicOption.tap()
            }
        }
        
        // 8. Add Friday to repeat days
        let fridayButton = app.buttons["Friday"]
        if fridayButton.waitForExistence(timeout: 1) {
            fridayButton.tap()
        }
        
        // 9. Save the changes
        app.buttons["Save"]
            .assertExistence()
            .tap()
        
        // 10. Verify the sheet is dismissed
        app.navigationBars["Edit Alarm"]
            .assertNonExistence()
        
        // 11. Verify the updated label appears
        app.staticTexts["Updated Alarm"]
            .assertExistence()
        
        // 12. Verify the original label is gone
        app.staticTexts["Original Alarm"]
            .assertNonExistence()
    }
    
    @MainActor
    func testDeleteAlarm() throws {
        // 1. Launch the app and navigate to Alarms tab
        app.launch()
        app.tabBars.buttons["Alarms"]
            .assertExistence()
            .tap()
        
        // 2. Add an alarm to delete
        app.navigationBars.buttons["plus"]
            .assertExistence()
            .tap()
        
        app.navigationBars["Add Alarm"]
            .assertExistence()
        
        app.textFields["Label"]
            .assertExistence()
            .tapAnd()
            .typeText("Alarm To Delete")
        
        app.buttons["Save"]
            .assertExistence()
            .tap()
        
        // 3. Wait for the alarm to appear
        let alarmToDelete = app.staticTexts["Alarm To Delete"]
        alarmToDelete.assertExistence()
        
        // 4. Find the cell containing the alarm text and swipe left
        let cells = app.cells
        var alarmCell: XCUIElement?
        
        for i in 0..<cells.count {
            let cell = cells.element(boundBy: i)
            if cell.staticTexts["Alarm To Delete"].exists {
                alarmCell = cell
                break
            }
        }
        
        let elementToSwipe = alarmCell ?? alarmToDelete
        elementToSwipe.swipeLeft()
        
        // 5. Tap the delete button
        app.buttons["Delete"]
            .assertExistence()
            .tap()
        
        // 6. Verify the alarm is removed
        alarmToDelete.assertNonExistence()
    }
    
    @MainActor
    func testAddEditDeleteFlow() throws {
        // 1. Launch the app and navigate to Alarms tab
        app.launch()
        app.tabBars.buttons["Alarms"]
            .assertExistence()
            .tap()
        
        // 2. Add an alarm
        app.navigationBars.buttons["plus"]
            .assertExistence()
            .tap()
        
        app.navigationBars["Add Alarm"]
            .assertExistence()
        
        app.textFields["Label"]
            .assertExistence()
            .tapAnd()
            .typeText("Complete Flow Alarm")
        
        app.buttons["Save"]
            .assertExistence()
            .tap()
        
        // 3. Verify alarm was added
        let addedAlarm = app.staticTexts["Complete Flow Alarm"]
        addedAlarm.assertExistence()
        
        // 4. Edit the alarm
        addedAlarm.tap()
        
        app.navigationBars["Edit Alarm"]
            .assertExistence()
        
        app.textFields["Label"]
            .assertExistence()
            .tapAnd()
            .clearAndEnterText("Edited Flow Alarm")
        
        app.buttons["Save"]
            .assertExistence()
            .tap()
        
        // 5. Verify alarm was edited
        let editedAlarm = app.staticTexts["Edited Flow Alarm"]
        editedAlarm.assertExistence()
        app.staticTexts["Complete Flow Alarm"]
            .assertNonExistence()
        
        // 6. Delete the alarm
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
        
        app.buttons["Delete"]
            .assertExistence()
            .tap()
        
        // 7. Verify alarm was deleted
        editedAlarm.assertNonExistence()
    }
}
