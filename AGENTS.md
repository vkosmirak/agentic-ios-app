# Agent Instructions

Quick reference guide for agents to build, test, run, and verify the iOS app.

## Project Info

- **Project**: AgenticApp
- **Bundle ID**: `com.readdle.AgenticApp`
- **Scheme**: AgenticApp
- **Project Path**: `AgenticApp.xcodeproj`
- **Simulator UUID**: `B6E73094-CED6-458D-B9F5-9D65034F10E0` (iOS 26.0 iPhone 16 Pro)

## Quick Commands

### Run App (Build + Install + Launch)

```javascript
build_run_sim({
  projectPath: "AgenticApp.xcodeproj",
  scheme: "AgenticApp",
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0"
})
```

### Build Only

```javascript
build_sim({
  projectPath: "AgenticApp.xcodeproj",
  scheme: "AgenticApp",
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0"
})
```

### Run Tests

```javascript
// Unit tests
test_sim({
  projectPath: "AgenticApp.xcodeproj",
  scheme: "AgenticApp",
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0"
})

// UI tests only
test_sim({
  projectPath: "AgenticApp.xcodeproj",
  scheme: "AgenticApp",
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0",
  extraArgs: ["-only-testing:AgenticAppUITests"]
})
```

### Verify App

```javascript
// Inspect UI hierarchy - retry if empty (app may still be loading)
describe_ui({ simulatorUuid: "B6E73094-CED6-458D-B9F5-9D65034F10E0" })
// If children array is empty, retry after a brief delay (app still loading)

// Check logs (if debugging)
start_sim_log_cap({
  simulatorUuid: "B6E73094-CED6-458D-B9F5-9D65034F10E0",
  bundleId: "com.readdle.AgenticApp"
})
// ... later ...
stop_sim_log_cap({ logSessionId: "SESSION_ID" })
```

## Optimized Workflow

**Typical workflow (2 MCP calls):**

1. `build_run_sim()` - Build, install, and launch app
2. `describe_ui()` - Verify UI elements (retry if children array is empty - app may still be loading)

**Note:** If `describe_ui()` returns an empty `children` array, retry after a brief delay. The app may still be initializing after launch.

**Avoid redundant calls:**

- ❌ `list_sims()` - Use hardcoded `simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0"`
- ❌ `get_app_bundle_id()` - Use known value: `com.readdle.AgenticApp`
- ❌ `list_schemes()` - Use known value: `AgenticApp`
- ❌ `get_sim_app_path()` - Use `build_run_sim()` instead

## Notes

- Always use `simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0"` (iPhone 16 Pro iOS 26.0)
- Verification via MCP only - use `describe_ui()` for on-the-fly UI inspection
- App requires iOS 26.0+ - the documented simulator UUID ensures correct version
