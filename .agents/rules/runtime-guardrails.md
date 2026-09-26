# Runtime Guardrails

Use this file as the direct execution-time behavior layer.
It is especially important for weaker, cheaper, or low-memory models that may otherwise drift past the intended workflow.

## Required Workflow Declaration

Before substantive work, explicitly settle these fields:

1. `active_role`
2. `task_classification`
3. `artifact_decision`
4. `workflow_path`
5. `validation_plan`

For non-trivial work, also include:

- `rules_read` (the specific role/rule files actually read for this task)

Use a short operational block or table.
Do not continue until all required fields are concrete.

## Direct Behavior Gates

- **Rule Reading Gate:** Before planning, implementing, debugging, or reviewing non-trivial work, the agent MUST read the active role file and at least one relevant rule file using an available file-reading tool or equivalent repository-reading mechanism in the current runtime. Do not continue until that read has happened.
- **Rule Verification in Workflow:** For non-trivial work, the workflow declaration MUST name the specific rule files that were actually read.
- **Artifact Gate:** DO NOT downgrade a non-trivial, policy-bearing, multi-file, or project-memory-worthy task to `Internal only`.
- **Evidence Gate:** DO NOT present hypotheses as confirmed facts. If runtime or database evidence is unavailable, explicitly label the explanation as a code-based hypothesis or best-supported current cause.
- **Patch Completeness Gate:** NEVER leave placeholder code, unfinished markers, or fake completion notes such as `TODO`, `...`, or stub logic in repository edits unless the user explicitly asked for a placeholder.

## Small-Task Guard

Use `Internal only` only when all of the following are true:

- single-file or tightly bounded
- behaviorally local
- stable scope
- no unresolved domain, security, financial, operational, or user-visible decision
- no need for reusable project memory

If any item fails, strengthen the artifact decision.

## Evidence Guard

- Separate `Confirmed`, `Likely`, and `Unverified` when uncertainty exists.
- If runtime evidence is absent, say that plainly.
- Build success supports compile confidence only, not behavior confidence.

## Response Guard

- Put findings before summary for review work.
- Put the problem before the solution for planning work.
- Put what changed before broad conclusions for implementation work.
- If a required field or confidence boundary is missing, self-correct before finalizing.

## Optional Repo Validator

For stricter manual enforcement, validate a saved response with:

```bash
powershell -ExecutionPolicy Bypass -File scripts/validate-agent-workflow.ps1 path/to/response.md
```

This is a repository-side validator, not a replacement for host-level enforcement.
