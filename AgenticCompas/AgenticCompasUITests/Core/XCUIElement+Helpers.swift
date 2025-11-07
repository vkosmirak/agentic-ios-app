//
//  XCUIElement+Helpers.swift
//  AgenticCompasUITests
//
//  Created by Volodymyr Kosmirak on 07.11.2025.
//

import XCTest

extension XCUIElement {
    /// Asserts that the element exists and returns self for chaining.
    /// Default timeout is 2 seconds (as per UI_TESTING.md guidelines).
    @discardableResult
    func assertExistence(waiting timeout: TimeInterval = 2.0) -> XCUIElement {
        XCTAssertTrue(waitForExistence(timeout: timeout), "Element should exist: \(description)")
        return self
    }
    
    /// Asserts that the element exists with a custom message and returns self for chaining.
    @discardableResult
    func assertExistence(waiting timeout: TimeInterval = 2.0, message: String) -> XCUIElement {
        XCTAssertTrue(waitForExistence(timeout: timeout), message)
        return self
    }
    
    /// Asserts that the element does not exist within the timeout.
    @discardableResult
    func assertNonExistence(waiting timeout: TimeInterval = 2.0) -> XCUIElement {
        XCTAssertFalse(waitForExistence(timeout: timeout), "Element should not exist: \(description)")
        return self
    }
    
    /// Asserts that the element is selected and returns self for chaining.
    @discardableResult
    func assertSelected() -> XCUIElement {
        XCTAssertTrue(isSelected, "Element should be selected: \(description)")
        return self
    }
    
    /// Asserts that the element is enabled and returns self for chaining.
    @discardableResult
    func assertEnabled() -> XCUIElement {
        XCTAssertTrue(isEnabled, "Element should be enabled: \(description)")
        return self
    }
    
    /// Asserts that the element is disabled and returns self for chaining.
    @discardableResult
    func assertDisabled() -> XCUIElement {
        XCTAssertFalse(isEnabled, "Element should be disabled: \(description)")
        return self
    }
    
    /// Asserts that the element has the expected label.
    @discardableResult
    func assertLabel(_ expectedLabel: String) -> XCUIElement {
        XCTAssertEqual(label, expectedLabel, "Element label should be '\(expectedLabel)' but was '\(label)'")
        return self
    }
    
    /// Asserts that the element contains the expected text in its label.
    @discardableResult
    func assertLabelContains(_ text: String) -> XCUIElement {
        XCTAssertTrue(label.contains(text), "Element label should contain '\(text)' but was '\(label)'")
        return self
    }
    
    /// Taps the element and returns self for chaining.
    /// Use this when you need to chain operations after tapping (e.g., typeText, clearAndEnterText).
    @discardableResult
    func tapAnd() -> XCUIElement {
        self.tap()
        return self
    }
}

extension XCTestCase {
    /// Waits for an element to satisfy a condition using a predicate.
    /// - Parameters:
    ///   - element: The element to wait for
    ///   - predicate: The predicate string (e.g., "isEnabled == true", "isSelected == false")
    ///   - timeout: Maximum time to wait (default: 5 seconds)
    /// - Returns: The element if condition is met
    @discardableResult
    func awaiting(element: XCUIElement, for predicateString: String, timeout: TimeInterval = 5.0) -> XCUIElement {
        let predicate = NSPredicate(format: predicateString)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: element)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        
        XCTAssertEqual(result, .completed, "Element did not satisfy condition '\(predicateString)' within \(timeout) seconds")
        return element
    }
}

extension XCUIElement {
    /// Clears existing text and enters new text.
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


