# Agent Instructions

Quick reference guide for agents to build, test, run, and verify the iOS app.

**For architecture details**: See [ARCHITECTURE.md](./ARCHITECTURE.md) for MVVM-C patterns, dependency injection, and project structure.

**Note**: All paths are relative to the workspace root (`/Users/vkosmirak/src/agentic-ios-app/`). If running from a different directory, use absolute paths. All commands shown are MCP (Model Context Protocol) tool calls.

## Project Info

- **Project**: AgenticApp
- **Bundle ID**: `com.readdle.AgenticApp`
- **Scheme**: AgenticApp
- **Project Path**: `AgenticApp.xcodeproj`
- **Simulator UUID**: `B6E73094-CED6-458D-B9F5-9D65034F10E0` (iOS 26.0 iPhone 16 Pro)

## Quick Commands

### Run App (Build + Install + Launch)

```
build_run_sim({
  projectPath: "AgenticApp.xcodeproj",
  scheme: "AgenticApp",
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0"
})
open_sim()  // Ensure simulator window is visible and active on Mac
```

### Build Only

```
build_sim({
  projectPath: "AgenticApp.xcodeproj",
  scheme: "AgenticApp",
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0"
})
```

### Run Tests

```
// Unit tests
test_sim({
  projectPath: "AgenticApp.xcodeproj",
  scheme: "AgenticApp",
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0",
  extraArgs: ["-disable-concurrent-testing"]
})

// UI tests only
test_sim({
  projectPath: "AgenticApp.xcodeproj",
  scheme: "AgenticApp",
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0",
  extraArgs: ["-only-testing:AgenticAppUITests"]
})

// Run specific test method or class
test_sim({
  projectPath: "AgenticApp.xcodeproj",
  scheme: "AgenticApp",
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0",
  extraArgs: ["-only-testing:AgenticAppTests/TimeServiceTests/testCurrentTimeReturnsValidDate"]
})
```

### Verify functionality

**Verification Strategy:**

- Before executing tests, prepare test cases (list of specific steps) that verifies intended functionality
- Keep test cases minimal
- **Do not jump into fixing directly!** Focus on collecting all success/failed test cases. Report them in the end. Fix after (if asked before)
- Avoid running the entire test suite unless explicitly requested

**⚠️ IMPORTANT: Use `describe_ui()` by default, `screenshots()` only when needed**

```
describe_ui({ simulatorUuid: "B6E73094-CED6-458D-B9F5-9D65034F10E0" })
// Returns structured JSON with all UI elements, coordinates, and actions
// If children array is empty, retry after a brief delay (app still loading)

// ❌ AVOID: Screenshots unless specifically needed for visual verification
screenshot({ simulatorUuid: "B6E73094-CED6-458D-B9F5-9D65034F10E0" })
// Only use when user explicitly requests visual verification or debugging visual issues

// Check logs (if debugging)
start_sim_log_cap({
  simulatorUuid: "B6E73094-CED6-458D-B9F5-9D65034F10E0",
  bundleId: "com.readdle.AgenticApp"
})
// ... later ...
stop_sim_log_cap({ logSessionId: "SESSION_ID" })
```

## Verification Workflow

**Typical workflow (2 MCP calls):**

1. `build_run_sim()` - Build, install, and launch app
2. `describe_ui()` - Verify UI elements programmatically (retry if children array is empty - app may still be loading)

**Note:** If `describe_ui()` returns an empty `children` array, retry after a brief delay. The app may still be initializing after launch.

**Avoid redundant calls:**

- ❌ `list_sims()` - Use hardcoded `simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0"`
- ❌ `get_app_bundle_id()` - Use known value: `com.readdle.AgenticApp`
- ❌ `list_schemes()` - Use known value: `AgenticApp`
- ❌ `get_sim_app_path()` - Use `build_run_sim()` instead

## Cleanup Commands

### Stop App

```
stop_app_sim({
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0",
  bundleId: "com.readdle.AgenticApp"
})
```

### Clean Build

```
clean({
  projectPath: "AgenticApp.xcodeproj",
  scheme: "AgenticApp",
  platform: "iOS Simulator"
})
```

## Notes

- Always use `simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0"` (iPhone 16 Pro iOS 18.4)
- **UI Verification**: Use `describe_ui()` by default for all UI inspection. Only use `screenshot()` when visual verification is explicitly needed or requested.
- **Parameter Names**: Build/test commands use `simulatorId`, while UI inspection commands (`describe_ui`, `screenshot`, `start_sim_log_cap`) use `simulatorUuid` - both accept the same UUID value.
