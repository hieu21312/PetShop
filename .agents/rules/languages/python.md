# Python Standards

- Follow PEP 8 unless the surrounding codebase has an established exception.
- Use 4 spaces for indentation; do not use tabs.
- Prefer `snake_case` for variables and functions, `PascalCase` for classes, and `ALL_CAPS` for constants.
- Keep imports grouped as: standard library, third-party, then local modules.
- Keep functions focused and side effects explicit, especially in crawler, ETL, and operational scripts.
- Avoid broad bare `except:` handlers; catch meaningful exceptions and preserve traceback quality.
- Prefer clear loops and explicit branching over dense one-liners when the code affects parsing, retries, or stateful flows.
