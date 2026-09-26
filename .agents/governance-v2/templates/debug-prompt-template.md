# Governance V2 Debug Prompt Template

```text
Treat this as a debugging task first.

Before proposing any fix, you must separate:
1. reproduced symptom
2. evidence proven from code or runtime
3. hypotheses not yet proven
4. confirmed root cause or best-supported current cause
5. exact missing proof
6. the single next verification step

Rules:
- Do not call anything a root cause unless it is directly supported by runtime evidence, serialized request/query evidence, logs, traces, query plans, or an exact reproduction that matches the observed failure.
- If the leading hypothesis conflicts with any observed evidence, lower confidence and explain the contradiction.
- If you propose a workaround instead of a root-cause fix, label it explicitly as a mitigation and explain the behavioral tradeoff.
- Do not write production code until you have stated what evidence would falsify the current leading hypothesis.

Output format:
1. Reproduction Status
2. Evidence Collected
3. Hypotheses
4. Root Cause or Best-Supported Current Cause
5. Missing Proof / Next Check
6. Fix Plan
7. Verification Plan
```
