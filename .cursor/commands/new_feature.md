# New Feature Command

Plan, implement, test, and verify a new feature following MVVM-C architecture.

**References**: `@ARCHITECTURE.md` for patterns, `@AGENTS.md` for commands.

## Workflow

### 1. Plan
Analyze description and create plan: feature name, models, services, ViewModel, View, Coordinator, tests.

### 2. Implement (in order)
1. Models → `Features/[Feature]/Models/`
2. Service Protocol/Implementation (if new) → `Core/Services/[Service]/`
3. Dependency Registration → `DependencyContainer`
4. ViewModel → `Features/[Feature]/[Feature]ViewModel.swift`
5. Coordinator → `Features/[Feature]/[Feature]Coordinator.swift`
6. View → `Features/[Feature]/[Feature]View.swift`
7. Navigation → Update `AppCoordinator`

Reference existing features (Timers, Alarms, Clock) and `@ARCHITECTURE.md`.

### 3. Test
Write tests: Model, ViewModel, Service (if new). Run tests and make sure all pass. Use `@AGENTS.md` for commands.

### 4. Verify
Build, run, verify UI and functionality. Use `@qa_verify.md` for comprehensive verification workflow.

## Usage

```
@new_feature.md

Feature: [Description]
```
