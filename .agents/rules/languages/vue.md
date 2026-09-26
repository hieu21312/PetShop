# Vue Standards

- Use `PascalCase` for component filenames and component definitions.
- Use `kebab-case` when rendering components in templates if that matches the project style.
- Keep component files focused; split overly long files into smaller pieces by responsibility.
- Keep heavy logic out of templates; move it into computed properties, composables, or methods when that improves readability.
- Use clear component communication patterns such as props and emits instead of tightly coupling parent and child internals.
- Keep script sections ordered consistently when the repo already uses a preferred structure.
