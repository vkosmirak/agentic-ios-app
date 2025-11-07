//
//  AgenticUITestCase.swift
//  AgenticCompasUITests
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import XCTest

class AgenticCompasUITestCase: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
}


