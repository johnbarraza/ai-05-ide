import IT25AIKnowledgeEconomy.Assumptions

/-!
# Human-facing interface: Ide and Talamàs (2025)

These transparent propositions describe the three-type accounting extension
used in the Week 5 submission. They are not the full continuum statements of
Propositions 5 and 6.
-/

namespace IT25AIKnowledgeEconomy

/-- The autonomous low wage satisfies the discrete firm's zero-profit equation. -/
def discreteAutonomousZeroProfitSpec : Prop :=
  ∀ (a h z : ℝ), h * (1 - z) ≠ 0 →
    span h z * (a - autonomousWage a h z) - a = 0

/-- The low type wins exactly above the capability threshold. -/
def discreteBottomWinnerThresholdSpec : Prop :=
  ∀ (a h z w0 : ℝ), 0 < 1 - h * (1 - z) →
    (autonomousWage a h z > w0 ↔ a > bottomThreshold w0 h z)

/-- The active non-autonomous regime pays the low type the autonomous wage
plus the AI rent wedge. -/
def discreteNonAutonomousWedgeSpec : Prop :=
  ∀ (a h z : ℝ),
    nonAutonomousWage a - autonomousWage a h z = a * h * (1 - z)

end IT25AIKnowledgeEconomy
