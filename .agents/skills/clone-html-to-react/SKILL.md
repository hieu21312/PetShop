---

name: clone-html-to-react-tailwind-pixel-perfect
description: Convert a large static HTML mockup into React components using Tailwind CSS with strict CSS discovery, exact style mapping, and no guessed styling.
----------------------------------------------------------------------------------------------------------------------------------------------------------------

# Clone HTML to React Tailwind Pixel Perfect Skill

Use this skill when converting a static HTML mockup into a React application using Tailwind CSS.

The goal is to preserve the original UI as closely as possible:

* same colors
* same font sizes
* same font weights
* same line heights
* same spacing
* same layout
* same grid/flex behavior
* same border radius
* same shadows
* same responsive breakpoints
* same hover/focus/active states
* same table/form/button styling

## Critical Rule

Never guess Tailwind classes from class names.

Do not convert:

```html
<div class="product-list-title">
```

into:

```tsx
<div className="text-lg font-bold">
```

unless the original CSS actually defines that size and weight.

You must first find the real CSS for `.product-list-title`, including inherited/global/parent rules, then convert those exact values into Tailwind.

## Mandatory Workflow

### Phase 1 — Read target React architecture

Before editing files, inspect the React project:

* package.json
* tailwind.config.js or tailwind.config.ts
* index.css
* App.css
* main layout files
* existing routing
* existing theme files
* existing component style conventions

Confirm:

* Tailwind is installed
* arbitrary values are supported
* arbitrary variants are supported
* custom screens can be added if needed
* existing global CSS will not override the clone

Do not write React code before this check.

### Phase 2 — Extract CSS from the HTML mockup

Open the original HTML file.

Find and extract:

* the complete `<style>` block
* all `:root` variables
* all global selectors such as `body`, `button`, `table`, `th`, `td`, `aside`, `main`
* all class selectors
* all ID selectors
* all pseudo selectors such as `:hover`, `::after`, `:checked`
* all media queries
* all repeated selectors where later CSS overrides earlier CSS

Important: CSS order matters. If the same variable or selector is defined twice, the later definition wins.

### Phase 3 — Extract classes from the HTML

Find every class used in the HTML.

For each HTML class, create a CSS mapping table before writing React.

Required table format:

```md
| HTML class | CSS source | Effective CSS | Tailwind conversion | Notes |
|---|---|---|---|---|
| layout | .layout + body.nav-collapsed .layout + media queries | display:grid; grid-template-columns:250px 1fr; min-height:100vh; transition:grid-template-columns .18s ease; | grid grid-cols-[250px_1fr] min-h-screen transition-[grid-template-columns] duration-[180ms] ease-[ease] | add collapsed state |
```

If the mapping table is not complete for the component being converted, stop and complete the mapping first.

### Phase 4 — Resolve CSS cascade and specificity

For each element, collect styles from all applicable selectors:

* tag selector: `button`, `table`, `th`, `td`
* class selector: `.tab`, `.panel`, `.section`
* combined selector: `.tab.active`, `button.secondary`
* parent selector: `.message-thread-card summary`
* state selector: `:hover`, `:disabled`, `[open]`
* media query selector
* later override rules

Example:

For:

```html
<button class="secondary">
```

You must check:

```css
button, .item-link { ... }
button.secondary { ... }
button:disabled { ... }
button.secondary:hover { ... }
```

Then convert the final effective styling.

Never only map `.secondary`.

### Phase 5 — Convert CSS to Tailwind exact values

Use Tailwind arbitrary values when the value does not exactly match a default Tailwind token.

Bad:

```tsx
className="p-4 text-sm rounded-lg shadow-lg"
```

Good:

```tsx
className="p-[18px] text-[13px] rounded-[8px] shadow-[0_12px_32px_rgba(0,0,0,.24)]"
```

Use exact mappings:

```css
padding: 18px 10px;
```

```tsx
className="py-[18px] px-[10px]"
```

```css
font-size: 10.5px;
line-height: 1.35;
font-weight: 750;
```

```tsx
className="text-[10.5px] leading-[1.35] font-[750]"
```

```css
grid-template-columns: 250px 1fr;
```

```tsx
className="grid grid-cols-[250px_1fr]"
```

```css
background: linear-gradient(180deg, #f8fbff 0, #f5f8fc 260px);
```

```tsx
className="bg-[linear-gradient(180deg,#f8fbff_0,#f5f8fc_260px)]"
```

```css
box-shadow: 1px 0 0 rgba(15, 35, 65, .05);
```

```tsx
className="shadow-[1px_0_0_rgba(15,35,65,.05)]"
```

### Phase 6 — Preserve CSS variables

If the HTML uses CSS variables like:

```css
:root {
  --bg: #f5f8fc;
  --panel: #ffffff;
  --line: #d7e2ee;
  --text: #172033;
}
```

Prefer adding them to `tailwind.config.js`:

```js
theme: {
  extend: {
    colors: {
      sumixBg: '#f5f8fc',
      sumixPanel: '#ffffff',
      sumixLine: '#d7e2ee',
      sumixText: '#172033',
      sumixMuted: '#66758a',
      sumixCyan: '#0ea5c6',
      sumixBlue: '#2563eb',
      sumixGreen: '#16a36a',
      sumixAmber: '#d99013',
      sumixRed: '#e54865',
      sumixPurple: '#7c5ce8',
    },
  },
}
```

Then use those colors consistently:

```tsx
className="bg-sumixBg text-sumixText border-sumixLine"
```

If exact one-off color appears only once, use arbitrary value:

```tsx
className="bg-[#f8fbff]"
```

### Phase 7 — Preserve responsive breakpoints exactly

Do not replace custom media queries with default Tailwind breakpoints unless they match exactly.

If original CSS has:

```css
@media (max-width: 1180px) { ... }
@media (max-width: 760px) { ... }
```

Then either use arbitrary media variants:

```tsx
className="grid grid-cols-[250px_1fr] [@media(max-width:1180px)]:grid-cols-[220px_minmax(0,1fr)] [@media(max-width:760px)]:grid-cols-[190px_minmax(0,1fr)]"
```

Or extend Tailwind screens:

```js
theme: {
  extend: {
    screens: {
      'max-1180': { max: '1180px' },
      'max-980': { max: '980px' },
      'max-880': { max: '880px' },
      'max-760': { max: '760px' },
    },
  },
}
```

Then use:

```tsx
className="grid grid-cols-[250px_1fr] max-1180:grid-cols-[220px_minmax(0,1fr)] max-760:grid-cols-[190px_minmax(0,1fr)]"
```

### Phase 8 — Preserve global element styles

If original CSS styles global elements like:

```css
button, .item-link { ... }
table { ... }
th, td { ... }
body { ... }
main { ... }
aside { ... }
```

Do not ignore them.

Either:

1. Convert every matching element to Tailwind manually, or
2. Create reusable React components:

```tsx
<AdminButton variant="secondary" />
<AdminTable />
<AdminPanel />
<AdminBadge />
```

Each reusable component must contain exact Tailwind classes converted from the original CSS.

Do not rely on browser defaults.

### Phase 9 — Handle combined selectors and states

Convert combined selectors exactly.

Example:

```css
.nav-item.active {
  background: #123d8c;
  color: #ffffff;
}
```

React:

```tsx
<div className={isActive ? "bg-[#123d8c] text-[#ffffff]" : "text-[#334155]"}>
```

Example:

```css
.nav-toggle:hover {
  background: #dbe8f7;
}
```

Tailwind:

```tsx
className="hover:bg-[#dbe8f7]"
```

Example:

```css
.control-collapse summary::after {
  content: "Hiển thị";
}
.control-collapse[open] summary::after {
  content: "Ẩn";
}
```

Use React-rendered content instead of relying on pseudo content when easier:

```tsx
<span>{open ? "Ẩn" : "Hiển thị"}</span>
```

### Phase 10 — Do not leave mockup classes

Do not leave classes like:

```tsx
className="panel section nav-item active"
```

unless those classes already exist in the React app CSS.

Since the target is Tailwind, convert them to Tailwind:

```tsx
className="border border-[#d7e2ee] rounded-[8px] bg-[#ffffff] p-[14px] mb-[18px]"
```

### Phase 11 — Use component extraction only after visual parity

First create a static React clone.

After it matches visually, then refactor into components.

Recommended extraction order:

1. Layout
2. Sidebar
3. Header
4. Tabs
5. Panels
6. Tables
7. Cards
8. Forms
9. Buttons
10. Badges
11. Modals
12. Page-specific content

Do not refactor before the static visual clone is correct.

### Phase 12 — Required command-line CSS discovery

When tools are available, use search commands before coding.

Use commands like:

```bash
rg "class=\"|className=\"" path/to/mockup.html
rg "\\.product-list-title|\\.panel|button|table|@media|:root" path/to/mockup.html
rg "product-list-title" path/to/mockup.html
```

For each class used by the current component, search its CSS rule.

If using PowerShell:

```powershell
Select-String -Path .\mockup.html -Pattern "\.product-list-title|\.panel|button|table|@media|:root" -Context 3,8
```

Do not proceed if you have not searched the CSS definition.

### Phase 13 — Required mapping before code

Before writing the React component, output a short mapping for the classes being converted:

```md
## CSS Mapping Before Conversion

| Element | Original selectors checked | Tailwind result |
|---|---|---|
| button.secondary | button, button.secondary, button:disabled | min-h-[34px] rounded-[6px] px-[12px] text-[12px] font-[850] bg-[#e9f1fb] text-[#173252] border border-[#cad8ea] |
| layout | .layout, body.nav-collapsed .layout, media max 1180, media max 760 | grid min-h-screen grid-cols-[250px_1fr] ... |
```

This table is mandatory.

### Phase 14 — Verification

After conversion:

* run the React app
* open the original HTML in browser
* open the React page in browser
* compare same viewport width
* compare desktop and mobile
* check collapsed sidebar state
* check hover states
* check tables
* check buttons
* check forms
* check modal/details/summary behavior
* check no missing images/icons
* check no console errors

If possible, use screenshot diff.

### Phase 15 — Final response requirements

When finishing the task, report:

1. files changed
2. CSS mappings completed
3. any Tailwind config changes
4. any values that could not be represented exactly
5. any remaining visual risk
6. how to run and verify the page

Never claim pixel-perfect unless verified by screenshot comparison.
