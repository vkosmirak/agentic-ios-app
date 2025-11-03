# iOS Agent Environment Setup Plan

## Overview
Configure MCP servers (XcodeBuildMCP and ios-simulator-mcp) to enable Cursor agents to build, test, run, and verify iOS apps on simulators end-to-end using Model Context Protocol.

## MCP Servers

### 1. XcodeBuildMCP
**Purpose**: Xcode operations (build, test, run)

**Capabilities**:
- Build iOS apps using `xcodebuild`
- Run unit tests and UI tests
- Handle build configurations (Debug/Release)
- Structured output for AI consumption
- Error handling and reporting

**Use Cases**:
- Build the app: `xcodebuild build`
- Run tests: `xcodebuild test`
- Get build status and errors
- Check test results

### 2. ios-simulator-mcp
**Purpose**: iOS Simulator management and control

**Capabilities**:
- List available simulators
- Boot/shutdown simulators
- Install apps on simulator
- Launch apps
- Capture screenshots
- UI interaction and element inspection
- Check app state and logs

**Use Cases**:
- Boot simulator device
- Install app bundle
- Launch app by bundle identifier
- Verify app is running
- Capture screenshots for verification
- Inspect UI elements

## Configuration

### MCP Server Setup

Configure both servers in Cursor settings or `.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "xcodebuild": {
      "command": "npx",
      "args": ["-y", "@xcodebuild/mcp"],
      "description": "Xcode build and test operations"
    },
    "ios-simulator": {
      "command": "npx",
      "args": ["-y", "@ios-simulator/mcp"],
      "description": "iOS Simulator management"
    }
  }
}
```

Note: Adjust the command paths based on actual installation method of these MCP servers.

## Agent Workflow

### End-to-End Verification Process

1. **Build Phase** (using XcodeBuildMCP)
   - Build the app: `xcodebuild -project AgenticApp.xcodeproj -scheme AgenticApp -sdk iphonesimulator -configuration Debug build`
   - Verify build succeeds
   - Locate built .app bundle

2. **Simulator Setup** (using ios-simulator-mcp)
   - List available simulators
   - Select or boot a simulator device (e.g., iPhone 15)
   - Verify simulator is ready

3. **Installation** (using ios-simulator-mcp)
   - Install app bundle on simulator
   - Verify installation succeeded

4. **Launch** (using ios-simulator-mcp)
   - Launch app using bundle identifier: `com.readdle.AgenticApp`
   - Wait for app to start
   - Verify app process is running

5. **Verification** (using ios-simulator-mcp)
   - Capture screenshot
   - Inspect UI elements
   - Check app logs for errors/crashes
   - Verify app UI is responsive

6. **Testing** (using XcodeBuildMCP)
   - Optionally run UI tests
   - Verify test results

## Available MCP Tools/Commands

### XcodeBuildMCP Tools
- `xcodebuild_build` - Build the project
- `xcodebuild_test` - Run tests
- `xcodebuild_clean` - Clean build artifacts
- `xcodebuild_list_devices` - List available devices/simulators
- `xcodebuild_get_build_status` - Check build status

### ios-simulator-mcp Tools
- `simulator_list` - List available simulators
- `simulator_boot` - Boot a simulator device
- `simulator_shutdown` - Shutdown a simulator
- `simulator_install` - Install app on simulator
- `simulator_launch` - Launch app on simulator
- `simulator_screenshot` - Capture screenshot
- `simulator_get_app_state` - Check if app is running
- `simulator_ui_inspect` - Inspect UI elements
- `simulator_logs` - Get simulator logs

## Agent Instructions

### Quick Start

1. **Verify Setup**
   - Check MCP servers are installed and configured
   - Verify Xcode command-line tools are available

2. **Build App**
   - Use XcodeBuildMCP to build the app
   - Verify build succeeds and locate .app bundle

3. **Run on Simulator**
   - Use ios-simulator-mcp to boot simulator
   - Install app using simulator_install
   - Launch app using simulator_launch

4. **Verify**
   - Capture screenshot using simulator_screenshot
   - Check app state using simulator_get_app_state
   - Review logs using simulator_logs

### Example Agent Commands

```bash
# Build the app
MCP: xcodebuild_build --project AgenticApp.xcodeproj --scheme AgenticApp --sdk iphonesimulator

# List simulators
MCP: simulator_list

# Boot iPhone 15 simulator
MCP: simulator_boot --device "iPhone 15"

# Install app
MCP: simulator_install --device "iPhone 15" --app "build/Debug-iphonesimulator/AgenticApp.app"

# Launch app
MCP: simulator_launch --device "iPhone 15" --bundle-id "com.readdle.AgenticApp"

# Capture screenshot
MCP: simulator_screenshot --device "iPhone 15" --output "screenshots/verify.png"

# Verify app is running
MCP: simulator_get_app_state --device "iPhone 15" --bundle-id "com.readdle.AgenticApp"
```

## Files Structure

```
/Users/vkosmirak/src/agentic-ios-app/
├── AgenticApp/
│   ├── AgenticAppApp.swift
│   └── ContentView.swift
├── AgenticApp.xcodeproj/
├── .cursor/
│   └── mcp.json (MCP server configuration)
├── screenshots/ (generated during verification)
├── README.md
├── AGENT_SETUP.md (this file - setup documentation)
└── AGENTS.md (agent instructions - quick reference)
```

## Files to Create

### AGENTS.md
Simple, concise instructions for agents on common tasks:
- How to build the app
- How to run unit tests
- How to run UI tests
- How to run app on simulator
- How to verify app is working
- Quick command reference using MCP tools
- Common workflows

## Troubleshooting

### Common Issues

1. **MCP servers not found**
   - Verify servers are installed: `npm list -g @xcodebuild/mcp @ios-simulator/mcp`
   - Check Cursor MCP configuration
   - Ensure Node.js/npm is available

2. **Simulator not booting**
   - Check available simulators: `xcrun simctl list devices`
   - Verify Xcode command-line tools: `xcode-select -p`
   - Try booting manually: `xcrun simctl boot "iPhone 15"`

3. **Build failures**
   - Verify Xcode project is valid
   - Check build settings and schemes
   - Review XcodeBuildMCP error output

4. **App not launching**
   - Verify bundle identifier matches: `com.readdle.AgenticApp`
   - Check app is installed: `xcrun simctl listapps <device-id>`
   - Review simulator logs for errors

## Next Steps

1. Install XcodeBuildMCP and ios-simulator-mcp MCP servers
2. Configure MCP servers in Cursor settings
3. Test end-to-end workflow manually
4. Create `AGENTS.md` with simple instructions for agents (how to run/verify/run tests etc.)
5. Document any additional MCP tools discovered
6. Create agent-friendly examples and templates

## Resources

- XcodeBuildMCP documentation: [to be added]
- ios-simulator-mcp documentation: [to be added]
- MCP Protocol documentation: https://modelcontextprotocol.io
- Xcode Command Line Tools: https://developer.apple.com/xcode/

