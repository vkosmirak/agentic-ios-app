# UI Testing Guidelines

Quick reference for writing clean, maintainable UI tests in AgenticApp.

## Base Test Case

All UI tests should inherit from `AgenticUITestCase`:

```swift
final class MyUITests: AgenticUITestCase {
    func testSomething() throws {
        app.launch()
        // app is already available
    }
}
```

## Helper Methods

### Element Assertions (Chaining)

```swift
// Basic existence check (default 2s timeout)
app.buttons["Start"]
    .assertExistence()
    .tap()

// State assertions
app.tabBars.buttons["Stopwatch"]
    .assertExistence()
    .assertSelected()

app.buttons["Submit"]
    .assertExistence()
    .assertEnabled()

// Non-existence check
app.alerts["Error"]
    .assertNonExistence()
```

### Text Field Operations

```swift
app.textFields["Label"]
    .assertExistence()
    .tapAnd()
    .clearAndEnterText("New Label")
```

### Waiting for Conditions

```swift
awaiting(element: app.buttons["Submit"], for: "isEnabled == true").tap()
```

## Best Practices

1. **Use chaining** - Prefer `assertExistence().tap()` over separate assertions
2. **Use `.tapAnd()` when chaining operations** - If you need to perform another operation on the same element after tapping, use `.tapAnd()` instead of `.tap()` and avoid extracting to a separate `let` variable
3. **Keep tests focused** - Each test should verify one specific behavior
4. **Use descriptive comments** - Explain what you're testing
5. **Use `firstMatch`** - When you only need the first matching element
6. **Always replace `waitForExistence(timeout:)` with `assertExistence()`** - Use helper methods instead of raw XCTest APIs

## Code Patterns to Avoid

**❌ Bad:**

```swift
if button.waitForExistence(timeout: 2) { button.tap() }
XCTAssertTrue(button.waitForExistence(timeout: 2))

// Don't extract to let when chaining operations
let button = app.buttons["Start"]
button.assertExistence().tap()
button.assertSelected()

// Don't use .tap() when you need to chain
app.textFields["Label"].assertExistence().tap()
app.textFields["Label"].typeText("Text")
```

**✅ Good:**

```swift
app.buttons["Start"].assertExistence().tap()
app.textFields["Label"].assertExistence().tapAnd().typeText("Text")

// Use tapAnd() for chaining operations on the same element - don't extract to let
app.tabBars.buttons["TabName"]
    .assertExistence()
    .tapAnd()
    .assertSelected()
```

**Note:** Only use `waitForExistence()` directly for optional elements that may not exist. Use `.tapAnd()` instead of `.tap()` when you need to chain operations on the same element.

## Common Patterns

### Tab Navigation

```swift
// When you need to verify selection after tapping, use tapAnd() - don't extract to let
app.tabBars.buttons["TabName"]
    .assertExistence()
    .tapAnd()
    .assertSelected()

// Or if you only need to tap (no chaining)
app.tabBars.buttons["TabName"]
    .assertExistence()
    .tap()
```

### Button Interaction

```swift
app.buttons["ButtonName"]
    .assertExistence()
    .assertEnabled()
    .tap()
```

### Text Input

```swift
// Using tapAnd() for chaining
app.textFields["FieldName"]
    .assertExistence()
    .tapAnd()
    .clearAndEnterText("New Text")

// Or typeText after tapAnd()
app.textFields["FieldName"]
    .assertExistence()
    .tapAnd()
    .typeText("New Text")
```

### Alert Handling

```swift
app.alerts["Alert Title"]
    .assertExistence()
    .buttons.firstMatch
    .tap()
```

## Test Naming

- `testFeatureName()` - Basic feature verification
- `testFeatureNameWithCondition()` - Specific condition test
- `testFeatureNameFlow()` - Complete user flow

## Notes

- `continueAfterFailure = false` is handled by `AgenticUITestCase`
- Prefer `assertExistence()` over `XCTAssertTrue(waitForExistence())`
- Use chaining to make tests more readable
- Keep test methods focused on one behavior
