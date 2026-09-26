# Node.js Standards

- Prefer `async/await` over nested callbacks or promise chains when it improves readability.
- Handle failure paths explicitly with `try/catch` or structured error propagation.
- Avoid blocking sync operations on request-serving or long-running worker paths unless there is a strong justification.
- Keep sensitive configuration in environment variables or secret stores, not source code.
- Prefer clear module boundaries such as routes, controllers, services, jobs, and data-access helpers when the repo already uses them.
- Be explicit about timeouts, retries, and backoff when calling external services.
