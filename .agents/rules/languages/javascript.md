# JavaScript Standards

- Prefer `const` and `let`; do not use `var`.
- Use `camelCase` for variables and functions, and `PascalCase` for classes.
- Use `===` and `!==` instead of loose equality.
- Use curly braces for all control-flow blocks, even when they contain one line.
- Prefer concise arrow functions where they improve clarity, but do not force them into already established code that reads better otherwise.
- Keep browser-side logic clear and avoid hiding important state transitions inside chained expressions.
- Do not leave silent promise failures; use `try/catch` or `.catch()` intentionally.
