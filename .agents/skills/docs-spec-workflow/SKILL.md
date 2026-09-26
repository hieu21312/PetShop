---
name: managing-docs-spec-workflow
description: Use this skill when non-trivial work needs persistent repo artifacts such as task specs, implementation plans, or walkthrough notes.
---

# Managing Docs Spec Workflow

Use this skill to keep persistent planning and delivery artifacts aligned with the active governance rules.
This skill is specialized workflow support, not the primary source of repo-critical policy. Always follow `AGENTS.md` and the active role files first.

## When to use this skill

- Use it for non-trivial, risky, multi-file, project-memory-worthy, bug/performance, search, auth, payment, distributed, or design-heavy tasks.
- Do not use it for trivial, single-file, session-only, or purely exploratory tasks unless the user explicitly asks for a persistent repo artifact.

## What this skill should enforce

1. Create or update a repo task spec when the artifact rule requires it.
2. Use repository templates for persistent artifacts.
3. Keep specs, plans, and walkthroughs aligned with the approved scope.
4. Do not let documentation policy drift away from the active governance rules.
5. Do not introduce repo-critical policy that exists only inside this skill.

## Delegate to Governance V2

For artifact selection and workflow rules, consult:

- `.agents/governance-v2/rules/workflow.md`
- `.agents/governance-v2/rules/decision-matrix.md`

For response-contract guidance, consult:

- `.agents/governance-v2/templates/response-contracts.md`
