# Backend Rules

Use this rule when the task changes controller, service, business logic, side-effect orchestration, async request-path behavior, or other backend execution-layer responsibilities.

- Keep business logic out of transport or controller glue where separation already exists.
- Prefer clear module boundaries such as routes/controllers/services/models when the stack supports them.
- Use explicit error handling for failure paths; do not silently swallow exceptions.
- Avoid blocking or expensive synchronous work in request paths when an asynchronous option exists.
- Keep secrets and environment-specific values out of source code.
- Make behavior easy to test by isolating side effects and external calls.

## Repo-Relevant Stack Notes

- **C# / .NET**: Keep controllers thin, preserve service-layer boundaries, and prefer explicit failure handling over silent fallbacks.
- **Node.js / TypeScript**: Prefer `async/await`, catch meaningful failure paths, and avoid blocking sync operations in request-serving code.
- **Python utilities**: Keep scripts explicit and side-effect aware, especially for sync, ETL, or operational tasks that touch shared data.

For detailed language-specific coding standards, consult:

- `.agents/rules/languages/csharp.md`
- `.agents/rules/languages/javascript.md`
- `.agents/rules/languages/nodejs.md`
- `.agents/rules/languages/python.md`
- `.agents/rules/languages/php.md`
- `.agents/rules/languages/ruby.md`
- `.agents/rules/languages/go.md`
- `.agents/rules/languages/cpp.md`
- `.agents/rules/languages/kotlin.md`
- `.agents/rules/languages/swift.md`

## Enterprise Architecture Boundaries
- **Layer Separation**: Keep transport/presentation concerns separate from business logic and data access where the repo already has that boundary.
- **Model Isolation**: Avoid leaking persistence models directly into presentation APIs when an explicit DTO or view model boundary already exists.
- **Dependency Injection**: Follow the repo's established dependency-injection and composition patterns instead of manually instantiating long-lived collaborators in consumers.
