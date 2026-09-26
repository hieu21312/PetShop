# Frontend Rules

Use this rule when the task changes components, screens, forms, tables, layout, responsive behavior, accessibility, UI states, or client-side interaction flow.

- Keep components and UI modules small and single-purpose.
- Prefer clear naming: components in PascalCase, variables and handlers in camelCase.
- Keep rendering logic simple; move heavy logic out of templates or JSX when it hurts readability.
- Use explicit validation and visible error states for forms.
- Maintain clear visual hierarchy in screens, forms, and tables.
- Support responsive layouts for desktop and mobile when frontend work exists.
- Preserve accessibility basics: labels, alt text, keyboard access, and semantic structure.
- For data tables, prefer readable alignment, clear headers, overflow handling, and pagination for large datasets.
- Do not add decorative UI complexity that reduces clarity.
- For advanced visual design guidelines, landing pages, and anti-slop checks, see `.agents/rules/taste-skill.md`.

## Repo-Relevant Stack Notes

- **React / Next.js**: Prefer functional components, keep side effects out of render paths, and follow the repo's existing component and feature organization patterns.
- **Frontend behavior**: Keep loading, error, empty, and success states explicit when they affect user understanding.
- **Performance and accessibility**: Treat them as practical constraints during implementation, especially for lists, forms, navigation, and interactive elements, rather than as a separate design manifesto here.

For detailed framework and UI standards, consult:

- `.agents/rules/languages/react.md`
- `.agents/rules/languages/javascript.md`
- `.agents/rules/languages/vue.md`
- `.agents/rules/ui-ux.md`

## Scope Notes

- Keep this file focused on component structure, UI behavior, responsiveness, and accessibility basics that help agents ship safe frontend changes.
- Avoid turning this file into a full visual design system or a generic framework style guide.
- Put advanced visual direction, brand/taste decisions, and anti-slop design rules in `.agents/rules/taste-skill.md`.
