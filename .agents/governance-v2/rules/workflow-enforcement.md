# Workflow Enforcement

Use this file to keep agent execution aligned with repository workflow before substantive work begins.

## Required Workflow Declaration

Before substantive work, the agent should explicitly settle these fields:

1. `active_role`
2. `task_classification`
3. `artifact_decision`
4. `workflow_path`
5. `validation_plan`

The declaration may be concise, but it must be operational rather than vague.
A short table is preferred when the client or runtime supports one, because it makes omissions easier to spot.

A workflow declaration is not valid unless all five fields are explicitly settled. If any required field is missing or materially inconsistent with the task, correct the declaration before continuing.

## Gate Rules

- If the task is non-trivial, risky, multi-file, decision-bearing, or otherwise project-memory-worthy, do not proceed with planning or implementation until the required repo artifact is established or explicitly updated.
- If the task asks for a recommendation, approach, proposal, comparison of options, operational direction, architecture direction, or policy choice, default to `planner` rather than answering directly.
- For recommendation, proposal, comparison, operational-direction, architecture-direction, or policy-choice tasks, do not present the final recommendation first. First emit the workflow declaration, confirm the required artifact level, and surface any open decisions that materially affect the recommendation.
- Non-trivial recommendation, proposal, operational-direction, architecture-direction, or policy-choice tasks are project-memory-worthy by default and require a repo task spec before a settled recommendation is presented, even when no code change is requested.
- If the root cause is still unproven and the task is mainly about explaining the failure, default to `debugger` before `planner` or `implementer`.
- If the change is trivial, tightly bounded, and design-decided, `implementer` may proceed after a concise declaration.
- If the task is a workflow, governance, or agent-behavior change, do not silently downgrade it to `Internal only` just because no production code is being edited.

## Completion Gate

- For non-trivial implementation work, completion requires both:
  - an implementation report with explicit evidence
  - a reviewer verdict that makes the current confidence boundary clear
- For non-trivial implementation work, do not silently collapse implementation and final approval into one step.
- If the task makes behavior, state, search, callback, payment, auth, or data-integrity claims, do not mark it complete on build-only evidence.

## Self-Correction Rule

If the first declaration conflicts with repository workflow, the agent should correct the declaration before continuing instead of silently proceeding on the wrong path.

Examples:

- non-trivial task but `artifact_decision` says session-only
- recommendation task but `active_role` says implementer
- unresolved causal investigation but `workflow_path` jumps straight to implementation

## Artifact Gate

Use these values for `artifact_decision` in workflow declarations:

- `Internal only`
  - only for trivial, session-only, or clearly bounded work
- `Repo task spec required`
  - for non-trivial, risky, multi-file, decision-bearing, or project-memory-worthy work
- `Repo task spec + approval-ready plan`
  - when the task needs cross-module design, operational recommendation, business trade-off handling, or implementation approval before code

If the task changes how future agents should behave, artifact strength should usually be at least `Repo task spec required`.

Implementation plans do not substitute for the required repo task spec.

## Open Decisions Gate

Do not silently finalize a recommendation when unresolved choices still exist around:

- domain semantics
- user-visible behavior
- financial treatment
- security posture
- operational risk acceptance

Surface these as open decisions before presenting the final recommendation as settled.

If those choices still materially affect the outcome, present only a provisional recommendation until they are resolved.
