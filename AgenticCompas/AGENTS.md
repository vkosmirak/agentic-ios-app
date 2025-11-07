# Agent Instructions

Quick reference guide for agents to build, test, run, and verify the iOS app.

**For architecture details**: See [ARCHITECTURE.md](./ARCHITECTURE.md) for MVVM-C patterns, dependency injection, and project structure.

**Note**: All paths are relative to the workspace root (`/Users/vkosmirak/src/agentic-ios-app/AgenticCompas/`). If running from a different directory, use absolute paths. All commands shown are MCP (Model Context Protocol) tool calls.

**⚠️ IMPORTANT: Do NOT use `xcodebuild` directly.** Always use the MCP tool calls provided (e.g., `build_run_sim()`, `test_sim()`, `build_sim()`) instead of running `xcodebuild` commands via terminal.

## Project Info

- **Project**: AgenticCompas
- **Bundle ID**: `com.vkosmirak.AgenticCompas`
- **Scheme**: AgenticCompas
- **Project Path**: `AgenticCompas.xcodeproj`
- **Simulator UUID**: `B6E73094-CED6-458D-B9F5-9D65034F10E0` (iOS 26.0 iPhone 16 Pro)

## Quick Commands

### Run App (Build + Install + Launch)

```
build_run_sim({
  projectPath: "AgenticCompas.xcodeproj",
  scheme: "AgenticCompas",
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0"
})
open_sim()  // Ensure simulator window is visible and active on Mac
```

### Build Only

```
build_sim({
  projectPath: "AgenticCompas.xcodeproj",
  scheme: "AgenticCompas",
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0"
})
```

### Run Unit Tests

```
// Run all unit tests
test_sim({
  projectPath: "AgenticCompas.xcodeproj",
  scheme: "AgenticCompas",
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0",
  extraArgs: ["-only-testing:AgenticCompasTests"]
})

// Run specific test class
test_sim({
  projectPath: "AgenticCompas.xcodeproj",
  scheme: "AgenticCompas",
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0",
  extraArgs: ["-only-testing:AgenticCompasTests/TimeServiceTests"]
})

// Run specific test method
test_sim({
  projectPath: "AgenticCompas.xcodeproj",
  scheme: "AgenticCompas",
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0",
  extraArgs: ["-only-testing:AgenticCompasTests/TimeServiceTests/testCurrentTimeReturnsValidDate"]
})
```

### Run UI Tests

```
// Run all UI tests
test_sim({
  projectPath: "AgenticCompas.xcodeproj",
  scheme: "AgenticCompas",
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0",
  extraArgs: ["-only-testing:AgenticCompasUITests"]
})

// Run specific UI test class
test_sim({
  projectPath: "AgenticCompas.xcodeproj",
  scheme: "AgenticCompas",
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0",
  extraArgs: ["-only-testing:AgenticCompasUITests/WorldClockTabUITests"]
})
```

### Verify Functionality

**For detailed verification workflow and UI checklist, see `@qa_verify.md`**

Quick verification:
1. `build_run_sim()` - Build, install, and launch app
2. `describe_ui()` - Verify UI elements programmatically
3. Navigate and test functionality

Use `@qa_verify.md` command for comprehensive verification with UI checklist and test case planning.

**Avoid redundant calls:**

- ❌ `xcodebuild` - Use MCP tools (`build_run_sim()`, `test_sim()`, etc.) instead
- ❌ `list_sims()` - Use hardcoded `simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0"`
- ❌ `get_app_bundle_id()` - Use known value: `com.vkosmirak.AgenticCompas`
- ❌ `list_schemes()` - Use known value: `AgenticCompas`
- ❌ `get_sim_app_path()` - Use `build_run_sim()` instead

## Cleanup Commands

### Stop App

```
stop_app_sim({
  simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0",
  bundleId: "com.vkosmirak.AgenticCompas"
})
```

### Clean Build

```
clean({
  projectPath: "AgenticCompas.xcodeproj",
  scheme: "AgenticCompas",
  platform: "iOS Simulator"
})
```

## Notes

- **Never use `xcodebuild` directly** - Always use MCP tool calls (`build_run_sim()`, `test_sim()`, `build_sim()`, etc.)
- Always use `simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0"` (iPhone 16 Pro iOS 18.4)
- **Verification**: Use `@qa_verify.md` command for comprehensive verification workflow and UI checklist
- **Parameter Names**: Build/test commands use `simulatorId`, while UI inspection commands (`describe_ui`, `screenshot`, `start_sim_log_cap`) use `simulatorUuid` - both accept the same UUID value.

