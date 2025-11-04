# Strict Code Review

Zero tolerance for substandard code. Review **every line** comprehensively. Reference `@ARCHITECTURE.md` for patterns. Think deep, megathink, ultrathink

## Review Categories

### 🔴 Critical (Blockers)

1. **Bugs & Logic**: Memory leaks, retain cycles, race conditions, force unwraps (`!`), force casts (`as!`), bounds errors, edge cases, state corruption
2. **Architecture**: MVVM-C compliance, protocol-based DI, coordinator navigation, service layer patterns (see `@ARCHITECTURE.md`)
3. **SwiftUI/iOS**: Lifecycle (`onAppear`/`onDisappear`), state management (`@State`/`@StateObject`/`@ObservedObject`), task cancellation, coordinator-only navigation, accessibility
4. **Concurrency**: Task cancellation, Combine cancellables, race conditions, main actor isolation, thread safety, @MainActor usage
5. **Security**: Keychain for sensitive data, input validation, no hardcoded secrets, secure credential handling
6. **Style**: Naming conventions, formatting consistency, file organization, pattern consistency

### 🟡 Warning (Should Fix)

7. **Performance**: Algorithm efficiency, memory usage, unnecessary view updates, network optimization
8. **Error Handling**: Error types, propagation, recovery, validation
9. **Testing**: Testability, dependency injection, test coverage, mocking support
10. **Maintainability**: Coupling, cohesion, abstraction, technical debt, deprecated APIs

### 🟢 Suggestion (Nice to Have)

11. **Documentation**: Complex logic comments, public API docs, clarity
12. **Code Quality**: SOLID principles, DRY violations, code smells (long methods >30 lines, large classes >200 lines, >3 params), complexity (<10), magic numbers, dead code

## Output Format

For each issue:

```
## [Issue #] 🔴 CRITICAL: [Title]

**Location**: `file.swift`:`LINENUMBERS`
**Category**: [Bug/Architecture/Security/etc]

**Issue**: [Description]
**Impact**: [Why it matters]

**Fix**:
```swift
// Before/after code example
```
```

End with summary:

```
## Review Summary

**Issues**: 🔴 [X] Critical | 🟡 [X] Warning | 🟢 [X] Suggestion
**Assessment**: APPROVED / CONDITIONAL / REJECTED
**Recommendation**: [Clear action]
```

## Guidelines

- Check every line, function, class
- Provide exact locations and code examples
- Reference `@ARCHITECTURE.md` for patterns
- Cover all 12 categories
- Zero tolerance: Critical = BLOCK merge

