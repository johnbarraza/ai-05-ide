import IT25AIKnowledgeEconomy.PaperInterface

/-!
# Exact-type proof endpoints

Each theorem below has exactly the type of its transparent human-facing Spec.
-/

namespace IT25AIKnowledgeEconomy

theorem discreteAutonomousZeroProfit : discreteAutonomousZeroProfitSpec := by
  intro a h z hden
  exact autonomous_zero_profit a h z hden

theorem discreteBottomWinnerThreshold : discreteBottomWinnerThresholdSpec := by
  intro a h z w0 hfactor
  exact autonomous_bottom_winner_iff a h z w0 hfactor

theorem discreteNonAutonomousWedge : discreteNonAutonomousWedgeSpec := by
  intro a h z
  exact nonautonomous_wage_wedge a h z

end IT25AIKnowledgeEconomy
