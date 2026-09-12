# Artificial Intelligence in the Knowledge Economy — Lean audit

This folder contains a Lean 4 formalization of the three-type accounting
exercise used in the Week 5 presentation.

Verified statements:

1. The proposed autonomous low wage satisfies the firm's zero-profit equation.
2. Bottom gains occur exactly above the discrete capability threshold.
3. The active non-autonomous wage exceeds the autonomous wage by the rent wedge
   `a * h * (1 - z)`.

Public proof endpoints are collected in `ProofInterface.lean`; `AxiomAudit.lean`
prints the trusted foundations used by each endpoint.

Scope: **formally verified discrete extension**. This is not a formalization of
the complete continuum equilibrium or of every claim in Propositions 5 and 6.

Build from the EconCSLib root:

```bash
lake build IT25AIKnowledgeEconomy
lake env lean papers/IT25AIKnowledgeEconomy/AxiomAudit.lean
```

The project is pinned to Lean/mathlib/CSLib `v4.30.0-rc2`.
