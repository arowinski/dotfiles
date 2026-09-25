---
paths:
  - "**/*.heex"
  - "**/*.erb"
  - "**/*.css"
  - "**/components/**"
---

# UI judgment

The project's design system decides tokens and components; these rules add judgment on top.

## Direction

Before building, name what the surface is: a dense operational tool used daily, a form filled once, or a report read top to bottom. Density, hierarchy, and copy follow from that.
Give each screen one primary thing. Show it through scale contrast and spacing rhythm within the project's scale, so the eye lands there first.
Colour carries meaning (status, action, selection); decoration uses neutrals.

## Slop tells

Replace these when they appear: a grid of identical cards with no hierarchy, the same radius and shadow on every element, a library block pasted as-is, a gradient hero with a centred headline.
Test each surface: would it pass as a screenshot of a real product, or does it read as a template?

## Polish

- `text-wrap: balance` on headings, `text-wrap: pretty` on short text
- `tabular-nums` on numbers that change or line up in columns
- Concentric radius: outer radius = inner radius + padding
- Optically centre icons next to text
- Exit motion shorter than enter; transition only the properties that change, never `transition: all` or `will-change: all`
- Hit areas of 40–44px on interactive controls

## Accessibility

Every control has a label, visible or `aria-label` when the icon says it all.
Text and controls meet WCAG AA contrast in every theme the project ships.
Every interactive element is reachable by keyboard with a visible focus ring.
Errors sit next to their field and are linked to it (`aria-describedby`).
Reach for native elements (`button`, `a`, `label`, `dialog`) first; add ARIA only where native HTML falls short.
