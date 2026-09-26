# Security Rules

Use this rule when the task touches auth, authorization, untrusted input, uploads, secrets, token handling, ownership checks, or any other trust boundary.

- Do not place secrets, tokens, passwords, or private keys in the repository.
- Validate untrusted input at system boundaries.
- Consider common web risks such as injection, cross-site scripting, unsafe file handling, and session misuse when relevant.
- Prefer least-privilege defaults for credentials, data access, and operational actions.
- When a task touches authentication, authorization, storage, or uploads, review failure handling as well as success paths.

## Scope Notes

- Keep this file focused on security-relevant coding and review behavior that an agent can directly apply during repository work.
- Treat org-wide offboarding, firewall policy, password rotation, and infrastructure administration as operational policy unless a task explicitly covers them.
- When security guidance becomes highly stack-specific, prefer the relevant stack module plus this file's cross-cutting guardrails rather than duplicating the same policy in many places.
