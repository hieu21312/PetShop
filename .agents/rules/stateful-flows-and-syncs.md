# Stateful Flows And Syncs

Use this rule for non-trivial tasks that touch any of the following:

- order, warehouse, shipment, or payment status transitions
- callback-driven state changes
- search indexing, reindexing, or stale document cleanup
- background sync, polling, worker, or daemon-updated state
- any path where FE, controller, service, worker, DB, and external integrations can all influence the visible result

For Sumix domain work, also consult:

- `docs/ai/rules/sumix-stateful-domain-map.md`
- `docs/ai/rules/sumix-golden-flows.md`

## Goal

Keep the agent from fixing only one branch of a stateful or multi-writer flow while leaving the real runtime path inconsistent.

## Core Model

Before proposing or implementing a fix, identify these layers explicitly:

1. user-visible symptom
2. source of truth for the affected field or document
3. full writer chain
4. reconciliation or aggregation layer
5. background or callback paths
6. stale-data risk
7. golden flow verification path

Do not collapse these into a single suspicious file.

## Owner Of Truth

For the affected field or behavior, state which layer should own the final decision:

- FE rendering only
- controller orchestration
- service or business logic
- repository or query layer
- worker or background process
- external callback or integration payload

If multiple layers currently write the same final state, call that out as a risk before concluding the fix is complete.

## Writer Chain Checklist

Before calling the task understood, check the relevant writers:

- direct request path
- shared helpers
- background services, workers, polling jobs, or daemons
- callback or webhook handlers
- bulk import, reindex, replay, or migration paths
- stale cleanup or delete paths
- FE-side synchronization or derived-state logic

For state, search, and payment bugs, do not stop after finding only one writer if another plausible writer remains uninspected.

## Stateful Flow Checklist

For order, shipment, warehouse, or payment flows:

- What is the parent entity?
- What are the child entities?
- Which transitions are legal?
- Which transitions are aggregate-only and should not be written manually in multiple places?
- Which transitions are triggered by payment, arrival, packaging, tracking, delivery, or completion?
- Which transitions require all children to satisfy a condition rather than any child?

If the task changes `status`, `subStatus`, or aggregate progression, check whether the same truth is also represented on item, package, group, order detail, order, invoice, or payment entities.

## Search And Sync Checklist

For search, Elasticsearch, caching, or sync bugs:

- Is the symptom in the index, in SQL, or only in FE presentation?
- Which path writes single-document updates?
- Which path writes bulk updates or full reindex?
- Which path deletes or cleans stale documents?
- Is there a daemon, cron, worker, or manual reindex path that can reintroduce old data?
- Is the exclusion or inclusion rule duplicated defensively at the last write boundary?

Do not conclude "not indexed" unless you have checked create, update, bulk, reindex, and cleanup behavior.

## Evidence Discipline

Separate these explicitly when the task is non-trivial:

- **Code evidence:** what repository code proves
- **Runtime evidence:** what logs, traces, request samples, database rows, or external payloads prove

If runtime evidence is missing, say so plainly and avoid presenting the explanation as fully proven.

## Golden Flows

For risky stateful or multi-writer tasks, define the narrowest relevant golden flow before implementation or final sign-off.

Examples:

- direct shipping: checkout -> approval -> arrival -> settle -> shortfall payment -> tracking -> delivered
- warehouse consolidation: arrival -> measurement -> user instruction -> combine -> settle -> payment -> tracking
- proxy product visibility: create -> cart visible -> search/index invisible
- callback path: payment approved -> callback received -> state updated -> stale state not reintroduced by later sync

The golden flow may be code-traced when full runtime reproduction is blocked, but the response must clearly label which parts are code-proven versus run-proven.

## Trace And Logging Expectations

When the task touches a runtime flow with multiple writers, prefer adding or relying on logs/traces that can answer:

- which actor changed the value
- old value -> new value
- entity ids involved
- request or callback correlation id
- whether the change came from request path, worker, or callback

If no such observability exists, call that out as recurrence risk.

## Completion Gate

Do not call the task complete if any of these remain unaddressed:

- a plausible uninspected writer remains
- the owner of truth is still ambiguous
- the fix only patches one ingress while bulk or replay paths remain inconsistent
- stale data in ES/cache/DB can still surface the old behavior
- the chosen golden flow was not checked at least by code path and expected state transitions

## Expected Output Additions

For tasks in this category, the final reasoning should make it easy to answer:

- what is the owner of truth?
- which writers were checked?
- what stale-data risks were considered?
- what golden flow was used?
- what is proven from code, and what still needs runtime confirmation?

[RULE_TOKEN: STF-44L0]
