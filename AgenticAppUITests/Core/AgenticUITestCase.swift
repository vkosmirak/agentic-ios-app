//
//  AgenticUITestCase.swift
//  AgenticAppUITests
//
//  Created by Volodymyr Kosmirak on 03.11.2025.
//

import XCTest

class AgenticUITestCase: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
}

