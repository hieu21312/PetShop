# Senior Planning

Use this rule for non-trivial planning, design direction, implementation proposals, architecture choices, workflow changes, and approval-ready recommendations.

## Goal

Plan like a senior engineer: define the real problem first, choose the smallest sound direction, compare meaningful alternatives, make trade-offs explicit, and prepare a decision-ready path to implementation.

## Core Model

Always separate these layers:

1. Problem statement
2. Goals and non-goals
3. Constraints and invariants
4. Candidate options
5. Chosen direction and rationale
6. Change set and affected areas
7. Verification
8. Rollback or mitigation path
9. Open decisions

Do not collapse these layers into a file-by-file todo list.

## Senior Planning Checklist

Before calling a plan approval-ready, check the relevant items below:

- **Problem Precision:** Can you state what is actually wrong, needed, or being decided before naming a solution?
- **Scope Discipline:** Are goals and non-goals explicit enough to prevent scope creep during implementation?
- **Constraint Awareness:** Did you capture the relevant business rules, technical constraints, performance concerns, compatibility needs, and workflow boundaries?
- **Option Quality:** Did you consider at least one meaningful alternative for risky, design-bearing, or hard-to-reverse work?
- **Trade-off Clarity:** Did you explain what is gained and what is given up across correctness, maintainability, performance, rollout safety, and operational risk?
- **Layer Placement:** Did you place filtering, aggregation, orchestration, validation, caching, or fallback logic at the correct layer?
- **Smallest Viable Change:** Is the chosen direction the smallest sound change set that still solves the real problem?
- **Approval Readiness:** Are only true domain, user-visible, financial, security, or operational decisions left for the user?
- **Verification Fit:** Does the verification plan actually prove the important claims of the chosen direction?
- **Rollback Readiness:** If the change misbehaves, is there a clear rollback, disablement, or mitigation path?

## Option Framing

When a task is non-trivial, avoid presenting a single-path recommendation without context.

Prefer to show:

- the primary option
- the main rejected option
- why the primary option is preferred now
- when the rejected option would become reasonable later

This keeps the plan decision-ready instead of sounding arbitrary.

## Trade-off Discipline

Explicitly consider the relevant items below when they matter:

- correctness and business semantics
- maintainability and readability
- performance and repeated work
- backward compatibility
- rollout and rollback safety
- operational visibility
- implementation complexity
- dependency risk

If a trade-off does not matter for the task, omit it instead of padding the plan.

## Layering Discipline

For list/search/reporting/performance/stateful flows, explicitly ask:

- Should this filter live in memory, service logic, repository/query layer, or database?
- Should this orchestration live in controller, business layer, worker, or integration boundary?
- Is the current plan pushing heavy work to the wrong layer?

Do not treat the first editable file as the right layer by default.

## Common Failure Modes To Avoid

- Starting with the proposed fix instead of the real problem.
- Treating a file inventory as a plan.
- Asking the user to resolve routine technical choices that repository evidence can answer.
- Picking a broader refactor when a smaller reversible change would work.
- Ignoring the rollout path for behavior changes.
- Skipping alternatives on a risky or hard-to-reverse decision.
- Calling a mitigation the final design.

## Expected Planning Output

For non-trivial planning, the response should make it easy to answer:

- What problem are we solving?
- What is in scope and out of scope?
- What options were considered?
- Why is this direction preferred?
- What are the main trade-offs?
- What exactly will change, and at which layer?
- How do we verify it?
- How do we roll it back or mitigate if needed?
- What decisions still need the user?

[RULE_TOKEN: SENIOR_PLANNING_RULE_V2_PROVED]

