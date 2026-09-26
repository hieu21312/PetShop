# Governance Cleanup Review

This review captures the state of the active config after Phases 1-3 of the governance v2 migration.

## Overall Status

The active governance is now materially cleaner and more layered than before:

- `AGENTS.md` is shorter and closer to a repo constitution.
- core role files are shorter and more role-specific.
- workflow mechanics are no longer duplicated across multiple active files at the same level.
- governance v2 now acts as the delegated source of truth for workflow, role selection, verification/confidence, and response contracts where active files reference it.

## What Is Now Clean Enough

### 1. Global vs role vs workflow boundaries

The most important boundary problems are improved:

- `AGENTS.md` no longer tries to be both constitution and detailed workflow playbook.
- `debugger.md`, `planner.md`, `implementer.md`, and `reviewer.md` now read more like role contracts than policy dumps.
- `.agents/rules/workflow.md` now acts as a short active workflow layer instead of duplicating full planning/debugging mechanics.

### 2. Anti-overclaim and confidence layering

The repo now has a clearer split between:

- short active anti-overclaim guardrails
- detailed verification/confidence rules in governance v2

This reduces the chance that every active file redefines the same epistemic policy in slightly different wording.

### 3. Artifact discipline

The active config is now more consistent about:

- when internal planning is enough
- when a persistent repo artifact is required
- when planning or implementation should pause for the correct role

## What Is Intentionally Still Active and Not Yet Normalized

### Stack-specific rule modules

The following are still intentionally left active and mostly untouched:

- `.agents/rules/api.md`
- `.agents/rules/backend.md`
- `.agents/rules/database.md`
- `.agents/rules/frontend.md`
- `.agents/rules/security.md`
- `.agents/rules/taste-skill.md`

Reason:

- these are not the main source of governance drift
- trimming them too early could mix governance cleanup with stack policy redesign
- the repo benefits more from stabilizing the source-of-truth layers first

### Shared templates under `docs/templates/`

These remain shared artifact templates rather than v2-owned governance rules:

- implementation plan
- task template
- walkthrough template
- tech design
- srs template

Reason:

- they are artifact shapes, not active policy engines
- they can keep serving both active config and governance v2

## Remaining Risks

### 1. Stack-specific modules are still somewhat broad

Some stack modules still contain a mix of:

- useful rules
- broad enterprise standards
- language-wide style guidance

This is acceptable for now, but they should be reviewed later for:

- over-breadth
- non-repo-specific guidance
- hidden policy duplication

### 2. Governance V2 is active by delegation, not globally active

This means:

- the layering is much better
- `rules/` and `templates/` are binding when active files delegate to them
- migration notes and future role proposals are not runtime policy unless explicitly adopted

### 3. Adoption scope is now explicit but still needs maintenance

There is no single “all governance v2 is active” marker.

That is fine for now, but later migration should make clear:

- which v2 files remain proposal/history material
- which v2 files are active source of truth by delegation

## Recommendation

Do not rush Phase 4.

The best next step is:

1. keep the current active stack-specific modules as-is for now
2. use the system in real work for a while
3. note any remaining friction, duplication, or ambiguity
4. only then review stack-specific modules one by one

## Practical Conclusion

The governance cleanup has already crossed the most important threshold:

- the repo now has a clearer distinction between
  - constitution
  - role contracts
  - workflow rules
  - verification/confidence rules
  - reusable templates

That is the biggest structural win.
