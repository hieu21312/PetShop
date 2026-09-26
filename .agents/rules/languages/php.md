# PHP Standards

- Follow PSR-style structure and formatting when the surrounding codebase does not define a different local convention.
- Use `PascalCase` for classes, `camelCase` for methods, and `$camelCase` for variables.
- Keep file structure predictable and avoid mixing controller, business, and persistence logic in one place.
- Prefer explicit validation and explicit failure handling over silent coercion.
- Use DocBlocks where the codebase expects them for public or framework-facing APIs.
