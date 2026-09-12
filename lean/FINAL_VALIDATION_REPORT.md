# Final validation report

## Scope

Lean checks the finite accounting extension presented in the weekly repository,
not the full continuum equilibrium of Ide and Talamàs (2025).

## Proof endpoints

- `discreteAutonomousZeroProfit`
- `discreteBottomWinnerThreshold`
- `discreteNonAutonomousWedge`

All endpoints are defined without `sorry` or new axioms beyond Lean/mathlib's
standard classical foundations. Build command:

```bash
lake build IT25AIKnowledgeEconomy
lake env lean papers/IT25AIKnowledgeEconomy/AxiomAudit.lean
```

## Interpretation

The threshold equivalence is a capability statement. The wage-wedge identity
shows how autonomy changes the compute outside option and surplus division.
