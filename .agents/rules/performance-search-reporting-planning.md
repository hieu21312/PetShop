# Performance, Search, And Reporting Planning

Use this rule when planning non-trivial tasks that affect performance, search behavior, list endpoints, reporting flows, large data scans, filtering, aggregation, sorting, pagination, exports, dashboards, or other data-heavy paths.

## Goal

Produce plans that do not accidentally choose the wrong layer, underestimate data cost, or approve weak verification for heavy-path changes.

## Core Planning Questions

Before proposing a direction, answer the relevant questions below:

- What is the exact path being changed: list API, search flow, dashboard query, export job, report screen, background aggregation, or mixed path?
- Where is the heavy work happening now: controller, service, repository/query layer, database, cache, worker, or integration boundary?
- What is the likely data shape: row count, item count, page size, fan-out, joins, repeated lookups, or downstream enrichment?
- Which parts are proven from code, and which parts still need runtime evidence?
- Is the proposal a real fix to the heavy path, or only a mitigation that reduces visible pain?

## Layering Discipline

For these tasks, do not treat the first editable file as the right solution layer.

Explicitly ask:

- Should filtering stay in memory, or move to repository/query/database level?
- Should aggregation happen in controller code, business logic, a worker, precomputed storage, or query layer?
- Should sorting and pagination happen before or after enrichment?
- Is the plan pulling a broad dataset and trimming it later?
- Is a shared helper or DTO enrichment step causing hidden repeated work after the main query?

Prefer plans that remove unnecessary work earlier in the path when repository evidence supports it.

## Heavy-Path Risks To Check

The plan should explicitly check for the relevant risks below:

- N+1 query patterns
- repeated fetches of the same entity or lookup table
- repeated parsing, serialization, or mapping
- broad in-memory filtering before paging
- broad in-memory sorting before reduction
- full dataset loading for a paged endpoint
- hidden fan-out through downstream enrichment
- duplicate aggregation across layers
- query or response shapes that defeat caching or indexing assumptions

## Option Framing For Heavy Paths

If the task is design-bearing or risky, compare options such as:

- in-memory filtering versus pushing predicates down
- synchronous request-time computation versus worker/precompute path
- controller orchestration versus service/query-layer ownership
- ad-hoc enrichment versus batched lookup or projection
- immediate mitigation versus deeper structural fix

Do not recommend the heavier path unless the trade-off is explicit and justified.

## Verification Expectations

A good plan should name the strongest practical validation for the claim. Relevant signals can include:

- exact request reproduction
- query count reduction
- execution-path simplification
- before/after timing
- payload size comparison
- SQL/query text or plan evidence
- logs, traces, metrics, or profiling
- page correctness after filtering/sorting/pagination changes

Do not rely on build-only validation for performance, search relevance, paging correctness, or reporting accuracy claims.

## Mitigation vs Full Fix

Label the proposal clearly when it is mainly one of the following:

- **Mitigation:** caps the impact, narrows data, adds timeout protection, limits payload, or avoids the worst-case path without removing the underlying inefficiency.
- **Full fix:** addresses the heavy-path mechanism itself strongly enough for the available evidence.

If runtime proof is still missing, keep the wording honest.

## Rollback And Operational Safety

Plans in this category should consider:

- rollback path if result correctness or performance regresses
- blast radius across shared list/search/reporting consumers
- whether an index, cache, worker, or query rewrite introduces stale-data or invalidation concerns
- whether monitoring, logs, or metrics need strengthening to verify the change after rollout

## Common Planning Failures To Avoid

- treating a timeout symptom as proof of one exact root cause
- approving a plan that still loads all rows before filtering or paging
- moving logic to a layer that makes correctness or rollout harder
- assuming a cache or index is the answer before proving the access pattern
- planning only for latency while ignoring result correctness
- treating a mitigation as the final architecture

## Expected Output Additions

For performance/search/reporting plans, the response should make it easy to answer:

- Where is the heavy work now?
- Which layer should own the fix?
- What repeated work is the plan trying to remove?
- How will correctness of paging, filtering, sorting, or aggregation be preserved?
- What is the strongest validation signal?
- Is this a mitigation or a full fix?
