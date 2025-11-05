# Unit Testing Guidelines

Quick reference guide for writing unit tests in AgenticApp.

## File Organization

### Folder Structure
Preserve the same folder structure in the production code:
- `AgenticApp/Core/Services/...` → `AgenticAppTests/Core/Services/...`
- `AgenticApp/Features/Stopwatch/...` → `AgenticAppTests/Features/Stopwatch/...`

### Test File Naming
- Test files: `[Class]Tests.swift`
- Example: `StopwatchViewModel.swift` → `StopwatchViewModelTests.swift`

### Mock Files
- **Mocks should be separate files** (not inline in test files)
- Mock file naming: `[Service]Mock.swift`
- Example: `TimeService` → `TimeServiceMock.swift`
- Place mocks in the same directory structure as the service being mocked

### Mock Guidelines
- Implement the protocol fully
- Provide settable properties for test data
- Track method calls and parameters
- Use descriptive variable names (e.g., `lastFormattedDate`, `callCount`)

## Best Practices

1. **Use Given-When-Then pattern** for test readability
2. **Test one thing per test method**
3. **Use descriptive test names**: `testFunctionNameWithCondition_ExpectedBehavior`
4. **Clean up in `tearDown()`**: Stop timers, cancel subscriptions, nil references
5. **Use expectations** for async operations and Combine publishers
6. **Use `XCTUnwrap` or `XCTAssertNotNil` for optionals**: Don't use force unwrapping or `if let`