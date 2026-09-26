# Database Rules

Use this rule when the task changes schema, persistence behavior, write paths, migrations, queries, rollback risk, or storage-safety assumptions.

- Treat existing data as the source of truth unless a migration explicitly changes it.
- Make schema or persistence changes only when required by the task.
- Protect existing data during failure paths: prefer safe rollback behavior over partial writes.
- Consider storage limits, cleanup behavior, and recovery paths when tasks affect persistence or file storage.
- Do not assume elevated database privileges or production-only settings in local guidance.

## Scope Notes

- Keep this file focused on schema, persistence behavior, data safety, and migration risk.
- Treat backup policy, infrastructure topology, and hardware recommendations as operational guidance unless a task is explicitly about those areas.
- When changing queries, migrations, or write paths, prefer guidance that helps agents reason about correctness, rollback, and compatibility over environment-specific operations advice.
