import Mathlib

/-!
# Three-type accounting model

This file formalizes the finite accounting exercise used in the weekly
presentation. The variables are AI capability `a`, communication cost `h`,
low-type knowledge `z`, and the pre-AI low wage `w0`.
-/

namespace IT25AIKnowledgeEconomy

/-- Workers served per solver in the discrete exercise. -/
noncomputable def span (h z : ℝ) : ℝ := 1 / (h * (1 - z))

/-- Low-type wage when autonomous AI has outside option `a`. -/
def autonomousWage (a h z : ℝ) : ℝ := a * (1 - h * (1 - z))

/-- Low-type wage with active non-autonomous AI and zero compute rent. -/
def nonAutonomousWage (a : ℝ) : ℝ := a

/-- Capability threshold above which the low type beats its pre-AI wage. -/
noncomputable def bottomThreshold (w0 h z : ℝ) : ℝ :=
  w0 / (1 - h * (1 - z))

/-- Substituting the autonomous wage into the firm's profit gives zero. -/
theorem autonomous_zero_profit
    (a h z : ℝ) (hden : h * (1 - z) ≠ 0) :
    span h z * (a - autonomousWage a h z) - a = 0 := by
  rw [span, autonomousWage]
  have hwage : a - a * (1 - h * (1 - z)) = a * (h * (1 - z)) := by
    ring
  rw [hwage, one_div]
  calc
    (h * (1 - z))⁻¹ * (a * (h * (1 - z))) - a =
        a * ((h * (1 - z))⁻¹ * (h * (1 - z))) - a := by ring
    _ = a * 1 - a := by rw [inv_mul_cancel₀ hden]
    _ = 0 := by ring

/-- Bottom gains are exactly a capability-threshold condition. -/
theorem autonomous_bottom_winner_iff
    (a h z w0 : ℝ) (hfactor : 0 < 1 - h * (1 - z)) :
    autonomousWage a h z > w0 ↔ a > bottomThreshold w0 h z := by
  rw [autonomousWage, bottomThreshold]
  exact (div_lt_iff₀ hfactor).symm

/-- Non-autonomy removes the autonomous AI rent wedge from the low wage. -/
theorem nonautonomous_wage_wedge (a h z : ℝ) :
    nonAutonomousWage a - autonomousWage a h z = a * h * (1 - z) := by
  simp [nonAutonomousWage, autonomousWage]
  ring

/-- Under the positive interior conditions, the active non-autonomous wage is
strictly higher than the autonomous wage in the discrete exercise. -/
theorem nonautonomous_wage_strictly_higher
    (a h z : ℝ) (ha : 0 < a) (hh : 0 < h) (hz : z < 1) :
    autonomousWage a h z < nonAutonomousWage a := by
  rw [← sub_pos]
  rw [nonautonomous_wage_wedge]
  exact mul_pos (mul_pos ha hh) (sub_pos.mpr hz)

end IT25AIKnowledgeEconomy
