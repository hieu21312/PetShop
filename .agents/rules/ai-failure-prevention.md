# AI Failure Prevention

Use this rule file to prevent common AI-generated code failures that are not always caught by syntax or build validation alone.

## 1. Core Principle

Treat AI output as a fast draft, not as trusted truth.

The goal is not to make AI "never wrong". The goal is to make wrong output easy to catch before it damages code health, runtime behavior, security, or maintainability.

## 2. Common AI Failure Modes

- Hallucinated package, API, config key, field, flag, method, or framework behavior
- Business-semantic drift: code matches the surface request but violates the real domain meaning
- Incomplete wiring across controller, service, repository, DTO, validation, tests, config, or caller paths
- Missing corner cases such as null, empty, mixed-state, pagination, or invalid-transition behavior
- Repeated work in heavy paths: N+1 queries, repeated fetches, repeated parsing/serialization, or loading too much data before filtering/paging
- Overconfident claims: calling a guess a root cause, or calling a change optimized without evidence

## 3. High-Risk Zones

Use stronger skepticism and stronger validation in:

- auth, permission, roles, ownership checks
- payment, billing, refunds, pricing, points
- destructive actions, bulk updates, file deletion, data migration
- external integrations, webhooks, callbacks, token handling
- list/search/reporting/export APIs with potentially large datasets
- dependency changes, package installation, toolchain additions

In these zones, avoid implementation-first unless the workflow explicitly allows it. Prefer planner or debugger first when the task is non-trivial.

## 4. Dependency Verification

Before trusting AI-suggested dependencies, verify:

- the package/tool actually exists
- the name is exact
- the API/CLI usage matches the real package/tool
- the version and installation path make sense in this repo
- the dependency is truly necessary

Do not accept a new dependency just because the model produced a plausible name.

## 5. Heavy Path Review

For list/search/reporting and other data-heavy paths, explicitly ask:

- Is this filtering happening in the right layer?
- Are we loading full datasets before filtering, grouping, or paging?
- Is there any N+1 query or repeated fetch pattern?
- Are we repeating parsing, serialization, or computation inside loops?
- Is the path likely to time out or scale poorly with production-sized data?

Prefer the smallest change that moves expensive work to the correct execution layer when repository evidence supports it.

## 6. Validation Expectations

- Build success is necessary but not sufficient.
- Functional claims need behavior validation.
- Performance claims need proportional evidence such as:
  - query-count reduction
  - execution-path simplification
  - timing comparison
  - profiling, metrics, or logs
- Security-sensitive changes need explicit review of trust boundaries and input/output handling.

## 7. Review Questions

Before treating AI-generated code as acceptable, ask:

1. What exact business rule does this code implement?
2. What evidence shows the used API/package/config is real and correct?
3. What layer should own this filtering, validation, or aggregation?
4. What path is hottest or largest under real data?
5. What corner case is easiest to miss here?
6. What part of the change is still unverified?

## 8. Escalation Rule

If the change touches a high-risk zone and the evidence is weak, stop and strengthen the workflow before continuing:

- update the repo spec
- switch to planner or debugger if needed
- request the strongest missing validation instead of guessing
