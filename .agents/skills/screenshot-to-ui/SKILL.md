---
name: screenshot-to-ui
description: "Pixel-faithful UI reproduction from a reference image (screenshot, Figma export, mockup, sketch, or a live URL screenshot). Use when the user asks to 1:1 clone, copy, replicate, mimic, pixel-perfect, match, redraw, or reproduce a UI from an image, or says '照着做 / 一模一样 / 复刻 / 抄一下 / 还原这张图 / clone this / rebuild this page'. Runs a strict 5-stage pipeline: analyze → HTML plan → styled build → visual diff → iterate. Pairs with frontend-design (aesthetics) and design-motion-principles (motion), but this skill's job is fidelity to the reference, not creative reinterpretation."
---

# Screenshot-to-UI (1:1 Reproduction)

Reproduce a reference image as production-ready code with the highest visual fidelity you can achieve in a bounded number of iterations. Faithfulness beats creativity here — do not "improve" the reference unless the user asks you to.

## When this skill wins vs. frontend-design

- `frontend-design`: user wants a **new** distinctive UI. Aesthetic direction is open.
- `screenshot-to-ui` (this): user has a **specific reference image** and wants the output to look like it. Aesthetic direction is locked.

If the user shows a screenshot AND says "make it better / your take on it", load both skills; this one governs structure and tokens, `frontend-design` governs the deltas.

## Inputs you must confirm before coding

1. **Reference asset(s)**: absolute path(s) to image files, or a URL to screenshot. If more than one image, ask which is authoritative for what section (hero, footer, mobile, hover state, etc.).
2. **Target stack**: HTML+Tailwind (default for one-shot fidelity), React+Tailwind, Vue, plain CSS, or match an existing project.
3. **Scope**: single page, single component, or the whole flow.
4. **Fidelity budget**: how many iteration rounds acceptable (default 3).
5. **Responsiveness**: only if the reference doesn't dictate. Default = match the reference's viewport width, add mobile breakpoint at the end.

If any is missing and cheap to infer from the image (e.g. desktop screenshot 1440×900), infer and state the inference. Only ask when guessing wrong wastes a round.

## Stage 1 — Analyze the reference (image → tokens)

Read the reference image with your vision capability. Extract, in this exact order, and write them into a `DESIGN_TOKENS.md` scratchpad next to the target file:

1. **Layout skeleton** — describe as ASCII wireframe, one region per line. Identify: header/nav, hero, content grid, sidebar, footer, floating chrome. Note column count, gutters, alignment (left/center), and any grid-breaking element.
2. **Color palette** — 4-8 hex values with roles: `bg`, `surface`, `text`, `text-muted`, `accent`, `accent-alt`, `border`. Sample from the image, don't invent.
3. **Typography** — for every visible role (display / h1 / h2 / body / caption / button / mono): guess font family (or family class: geometric sans / grotesk / humanist serif / slab / monospace / display), weight, approximate size in px, line-height, letter-spacing feel (tight / normal / loose), case (sentence / title / UPPER).
4. **Spacing rhythm** — infer base unit (usually 4 or 8 px). List section vertical padding, card padding, gap between cards.
5. **Radii, borders, shadows** — corner radius per element class, border weight+color, shadow depth (none / subtle / soft / dramatic).
6. **Motion cues (if any)** — hover, load-in, scroll reveal. Skip if reference is static.
7. **Signature detail** — the ONE thing that makes this UI look like itself. Note it verbatim so you don't drop it in later stages.

## Stage 2 — HTML plan (structure before style)

Before writing any CSS or Tailwind class, sketch the HTML outline as a nested bullet list using semantic tags: `<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<aside>`, `<footer>`. Include ARIA where the reference implies interactive semantics (menu, tabs, dialog).

Do NOT write divs when a semantic tag fits. Do NOT nest deeper than needed. If the reference is a component (not a page), skip page-level tags and go straight to the component root.

## Stage 3 — Styled build (apply tokens)

- Use Tailwind CDN for HTML target, or the project's existing utility layer if editing an existing codebase.
- Colors → Tailwind arbitrary values `[#hex]` when the exact hex isn't in the palette. Do not "round to the nearest Tailwind gray".
- Fonts → load via Google Fonts `<link>` in HTML output; use the guessed family. If the reference clearly uses a paid font (e.g. Söhne, Neue Haas Grotesk), pick a free look-alike and note the substitution in `DESIGN_TOKENS.md`.
- Interactivity → hover states, focus rings, transitions ≤ 200ms unless the reference implies choreography.
- No `Inter`, no `Roboto`, no purple-on-white default unless the reference itself uses them.

## Stage 4 — Visual diff (mandatory)

Render the output and compare against the reference. Two options:

- **With a browser MCP / Playwright available**: screenshot the built page at the reference's exact viewport, put both images side-by-side, list every visible difference.
- **Without a browser**: describe the built page's expected rendering region by region, then re-inspect the reference and enumerate mismatches.

For every difference, categorize:
- `BLOCKER` — wrong layout, wrong section order, missing region → fix immediately.
- `MAJOR` — wrong color, wrong font family, wrong spacing rhythm → fix this pass.
- `MINOR` — off-by-4px padding, near-shade off by ≤5%, animation timing → fix if within fidelity budget, otherwise note and move on.

Emit the diff list as a short table, not prose.

## Stage 5 — Iterate

Apply BLOCKER + MAJOR fixes. Re-render. Diff again. Stop when:
- Zero BLOCKER and ≤3 MINOR remain, OR
- Fidelity budget hit — then hand back with the remaining MINORs listed so the user can decide.

Never silently "improve" the design during iteration. If you notice the reference has an accessibility problem (contrast, tiny tap targets), report it separately in the final summary — do NOT fix it without permission.

## Multi-screenshot / long-page workflow

If the reference is multiple images of one long page:
1. Name them `ref-01.png` … `ref-N.png` in scroll order.
2. Build one section at a time, from top down.
3. Only run Stage 4 diff on the section you just built + the last one above (checks continuity).
4. Final pass: full-page render + full stitched reference.

## Anti-patterns (do not do)

- Do not paraphrase the reference in words to yourself instead of extracting tokens. Words drift; hex values don't.
- Do not swap in "your favorite" fonts, palettes, or layouts.
- Do not skip Stage 2. Structure-before-style saves an entire iteration round every time.
- Do not claim "pixel-perfect" without a Stage 4 diff. Say "approximate" if you couldn't diff.
- Do not add features (dark mode, i18n, animations) the reference doesn't show.

## Output shape (final summary the user sees)

```
### Reproduced <target> from <reference>

Fidelity: <n>/5 rounds used, <n> BLOCKER fixed, <n> MAJOR fixed, <n> MINOR remaining.

Files:
- <path> — <what it is>

Design tokens (see DESIGN_TOKENS.md):
- palette: <5 hex>
- fonts: <display> / <body>
- signature: <the one memorable thing>

Remaining MINOR deltas:
- <delta> — <why unfixed>

Substitutions:
- <original font/asset> → <free replacement> (reason: <license/availability>)
```
