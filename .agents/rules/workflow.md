# Workflow Constraints & Rules

## Core Directive

- For non-trivial, risky, multi-file, bug/performance, architecture, payment, search, auth, distributed, or other project-memory-worthy work, do not plan or write production code before the required repo artifact exists.
- For trivial, single-file, session-only, or clearly bounded follow-up tasks, internal planning may be enough unless the user asks for a persistent repo artifact.
- Before modifying production files for non-trivial work, make sure the task is decision-ready at the correct role boundary.
- For recommendation, proposal, comparison, operational-direction, architecture-direction, or policy-choice tasks, route through planner-first unless the task is trivial and purely informational.

## Active Sequence

1. Classify the task and emit a short workflow declaration.
2. Choose the right first role.
3. Decide whether internal planning is enough or a persistent repo artifact is required.
4. Read repository rules, then the active role, then focused rule modules.
5. Analyze or plan before coding when the task is non-trivial.
6. Implement only when scope, evidence, and approval state are sufficient.
7. Verify proportionally to the claim and summarize residual risk.

## Rule Trigger Matrix

Use this matrix after the workflow declaration is made. Read the relevant focused rule files before concluding, planning, implementing, debugging, or approving the task.

- **Planning, recommendation, workflow change, architecture direction, or policy choice**
  - Read: `.agents/rules/senior-planning.md`
- **Non-trivial debugging, incident analysis, runtime failure investigation, or unclear root cause**
  - Read: `.agents/rules/senior-debugging.md`
- **Stateful, callback-driven, multi-writer, payment-state, shipment-state, order-state, indexing, reindexing, sync, or stale-data task**
  - Read: `.agents/rules/stateful-flows-and-syncs.md`
- **Performance, search, reporting, export, pagination, heavy filtering, heavy sorting, or data-heavy list path**
  - Read: `.agents/rules/performance-search-reporting-planning.md`
- **AI-generated-code risk, dependency suggestion, high-risk zone, or incomplete multi-layer wiring concern**
  - Read: `.agents/rules/ai-failure-prevention.md`
- **API contract, request validation, response shape, status code, or client-visible error behavior**
  - Read: `.agents/rules/api.md`
- **Backend service, business logic, controller/service separation, side effects, or async request-path behavior**
  - Read: `.agents/rules/backend.md`
- **Frontend component, UI behavior, form state, layout, responsiveness, accessibility, or data-table behavior**
  - Read: `.agents/rules/frontend.md`
- **Concrete UI/UX standards beyond the lightweight frontend entrypoint**
  - Read: `.agents/rules/ui-ux.md`
- **Advanced visual direction, anti-slop landing-page work, or stronger aesthetic constraints**
  - Read: `.agents/rules/taste-skill.md`
- **Schema, persistence behavior, migration, query write-path, rollback, or storage-safety change**
  - Read: `.agents/rules/database.md`
- **Auth, authorization, input trust, uploads, token handling, ownership, or secret-sensitive work**
  - Read: `.agents/rules/security.md`
- **Validation strategy, regression proof, tests, or confidence-strength decision**
  - Read: `.agents/rules/testing.md`
- **Formal test-process framing, test case design, execution reporting, or blocked-vs-failed test distinction**
  - Read: `.agents/rules/testing-process.md`
- **Capacity, quota, retention, cleanup, or operational-resilience testing scenario**
  - Read: `.agents/rules/capacity-operations.md`

When multiple categories apply, read all relevant modules. Do not replace a domain-specific rule with a more generic one if both apply.

## Guardrails

- Do not anchor on the first obvious suspect when later layers still transform, slice, deduplicate, rerank, cache, or fall back.
- For stateful, callback-driven, search-sync, or multi-writer runtime tasks, inspect the owner of truth and writer chain before treating one edited path as the full fix.
- Do not escalate routine technical choices to the user when repository evidence can settle them.
- Do not hide a mitigation as a root-cause fix.
- Do not rely on build-only validation for behavioral or correctness claims.
- Do not call a stateful-flow fix complete without checking the narrowest relevant golden flow, at least by code path when runtime execution is blocked.
- For non-trivial work, do not treat the task as complete until implementation evidence and a reviewer verdict are both explicit.
- For non-trivial work, do not let the same role silently act as both the final implementer and the final approver of the change.
- If the workflow declaration is wrong for the task type, correct it before continuing.

## Self-Check Gate

Before finalizing a conclusion, recommendation, implementation report, debug result, or review verdict, verify all of the following:

1. The chosen role still matches the real task shape.
2. The artifact decision still matches repo workflow requirements.
3. All required focused rule modules were actually read for the task domain.
4. Any named or triggered skill is truly relevant and not being used as a substitute for repo-critical policy.
5. The validation strength matches the claim being made.
6. The confidence level is honest about what is confirmed, likely, and still unverified.
7. The current response does not silently widen scope, add speculative fallback behavior, or answer a different task than the user asked.

If any item fails, correct the workflow before finalizing the response.

## Delegate to Governance V2

For detailed workflow mechanics, consult:

- `.agents/governance-v2/rules/workflow.md`
- `.agents/governance-v2/rules/workflow-enforcement.md`
- `.agents/rules/runtime-guardrails.md`

For role and artifact selection, consult:

- `.agents/governance-v2/rules/decision-matrix.md`

For verification strength, confidence labels, and anti-overclaim rules, consult:

- `.agents/governance-v2/rules/verification-confidence.md`

[RULE_TOKEN: WKF-77X9]
