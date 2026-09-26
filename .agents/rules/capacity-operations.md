# Capacity & Operations Testing Guidance

Use this file when tasks touch storage limits, cleanup behavior, retention, quota handling, or operational resilience.
This file is a specialized testing module, not a general validation baseline. Use it alongside `testing.md` when the task includes capacity, quota, cleanup, or operational-failure scenarios.

## Focus Areas

- storage-capacity thresholds
- database quota and write-failure handling
- automatic cleanup and retention behavior
- full-disk or full-quota failure handling
- alerts, logs, and admin visibility

## Minimum Expectations

- Prefer simulation or bounded test environments over destructive tests on real production resources.
- Check both warning-threshold behavior and hard-failure behavior.
- Verify rollback or failure-safety when writes cannot complete.
- Verify the system returns useful operator or user-facing signals instead of crashing silently.

## Typical Scenarios

### Threshold Warning

- Simulate low remaining storage.
- Verify warnings, logs, and alerting behavior.

### Quota Exceeded

- Simulate DB or storage quota exhaustion.
- Verify the app rejects new writes safely and does not corrupt prior data.

### Auto-Cleanup / Retention

- Simulate capacity pressure and run cleanup or retention jobs.
- Verify only intended data is cleaned and that free capacity returns to a safe range when applicable.

### Full Capacity Failure

- Simulate 0-byte-free or equivalent hard exhaustion.
- Verify the system fails safely, reports the issue clearly, and avoids partial or inconsistent state where possible.

## Output Expectations

- State what was simulated.
- State what the expected safe behavior is.
- State what was actually observed.
- State residual operational risk if full verification could not be run.
