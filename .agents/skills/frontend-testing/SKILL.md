---
name: verifying-frontend-style
description: Execute visual validation, style audits, and rendering verification for frontend views. Use when changes are made to index.html, style.css, or frontend elements.
---

# Verifying Frontend Style

This skill outlines the auditing steps required to ensure frontend interfaces are responsive, follow the Lila anti-slop design system guidelines, and display correctly without overlapping elements.
This skill is specialized verification support, not the primary source of repo-wide policy or workflow dispatch rules.

## When to use this skill
- Use this when modifying HTML structures, CSS classes, or UI animations.
- Avoid using this for backend-only database or logic changes.

## Verification Checklist

### 1. Viewport Fit & Responsiveness
- Check if all hero text and CTAs fit within the standard desktop viewport (1920x1080) and mobile viewport (375px wide).
- Verify that buttons do not wrap text or overlap adjacent grid elements.

### 2. Style Audit (Anti-Slop)
- Confirm that no default "AI purple glows" are applied unless explicitly in the approved design system.
- Check WCAG contrast compliance (minimum 4.5:1 ratio) for active CTAs and placeholders.
- Verify that custom fonts loaded from Google Fonts (e.g. Outfit, Inter) render correctly.

### 3. Action States
- Verify hover (`:hover`), focus (`:focus`), and physical tap active (`:active`) classes perform subtle transitions.
