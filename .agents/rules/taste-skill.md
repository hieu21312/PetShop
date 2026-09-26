# Taste Skill: Anti-Slop Frontend Rules

This rule module prevents the generation of generic, boring, and templated-looking AI frontends. Apply these rules during any frontend UI/UX design, landing page creation, or redesign tasks.
Use this file only when the task explicitly needs stronger visual direction than `frontend.md` and `ui-ux.md`. This is a specialized aesthetic module, not the primary source of repo-wide workflow or frontend safety policy.

## 0. BRIEF INFERENCE
Before generating code, state in one line:
**"Reading this as: <page kind> for <audience>, with a <vibe> language, leaning toward <design system or aesthetic family>."**
*   **Anti-Default Discipline**: Do not default to AI-purple gradients, centered heroes over dark mesh, generic glassmorphism, or Inter + slate-900.

## 1. THE THREE DIALS
Establish these three dials based on the design brief:
*   **`DESIGN_VARIANCE`** (1 = Symmetry, 10 = Artsy Chaos) - *Default: 7-8*
*   **`MOTION_INTENSITY`** (1 = Static, 10 = Cinematic/Physics) - *Default: 6*
*   **`VISUAL_DENSITY`** (1 = Art Gallery/Airy, 10 = Cockpit/Dense) - *Default: 4*

## 2. DESIGN ENGINEERING DIRECTIVES

### 2.1 Typography
*   **Headline/Display**: Default `text-4xl md:text-6xl tracking-tighter leading-none`.
*   **Serif Discipline**: Do not default to serif fonts (especially `Fraunces` or `Instrument Serif`) unless explicitly requested or matching a heritage/vintage aesthetic. For modern/premium consumer brands, default to sans-serif display (e.g., `Geist Display`, `Cabinet Grotesk`, `Satoshi`).
*   **Italic Descenders**: Ensure italic words in headlines do not clip descenders (`y g j p q`). Use `leading-[1.1]` minimum and add margin/padding clearance.

### 2.2 Color Calibration
*   **The Lila Rule**: Avoid the default "AI purple glow" gradients or button shadows. Use neutral bases (Zinc/Slate/Stone) with a single saturated accent.
*   **Color Lock**: Stick to a single accent palette for the whole page. Do not mix warm and cool grays.
*   **Premium-Consumer Palette**: Do not default to the classic "warm beige + brass/oxblood/ochre + espresso text" for DTC/wellness brands. Instead, rotate: Chrome/Smoke, Forest Green + Amber, pure monochrome + single vivid pop.

### 2.3 Layout & Structural Discipline (Hard Rules)
*   **Hero Viewport Fit**: Hero headlines (max 2 lines) and subtext (max 20 words) must fit within the initial viewport. CTAs must be visible without scrolling.
*   **Hero Padding**: Hero top padding must not exceed `pt-24` (≈6rem) on desktop.
*   **Hero Stack**: Maximum 4 elements (Eyebrow or Brand strip, Headline, Subtext, CTAs). Move logos, pricing, and feature bullets below the hero.
*   **Desktop Nav**: Navigation must fit on a single line on desktop. Height cap: 64-80px.
*   **Bento Grid Rythm**: Bento grids must have asymmetric layout. Blank/empty cells are prohibited. At least 2-3 cells must have visual variety (real images, patterns, gradients, or tinted backgrounds).
*   **Layout Repetition**: A single layout style (e.g. 3-column cards) can only appear once on a page. Avoid repeating the same pattern consecutively.
*   **Eyebrow Restraint**: Maximum 1 small caps uppercase eyebrow label per 3 sections.
*   **Split-Header Ban**: Do not use the "left big H2 + right explainer paragraph" pattern by default. Stack them vertically instead.

### 2.4 Interactive UI States
*   **Loading**: Use matching skeletal loaders instead of circular spinners.
*   **Button/Form Contrast**: Verify WCAG AA contrast (4.5:1) for all CTAs and input placeholders.
*   **Tactile Action**: On `:active`, use `-translate-y-[1px]` or `scale-[0.98]` to simulate a physical button push.
*   **CTA wrapped text**: Button text must fit on a single line on desktop. No duplicate CTAs with the same intent.

### 2.5 Visual Asset Strategy
*   **Real Visuals**: A hero needs a real visual asset. Text + gradient blob is not a hero.
*   **Logos**: Use official SVG logos (e.g. Simple Icons) for logo walls. Do not print category labels below logos.
*   **Banned**: Div-based "fake screenshots" (fake dashboards, terminal windows) are prohibited. Use real component previews or actual photography.

## 3. PRE-FLIGHT AUDIT
Prior to delivery, verify:
1. No wrapped desktop CTA buttons.
2. Max 1 eyebrow label per 3 sections.
3. No consecutive split-zigzag alternating rows beyond 2 sections.
4. Clean spelling, coherent copy voice, and no AI-hallucinated copywriting.
