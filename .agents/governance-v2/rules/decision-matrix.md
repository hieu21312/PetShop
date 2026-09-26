# Governance V2 Decision Matrix

Use this file to choose the right first role and artifact level.

## Role Selection

- Use `debugger` first when:
  - the root cause is unclear
  - different outputs disagree
  - query/runtime behavior matters
  - a plausible explanation still lacks proof

- Use `planner` first when:
  - the task spans modules
  - workflow or business semantics may change
  - there are real design trade-offs
  - project memory is valuable
  - the user asks for a recommendation, approach, proposal, comparison of options, operational direction, architecture direction, or policy choice

- Use `implementer` first when:
  - the change is trivial or tightly bounded
  - the design is already decided
  - the evidence is sufficient and no important open decision remains
  - the task is not mainly asking for a recommendation or decision framework

- Use `reviewer` first when:
  - a patch or plan already exists
  - the main need is correctness/risk review

## Artifact Selection

- `Internal only`
  - typo, copy-only, comment-only, single-line safe tweak, narrow follow-up, short research
  - small, single-file, behaviorally local fix with stable scope and no unresolved domain, financial, security, operational, or user-visible decision
  - bounded query-builder, read-path, or UI-local tweak that does not redesign search semantics, indexing consistency, workflow behavior, or policy
  - not valid for non-trivial recommendation, proposal, workflow redesign, operational-direction, or policy-bearing tasks
  - if you hesitate between `Internal only` and a stronger artifact, do not use `Internal only`

- `Repo task spec required`
  - moderate task, reusable context, meaningful follow-up risk, or small config/governance change
  - documentation or workflow work that is not risky enough for a full plan, but should survive the session
  - baseline/rule cleanup where future agents benefit from the recorded intent
  - bug/performance/search/auth/payment/distributed work
  - multi-file workflow or design changes
  - tasks likely to matter beyond the session
  - search work that affects indexing consistency, reindex paths, stale-data behavior, performance-sensitive search architecture, or multi-file query semantics

- `Repo task spec + approval-ready plan`
  - recommendation, proposal, operational-direction, or policy-bearing tasks that need approval-ready reasoning
  - tasks with meaningful domain, financial, security, operational, user-visible, or implementation trade-offs
  - implementation work where scope is not yet stable enough to code safely

## Fast Checks

Use this quick test after the first pass:

- If the task changes workflow, policy, approval behavior, or project-memory guidance, prefer at least `Repo task spec required`.
- If the task changes payment, callback, state, search, auth, or data-integrity behavior, use at least `Repo task spec required`.
- If the task can reasonably affect future agent behavior beyond the current turn, do not leave it as `Internal only`.

## Workflow Gates

- If the task is recommendation- or proposal-bearing, do not skip directly to a final answer when planner-first reasoning is required.
- If the task is non-trivial but the artifact decision is weaker than the repo workflow requires, strengthen the artifact decision before continuing.
- If important domain, security, financial, user-visible, or operational decisions remain unresolved, surface them as open decisions instead of silently choosing for the user.
- If the task is bounded query-build, read-path, or UI-local work, do not force full stateful-flow or writer-chain framing unless the same visible behavior is actually controlled by multiple writers.

## Escalation Selection

- Ask the user only when a decision is truly about:
  - domain semantics
  - user-visible behavior
  - financial treatment
  - security posture
  - operational risk acceptance

- Do not escalate:
  - routine naming
  - file placement
  - code organization within established patterns
  - ordinary technical choices that repository evidence can settle
