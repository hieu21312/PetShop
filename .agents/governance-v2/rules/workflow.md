# Governance V2 Workflow

Đây là workflow chuẩn đề xuất cho governance v2.

## Core Flow

1. Classify task.
2. Choose the first role.
3. Decide whether internal planning is enough or a persistent repo artifact is required.
4. Analyze or plan before coding when the task is non-trivial.
5. Implement only after scope and correctness expectations are stable enough.
6. Verify with evidence proportional to the claim.
7. Summarize outcome, confidence boundary, and residual risk.

## Artifact Rule

- Trivial, single-file, session-only, or clearly bounded follow-up tasks:
  internal planning may be enough.
- Small, single-file, behaviorally local fixes with no unresolved domain, financial, security, operational, or user-visible decision:
  use the small-task fast path and do not create a plan artifact just to ask for routine approval.
- Non-trivial, risky, multi-file, project-memory-worthy, payment, search, auth, distributed, or root-cause debugging tasks:
  create or update a persistent repo artifact first.
- Search-related work only requires a persistent repo artifact when it affects indexing consistency, reindex behavior, stale-data behavior, performance-sensitive search architecture, or multi-file query semantics.
- When a persistent artifact is required, check `docs/templates/` for the matching repository template before drafting.
- If a repo spec already exists and no separate persistent implementation plan is required, do not create an extra IDE/session plan artifact just to continue planning.

## Approval Rule

- Ask for approval when the task introduces meaningful behavioral, domain, financial, security, or operational trade-offs.
- Do not ask for approval for routine technical choices that can be resolved from repository evidence.
- Do not create an implementation-plan artifact or approval checkpoint for a local routine technical change when the design is already decided and no open policy decision remains.

## Behavior Change Rule

Every non-trivial change must be labeled as one of:

- `root-cause fix`
- `mitigation`
- `behavior change`

If a change fits more than one label, say so explicitly.

## Confidence Rule

Every non-trivial final answer should distinguish:

- `Confirmed`
- `Likely`
- `Unverified`

This is mandatory when the task includes debugging, performance, data integrity, auth, payment, search, or distributed behavior.

## Completion Rule

Non-trivial implementation work should not be treated as complete unless all of the following are present:

- an explicit `Change Label`
- implementation evidence proportional to the claim
- a reviewer verdict that states the confidence boundary

For non-trivial work, build success alone is not sufficient completion evidence for behavior, state-transition, search, callback, or correctness claims.
