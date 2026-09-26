# Senior Debugging

Use this rule for non-trivial debugging, performance investigation, incident analysis, and failure-mechanism tracing.

## Goal

Debug like a senior engineer: prove the symptom, map the real execution path, separate evidence from inference, and fix the smallest mechanism that prevents recurrence.

## Core Model

Always separate these layers:

1. Observed symptom
2. Evidence collected
3. Contributing factors
4. Root cause or best-supported current cause
5. Missing proof
6. Mitigation or containment
7. Full fix
8. Recurrence prevention

Do not collapse these layers into one explanation.

## Senior Debug Checklist

Before calling a debug task complete, check the relevant items below:

- **Symptom Precision:** Can you state the exact failure, affected path, trigger, and visible impact without mixing in theory?
- **Execution Path:** Did you trace the real path through the relevant controller/service/query/worker/integration flow before naming a fix?
- **Evidence Chain:** What is the strongest evidence available right now: reproduction, serialized request, logs, traces, query evidence, metrics, profiling, or code?
- **Source Strength:** If only code inspection is available, are you clearly labeling runtime claims as hypotheses or best-supported current cause?
- **Causal Separation:** Did you separate symptom, trigger, contributing factors, and failure mechanism instead of naming the first suspicious line as the answer?
- **Counterfactual Check:** If the suspected factor were removed, would the symptom still plausibly happen elsewhere in the path?
- **Layer Check:** Are you fixing the correct layer, or only patching a downstream symptom while the upstream mechanism remains?
- **Mitigation Labeling:** If the proposed change mainly reduces user pain or buys time, have you labeled it as a mitigation instead of a full fix?
- **Blast Radius:** Did you check who else uses the same path, data shape, shared helper, or integration behavior?
- **Recurrence Prevention:** What should be added or strengthened so the same class of issue is detected earlier next time: test, logging, metric, alert, invariant, or guardrail?

## Evidence Discipline

- Prefer stronger runtime evidence over weaker static suspicion when it is practical to obtain.
- Good evidence can include:
  - an exact reproduction
  - request and response samples
  - logs and traces
  - query text or query plan evidence
  - metrics, timings, or profiling
  - code that exactly matches the observed behavior
- Weak evidence should stay labeled as weak:
  - a suspicious loop
  - a plausible query problem without runtime confirmation
  - a guessed cache issue
  - a guessed DB load issue
  - a guessed network issue

## Fix Framing

- Use **mitigation** when the change reduces impact without proving the underlying mechanism is removed.
- Use **full fix** only when the failure mechanism itself is addressed strongly enough for the available evidence.
- If you cannot prove the fix end to end, state the remaining uncertainty plainly.

## Common Failure Modes To Avoid

- Anchoring on the first obvious suspect.
- Treating one layer's suspicion as the whole-task explanation.
- Calling a build pass, code diff, or superficial happy-path check a proof of runtime resolution.
- Treating performance assumptions as root cause without timings, query evidence, or a matching execution path.
- Confusing a data-shape bug with an infrastructure bug before the serialized request and response are known.
- Quietly changing semantics to make the error disappear.

## Expected Debug Output

For non-trivial debugging, the response should make it easy to answer:

- What exactly happened?
- What is proven?
- What is still inferred?
- What is the strongest missing proof?
- Is the proposed change a mitigation or a full fix?
- How do we verify it?
- What prevents recurrence?
