# Testing Rules

Use this rule when the task needs validation strategy, test-scope decisions, regression coverage, behavior proof, or confidence-strength judgment.

- Run the narrowest validation that can actually support the claim first.
- Add tests when they protect changed behavior, prove a bug fix, or reduce regression risk.
- Do not rewrite unrelated tests to match incidental output changes.
- Prefer deterministic tests over time-, network-, or environment-sensitive tests when possible.
- When a change affects validation, storage, user-facing workflows, or state transitions, cover both success and failure handling where practical.
- For capacity, storage, or environment-specific scenarios, create or reference dedicated test artifacts instead of treating every example as a global always-on rule.
- Build-only validation is not enough for behavioral, correctness, or state claims.

For more formal process guidance, consult:

- `.agents/rules/testing-process.md`
- `.agents/rules/capacity-operations.md`

## Delegate to Governance V2

For verification strength and confidence rules, consult:

- `.agents/governance-v2/rules/verification-confidence.md`
