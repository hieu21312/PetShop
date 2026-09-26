# UI/UX Standards

Use this file when frontend tasks need more concrete UI and UX standards than the lightweight `frontend.md` entrypoint.
This file is a secondary frontend rule module. Use `frontend.md` first for general frontend safety and structure, then use this file when the task needs more explicit UI/UX standards.

## Visual Hierarchy

- Order information from primary to secondary importance.
- Use size, weight, spacing, and color contrast to make the primary action obvious.
- Keep headings, support text, controls, and results visually distinct.

## Layout & Spacing

- Use consistent spacing increments throughout a screen or component.
- Prefer readable vertical stacking for forms and settings-heavy pages.
- Keep navigation, content, and action areas visually separated.
- Avoid overcrowding the viewport with too many competing cards, banners, or panels.

## Forms

- Every input should have a clear label.
- Show validation errors close to the field that caused them.
- Mark required fields clearly.
- Prefer explicit helper text over relying only on placeholder copy.

## Tables & Dense Data

- Keep headers clear and aligned with the data beneath them.
- Right-align numeric values and left-align descriptive text where that improves scanning.
- Handle long text with truncation plus a discoverable way to inspect the full value.
- Add pagination, filtering, or scrolling support when datasets become large.

## States

- Design and implement explicit normal, loading, disabled, error, and success states for interactive surfaces where relevant.
- Prefer skeletons or contextual loading indicators over generic blocking spinners when feasible.

## Accessibility

- Preserve labels, keyboard navigation, focus visibility, semantic structure, and meaningful alt text.
- Maintain readable contrast for text, controls, and state indicators.
- Ensure interactive targets remain usable on both desktop and mobile.

## Responsive Behavior

- Support desktop and mobile layouts for frontend work unless the task is explicitly single-form-factor.
- Make overflow, wrapping, and stacking behavior predictable.

## Scope Notes

- Use this file for concrete, reusable UI/UX standards.
- Use `.agents/rules/taste-skill.md` for advanced visual direction, anti-slop heuristics, landing-page style, and stronger aesthetic constraints.

## PetShop Admin Design System Tokens (Mandatory)

When creating or editing any Admin view in `src/main/resources/templates/admin/`:
1. **Layout Inheritance**: Always wrap the page in `<div th:replace="~{layout :: layout(content=~{::section})}">`. Never write standalone `<html>` or `<head>` tags in admin templates.
2. **Reference Template**: Always reference `src/main/resources/templates/admin/suppliers.html` for standard grid layout (`col-md-3` sidebar, `col-md-9` main content).
3. **Table Styling**: Always use `<thead class="table-pink text-nowrap">` for table headers (coral pink gradient `#ff4d6d` -> `#ff758f`).
4. **Text Wrapping**: Always add `text-nowrap` to table headers and table data cells (`<td>`) to prevent ugly multi-line button/text stretching.
5. **Add Button**: Primary action button must use `<a class="btn btn-success">` (Teal gradient `#00c6a9` -> `#00b894` pill button).
6. **Edit Action**: Edit button must use `<a class="btn btn-sm btn-warning">` (Yellow `#ffb142` pill button with white text).
7. **Delete Action**: Delete button must use `<a class="btn btn-sm btn-danger">` (Coral red `#ff5252` pill button with white text).
8. **Sidebar Dropdown**: 2-Level menu items in `admin-sidebar.html` must be grouped under a collapsible item with FontAwesome icons and clear text.
