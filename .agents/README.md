# Subagents

Use `.agents` only when the coding tool supports role-based or delegated agents.

## Purpose

- `AGENTS.md` defines repository-wide rules.
- `.agents/` defines role-specific execution behaviors.

Keep subagents narrow.
Do not duplicate repository rules here.

## Recommended Set

- `planner.md`: break down work and identify risks
- `implementer.md`: make focused code changes
- `reviewer.md`: inspect for bugs and regressions
- `debugger.md`: isolate root cause and verify the fix
- `rules/*.md`: reusable rule modules by concern or stack

## Rules For Writing Subagents

- One role per file
- Short instructions only
- No generic philosophy
- No duplicated architecture notes from `AGENTS.md`
- No overlapping ownership between subagents unless necessary

## When Not To Use `.agents`

- Small repositories with simple tasks
- Teams that only use one coding agent mode
- Projects without stable architecture or commands yet

## Suggested Layout

```text
.agents/
  planner.md
  implementer.md
  reviewer.md
  debugger.md
  rules/
    frontend.md
    backend.md
    database.md
    api.md
    testing.md
    security.md
  skills/
    docs-spec-workflow/
      SKILL.md
    frontend-testing/
      SKILL.md
```
