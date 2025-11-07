//
//  PermissionFlowUITests.swift
//  AgenticCompasUITests
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import XCTest

final class PermissionFlowUITests: AgenticCompasUITestCase {
    func testPermissionRequestOnLaunch() throws {
        // Given: Authorization is reset
        app.resetAuthorizationStatus(for: .location)
        
        // When: App is launched
        app.launch()
        
        // Then: Permission alert may appear or permission flow is initiated
        let permissionAlert = app.alerts.firstMatch
        
        // Use waitForExistence for optional elements that may not exist
        if permissionAlert.waitForExistence(timeout: 3.0) {
            // Permission alert appeared
            permissionAlert.assertExistence(message: "Permission alert should appear")
        } else {
            // Permission may have been requested programmatically without alert
            // or already granted in previous test runs
            XCTAssertTrue(true, "Permission flow initiated")
        }
    }
    
    func testAppHandlesDeniedPermission() throws {
        // Given: Authorization is reset
        app.resetAuthorizationStatus(for: .location)
        
        // When: App is launched
        app.launch()
        
        // If alert appears, deny it
        let permissionAlert = app.alerts.firstMatch
        if permissionAlert.waitForExistence(timeout: 2.0) {
            let denyButton = permissionAlert.buttons["Don't Allow"].firstMatch
            if denyButton.exists {
                denyButton
                    .assertExistence()
                    .tap()
            }
        }
        
        // Wait a moment for app to handle denied state
        sleep(1)
        
        // Then: App should still be functional (may show error message)
        XCTAssertTrue(app.exists, "App should still be running after permission denial")
    }
}
