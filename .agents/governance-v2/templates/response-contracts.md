# Governance V2 Response Contracts

This file defines the minimum response shape for each role.

## Debugger

1. Reproduction Status
2. Evidence Collected
3. Hypotheses
4. False Positive Check (non-trivial only)
5. Root Cause or Best-Supported Current Cause
6. Missing Proof / Next Check
7. Mitigation vs Full Fix
8. Fix Plan
9. Verification Plan
10. Recurrence Prevention

For non-trivial work, the debugger response must also include:
- `Confidence Boundary`: whether the root cause is Confirmed, Likely, or Unverified
- `Strongest Missing Proof`: the single next check that would confirm or falsify

## Planner

1. Problem Statement
2. Goals & Non-Goals
3. Affected Areas & Proposed Changes
4. Alternative Designs & Trade-offs
5. Critical Flaw Analysis (non-trivial only)
6. Cross-Cutting Concerns
7. Verification Plan
8. Rollback Plan
9. Open Decisions if required

## Implementer

0. Blast Radius Analysis (non-trivial only)
1. Scope Implemented
2. What Changed
3. Validation Run
4. Remaining Risk

For non-trivial work, the implementer response must also include:

- `Change Label`: `root-cause fix`, `mitigation`, or `behavior change`
- `Why This Change`: the core reason or mechanism being changed
- `Commands Run`: exact commands, targeted checks, or manual verification actually performed
- `Behavior Verified`: the behavior directly supported by those checks
- `Still Unverified`: important behavior, edge case, or path not yet proven
- `Strongest Missing Proof`: the single best next check that would materially increase confidence

## Reviewer

0. Destructive Thinking (non-trivial only)
1. Findings
2. Open Questions / Assumptions
3. Summary

For non-trivial work, the reviewer response must also make explicit:

- `Review Verdict`: `approve`, `approve with residual risk`, or `needs more work`
- `Evidence Basis`: what commands, behavior checks, tests, demos, or code-path evidence the verdict relies on
- `Confidence Boundary`: whether the current evidence supports compile confidence only, or also behavior confidence
- `Remaining Unverified`: what important uncertainty still exists after review
- `Blocking Gap`: the single biggest missing proof or correction if the verdict is not approval

## Global Response Rules

### Confidence Labels
When uncertainty exists, every role should prefer short explicit labels over implied certainty.
Use `Confirmed`, `Likely`, and `Unverified` where helpful.

### Overclaim Blacklist
The following phrases are PROHIBITED in any role's output unless the claim is backed by runtime evidence (test pass, log trace, live reproduction):

**Vietnamese:** "hoàn hảo", "không có rủi ro", "đã fix triệt để", "hoàn toàn chuẩn xác", "rất bảo mật", "không phát hiện rủi ro", "an toàn tuyệt đối", "chạy đúng 100%"

**English:** "perfect", "no risk", "fully secure", "completely safe", "no issues found", "flawless", "zero risk", "bulletproof"

If only code-trace evidence exists, the maximum allowed confidence is `Likely`.

### Self-Correction Gate (All Roles)
Before delivering any non-trivial response, every role MUST internally verify:
1. Does my conclusion rely on runtime evidence or only code-trace?
2. Does my response contain any Overclaim Blacklist phrases?
3. Does my response include ALL required headings from my role's Output Contract?
4. Did I complete my role-specific Destructive Thinking block BEFORE my conclusion?

If any check fails, fix the response before delivering.
