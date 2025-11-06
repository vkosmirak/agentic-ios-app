# QA Verify Command

Build, run, and verify functionality of the iOS app in the simulator.

**References**: `@AGENTS.md` for project info and commands.

## Workflow

### Phase 1: Plan (Upfront Preparation)

1. **Read context** to understand what to verify
2. **If no context provided** - ask user what to test. Do NOT proceed without clear instructions
3. **If context provided** - create a detailed test plan upfront:
   - List all verification steps in order
   - Specify what to check (UI elements, states, functionality)
   - Include expected outcomes for each step
   - Present the plan before execution

### Phase 2: Execute (Only After Plan is Ready)

Execute the prepared test plan step by step:

1. **Build & Run**: `build_run_sim()` then `open_sim()`
2. **Navigate**: Use `tap()` to reach the feature/screen
3. **Verify UI**: `describe_ui()` - Check for duplicates, state correctness, reference design compliance
4. **Test**: Perform actions and verify expected behavior
5. **Report**: List pass/fail for each test case

**Note:** If `describe_ui()` returns empty `children`, retry after a brief delay.

## UI Verification Checklist

**Before marking complete, verify:**

1. **No Duplicates**: Count buttons/labels with same `AXLabel` - should match expected count per state
2. **State Correctness**: Verify UI updates for all states (empty → running → stopped)
3. **Reference Design**: Compare with Apple Clock/etc. - button placement and visibility should match

**Important:** Always create the test plan FIRST, then execute it. Never execute steps without a prepared plan.

## Notes

- Use `simulatorId: "B6E73094-CED6-458D-B9F5-9D65034F10E0"` for build/test
- Use `simulatorUuid: "B6E73094-CED6-458D-B9F5-9D65034F10E0"` for UI inspection
- Use `describe_ui()` by default, `screenshot()` only when needed visually

