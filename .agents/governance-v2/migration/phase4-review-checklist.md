# Phase 4 Review Checklist

Use this checklist when reviewing stack-specific rule modules during Phase 4.

## Goal

Review stack-specific rule files for breadth, duplication, and layering quality without rushing a redesign.

## In Scope

- `.agents/rules/api.md`
- `.agents/rules/backend.md`
- `.agents/rules/database.md`
- `.agents/rules/frontend.md`
- `.agents/rules/security.md`
- `.agents/rules/taste-skill.md`

## Review Principles

- Prefer preserving useful stack guidance over aggressively trimming.
- Do not treat stack cleanup as an excuse to rewrite technical policy.
- Do not move rules into governance v2 unless they are truly governance-level or cross-cutting.
- Keep repo-specific, execution-relevant guidance close to the stack module unless there is a clear duplication problem.

## Questions To Ask For Each File

1. Does this file still serve a clear stack-specific purpose?
2. Which sections are truly repo-specific, and which are generic engineering advice?
3. Which rules duplicate `AGENTS.md`, role files, workflow, or governance v2?
4. Which rules are active execution guidance, and which are policy better owned elsewhere?
5. Does the file mix multiple layers, such as stack rules, governance rules, and style preferences?
6. Are there rules that are too broad to be reliably followed in normal turns?
7. Are there hidden domain-policy decisions embedded in what should be technical guidance?
8. Would trimming this file improve clarity, or would it remove context that agents actually need?

## Classification Options

- `keep`
  Keep the file essentially as-is because it is useful and not causing governance drift.
- `trim`
  Remove generic or duplicated sections while preserving stack-specific guidance.
- `delegate`
  Leave the file active but point repeated governance concepts to v2 source-of-truth files.
- `merge`
  Move a clearly cross-cutting section into a more appropriate shared rule later.
- `leave unchanged for now`
  Explicitly defer cleanup because the file is not a current blocker and the risk of churn is higher than the value.

## Red Flags

- The file redefines workflow, role behavior, or verification policy that already exists elsewhere.
- The file reads like a generic enterprise standard instead of repo-specific guidance.
- The file contains long prose that does not change agent behavior.
- The file mixes hard requirements with taste preferences without labeling them.
- The file silently changes semantics that should remain stack-local.

## Expected Output Per File Review

1. Current purpose of the file
2. Proven duplication or over-breadth
3. Recommended action: keep / trim / delegate / merge / leave unchanged for now
4. Reasoning for that action
5. Any later follow-up worth tracking

## Success Condition

Phase 4 is successful when each stack-specific module has a deliberate status and a justified next action, not when every file is aggressively rewritten.
