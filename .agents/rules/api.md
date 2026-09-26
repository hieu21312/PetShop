# API Rules

Use this rule when the task changes request/response contracts, validation, status codes, API error behavior, or other transport-boundary semantics.

- Keep request and response contracts explicit.
- Validate required inputs early and return clear error messages for invalid requests.
- Preserve backward compatibility unless the task explicitly allows a breaking change.
- Keep field naming, status handling, and error shape consistent within the same API surface.
- Document or reflect any contract changes in the task spec or acceptance criteria.

## Scope Notes

- Prefer existing response and error conventions used by the target API surface instead of inventing a new global format inside a local task.
- Keep transport-boundary concerns here: contracts, validation, status codes, and client-visible error behavior.
- Handle logging, sensitive-data masking, and broader security policy in the appropriate shared or security-focused guidance instead of redefining them here.
