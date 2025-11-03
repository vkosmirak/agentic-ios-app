# Agentic iOS App

An iOS app configured for agent-friendly development using MCP (Model Context Protocol) servers.

## For Agents

This repository is set up for Cursor agents to plan, develop, test, and QA features end-to-end.

**Quick Start**: See [AGENTS.md](./AGENTS.md) for simple instructions on how to build, test, run, and verify the app.

**Setup**: See [AGENT_SETUP.md](./AGENT_SETUP.md) for detailed MCP server configuration and setup instructions.

## MCP Servers

This project uses two MCP servers:

1. **XcodeBuildMCP** - For building and testing iOS apps
2. **ios-simulator-mcp** - For managing iOS simulators

Configuration is in `.cursor/mcp.json`.

## Project Structure

- `AgenticApp/` - Main app source code
- `AgenticAppTests/` - Unit tests
- `AgenticAppUITests/` - UI tests
- `screenshots/` - Screenshots captured during verification
- `.cursor/mcp.json` - MCP server configuration
- `AGENTS.md` - Quick reference for agents
- `AGENT_SETUP.md` - Detailed setup documentation

## Development

This is a SwiftUI iOS app created with Xcode. The app can be built and run on iOS simulators using the configured MCP servers.