# Verification and Confidence Rules

This file defines how governance v2 should control verification quality and confidence claims.

## Verification Strength

- Build-only validation is enough only for syntax, compile, or wiring claims.
- Behavior claims require behavior evidence.
- State-transition claims require state evidence.
- Query/search/count mismatch claims require query-path evidence.
- Distributed correctness claims require overlap/idempotency/retry evidence.

## Confidence Labels

Every non-trivial result should classify statements as:

- `Confirmed`
  directly supported by code, runtime evidence, tests, traces, logs, query plans, or exact reproduction
- `Likely`
  best-supported current explanation with some evidence but still missing proof
- `Unverified`
  plausible but not yet supported enough for decision-grade confidence

## Missing Proof Rule

If the main conclusion is not `Confirmed`, the response must state:

- the strongest missing proof
- the single next check most likely to confirm or falsify the leading explanation

## Anti-Overclaim Rule

Do not call something a root cause unless it is `Confirmed`.
Until then, use:

- `leading hypothesis`
- `candidate cause`
- `best-supported current cause`

## Mitigation Transparency Rule

If a patch changes semantics mainly to keep the system usable before the root cause is proven, label it `mitigation` and state:

- what precision/correctness is reduced
- what risk remains
- what proof is still missing for the true fix
