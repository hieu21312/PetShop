# Testing Process Standards

Use this file when a task needs a more formal testing-process frame than the lightweight `testing.md` entrypoint.
This file is a secondary testing rule module. Use `testing.md` first for general validation expectations, then use this file when the task needs explicit test-process structure or reporting discipline.

## Standard Testing Flow

1. Analyze requirements, intended behavior, and risk areas.
2. Decide the test scope, strategy, and environment.
3. Design test cases and prepare test data.
4. Set up the required environment.
5. Execute tests, compare expected vs actual behavior, and record failures clearly.
6. Re-test fixes and close the cycle with a clear status summary.

## Test Coverage Expectations

- Cover both success paths and meaningful failure paths where practical.
- Include integration boundaries when the change spans services, APIs, persistence, or background jobs.
- For user-facing workflows, verify real user states rather than only helper functions.
- For bug fixes, verify the original failure pattern is no longer reproducible.

## Test Case Quality

- Each test case should make the preconditions, steps, and expected result clear.
- Prefer deterministic, reproducible test data.
- Keep actual-result capture specific enough to diagnose failures.
- Avoid vague “works correctly” expectations; state what should happen.

## Reporting

- Record failures with enough context to reproduce them.
- Distinguish between test failure, environment failure, and blocked execution.
- Re-test after fixes instead of assuming the fix is correct from inspection alone.
