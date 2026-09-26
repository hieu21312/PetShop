# Governance V2 Migration Notes

This folder is for mapping active config to governance v2 over time.

## Primary Document

- `active-to-v2-map.md`
  Main migration map from active config to governance v2 layers.

## Migration Goals

- identify duplicate rules
- identify contradictory rules
- identify rules that belong at a different layer
- move toward a smaller and clearer source-of-truth set

## Suggested Migration Order

1. Global workflow and artifact rules
2. Debugging claim discipline and verification rules
3. Planner and implementer boundaries
4. Reviewer output contract
5. Template alignment

## Mapping Questions to Track

- Which rule is the source of truth?
- Which active file should eventually delegate instead of duplicate?
- Which current rule is too broad, too vague, or too repetitive?
- Which current rule should remain active even after migration?
