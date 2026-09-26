# Phase 4 Status

This note records the current outcome of the Phase 4 review for stack-specific rule modules.

## Reviewed Files

### 1. `.agents/rules/api.md`

- Status: `trimmed`
- Outcome:
  - kept concise API contract and transport-boundary guidance
  - removed broad enterprise error, logging, and masking policy from this layer
- Rationale:
  - the file is more useful as a local API execution guide than as a global policy container

### 2. `.agents/rules/backend.md`

- Status: `trimmed`
- Outcome:
  - kept backend structure, side-effect, and failure-path guidance
  - removed generic multi-language coding standards for stacks not relevant to this repo
  - narrowed stack notes to repo-relevant backend technologies
- Rationale:
  - the active backend rule should help with this repo's backend work, not serve as a universal language handbook

### 3. `.agents/rules/database.md`

- Status: `trimmed`
- Outcome:
  - kept persistence, rollback, data-safety, and migration-risk guidance
  - removed environment-specific backup and hardware recommendations
- Rationale:
  - hardware and backup topology are operational concerns, not core database-editing guidance for normal agent turns

### 4. `.agents/rules/frontend.md`

- Status: `trimmed`
- Outcome:
  - kept component, state, responsiveness, and accessibility guidance
  - removed heavy design-system and generic framework-style prose
  - delegated advanced visual direction to `.agents/rules/taste-skill.md`
- Rationale:
  - the frontend rule should stay execution-oriented and let the taste playbook own advanced design direction

### 5. `.agents/rules/security.md`

- Status: `trimmed`
- Outcome:
  - kept code- and review-relevant security guardrails
  - removed broader organizational and infrastructure administration policy
- Rationale:
  - the active security file should focus on behavior an agent can apply directly during repository work

### 6. `.agents/rules/taste-skill.md`

- Status: `kept`
- Outcome:
  - left unchanged for now
- Rationale:
  - this file is a specialized frontend taste/playbook module rather than a major governance-drift source
  - it is better evaluated through real frontend tasks than trimmed preemptively

## Overall Assessment

Phase 4 has reduced over-breadth in the stack-specific rule layer without forcing a full redesign.

The active stack modules are now more clearly separated into:

- API transport guidance
- backend structure guidance
- database/persistence guidance
- frontend execution guidance
- cross-cutting security guidance
- specialized frontend taste guidance

## Recommendation

Do not expand Phase 4 further right now.

Use the current rules in real tasks and only reopen stack-specific cleanup when one of these appears:

- repeated confusion about file ownership
- obvious duplication with governance core
- stack-specific guidance that is still too broad to follow
- real task friction caused by the remaining module wording
