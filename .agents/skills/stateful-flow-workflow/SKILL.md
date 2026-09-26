---
name: stateful-flow-workflow
description: Use this skill when the user asks Codex or Antigravity to work on status, sub-status, payment state, order state, warehouse state, shipment state, callback, worker, sync, stale-data, or multi-writer behavior. It enforces owner-of-truth tracing, writer-chain checks, and golden-flow validation.
---

# Stateful Flow Workflow

Use this skill for stateful or synchronized business flows.
Pair it with the active role workflow.

## Required Reads

Read:

- `AGENTS.md`
- `GEMINI.md`
- `.agents/rules/stateful-flows-and-syncs.md`
- `docs/ai/rules/sumix-stateful-domain-map.md` when Sumix domain state is involved
- `docs/ai/rules/sumix-golden-flows.md` when a golden flow exists
- Active role file.

## Writer Chain Gate

Before editing, identify:

- source of truth
- direct writer path
- bulk writer path
- callback/worker path
- cleanup/reconciliation path
- frontend/client sync path
- fields being written, such as `Status`, `SubStatus`, `PaymentStatus`, `ShippingStatus`

Do not patch one writer if another writer can immediately overwrite it.

## Golden Flow Gate

State the narrowest flow that must remain correct.
Trace current state -> transition -> expected state.
Use existing constants instead of new status strings when available.

## Validation

Build success only proves compile.
Runtime state verification needs API/DB/log evidence; label it unverified when not run.
