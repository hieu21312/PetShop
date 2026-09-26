# C# Standards

- Use `PascalCase` for classes, methods, properties, and public members.
- Use `camelCase` for local variables and parameters.
- Use braces for all control-flow blocks.
- Prefer explicit service-layer and DTO boundaries over leaking persistence models through controllers.
- Avoid sync-over-async in web/API request paths.
- Preserve stack traces with `throw;` instead of `throw ex;`.
- Keep class members ordered consistently when the surrounding codebase has an established convention.
- Prefer expressive names over abbreviations, especially in business logic and orchestration code.
