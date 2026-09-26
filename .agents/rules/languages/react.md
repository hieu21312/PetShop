# React Standards

- Prefer functional components and hooks.
- Keep render paths free of side effects and network-triggering behavior.
- Use `PascalCase` for component names and `camelCase` for handlers and local state.
- Split presentation and stateful orchestration when a component becomes hard to reason about.
- Keep JSX readable; move complex transformations or branching out of render when clarity suffers.
- Use explicit loading, error, empty, and success states when they affect user understanding.
- Follow the repo's existing routing, feature organization, and state-management patterns before introducing new ones.
