import Mathlib

/-!
# Ide--Talamàs knowledge-economy model

This module records the continuum model used by the paper.  The source-facing
result propositions live in `PaperInterface.lean`; this file contains only the
model, equilibrium, accounting, and comparison vocabulary that they consume.
-/

open MeasureTheory Set

noncomputable section

namespace IT25KnowledgeEconomy

/-- The three technology regimes compared in the paper. -/
inductive Technology
  | preAI
  | autonomousAI
  | nonAutonomousAI
  deriving DecidableEq

/-- Exogenous primitives held fixed across the paper's equilibrium comparisons. -/
structure Economy where
  population : Measure ℝ
  density : ℝ → ℝ
  helpCost : ℝ
  compute : ℝ
  density_continuous : Continuous density
  density_pos : ∀ z, z ∈ Icc (0 : ℝ) 1 → 0 < density z
  population_eq_density :
    population = volume.withDensity (fun z ↦ ENNReal.ofReal (density z))
  unit_mass : population (Icc (0 : ℝ) 1) = 1
  supported_on_knowledge : population ((Icc (0 : ℝ) 1)ᶜ) = 0
  helpCost_pos : 0 < helpCost
  helpCost_lt_one : helpCost < 1
  compute_nonneg : 0 ≤ compute

/-- The paper's span of control, determined by `h n(z) (1-z) = 1`. -/
def span (E : Economy) (z : ℝ) : ℝ := 1 / (E.helpCost * (1 - z))

/-- An equilibrium candidate: compute uses, occupations, matching, wages, and rent. -/
structure Outcome where
  computeIndependent : ℝ
  computeWorkers : ℝ
  computeSolvers : ℝ
  independent : Set ℝ
  peopleWorkers : Set ℝ
  aiAssistedWorkers : Set ℝ
  peopleSolvers : Set ℝ
  aiAssistedSolvers : Set ℝ
  matching : ℝ → ℝ
  employeeMatching : ℝ → ℝ
  wage : ℝ → ℝ
  rent : ℝ

/-- All human workers in an outcome. -/
def Outcome.workers (o : Outcome) : Set ℝ :=
  o.aiAssistedWorkers ∪ o.peopleWorkers

/-- All human solvers in an outcome. -/
def Outcome.solvers (o : Outcome) : Set ℝ :=
  o.aiAssistedSolvers ∪ o.peopleSolvers

/--
The paper's `A ≼ B` relation.  This pairwise formulation makes the intended
occupational-order statement meaningful when an intermediate occupation is
empty; for nonempty bounded sets it is equivalent to `sSup A ≤ sInf B`.
-/
def LiesBelow (A B : Set ℝ) : Prop :=
  ∀ a, a ∈ A → ∀ b, b ∈ B → a ≤ b

/-- AI capability belongs to the source domain `[0,1)`. -/
def ValidAIKnowledge (a : ℝ) : Prop := a ∈ Ico (0 : ℝ) 1

/-- Human independent-producer profit. -/
def independentHumanProfit (o : Outcome) (z : ℝ) : ℝ := z - o.wage z

/-- AI independent-producer profit (available only with autonomous AI). -/
def independentAIProfit (o : Outcome) (a : ℝ) : ℝ := a - o.rent

/-- Profit when AI is the solver and humans of knowledge `z` are workers. -/
def aiSolverProfit (E : Economy) (o : Outcome) (a z : ℝ) : ℝ :=
  span E z * (a - o.wage z) - o.rent

/-- Profit when AI supplies workers and a human of knowledge `s` is the solver. -/
def aiWorkerProfit (E : Economy) (o : Outcome) (a s : ℝ) : ℝ :=
  span E a * (s - o.rent) - o.wage s

/-- Profit of a fully human two-layer firm. -/
def peopleFirmProfit (E : Economy) (o : Outcome) (s z : ℝ) : ℝ :=
  span E z * (s - o.wage z) - o.wage s

/-- All five occupation sets are measurable and cover `[0,1]` up to null overlaps. -/
def HumanMarketPartition (E : Economy) (o : Outcome) : Prop :=
  MeasurableSet o.independent ∧
  MeasurableSet o.peopleWorkers ∧
  MeasurableSet o.aiAssistedWorkers ∧
  MeasurableSet o.peopleSolvers ∧
  MeasurableSet o.aiAssistedSolvers ∧
  o.independent ∪ o.peopleWorkers ∪ o.aiAssistedWorkers ∪
      o.peopleSolvers ∪ o.aiAssistedSolvers = Icc (0 : ℝ) 1 ∧
  E.population (o.independent ∩ o.peopleWorkers) = 0 ∧
  E.population (o.independent ∩ o.aiAssistedWorkers) = 0 ∧
  E.population (o.independent ∩ o.peopleSolvers) = 0 ∧
  E.population (o.independent ∩ o.aiAssistedSolvers) = 0 ∧
  E.population (o.peopleWorkers ∩ o.aiAssistedWorkers) = 0 ∧
  E.population (o.peopleWorkers ∩ o.peopleSolvers) = 0 ∧
  E.population (o.peopleWorkers ∩ o.aiAssistedSolvers) = 0 ∧
  E.population (o.aiAssistedWorkers ∩ o.peopleSolvers) = 0 ∧
  E.population (o.aiAssistedWorkers ∩ o.aiAssistedSolvers) = 0 ∧
  E.population (o.peopleSolvers ∩ o.aiAssistedSolvers) = 0

/-- The paper's matching resource equation, including image measurability. -/
def MatchingClears (E : Economy) (o : Outcome) : Prop :=
  MapsTo o.matching o.peopleWorkers o.peopleSolvers ∧
  MapsTo o.employeeMatching o.peopleSolvers o.peopleWorkers ∧
  Set.LeftInvOn o.employeeMatching o.matching o.peopleWorkers ∧
  Set.LeftInvOn o.matching o.employeeMatching o.peopleSolvers ∧
  ∀ Y, MeasurableSet Y → Y ⊆ o.peopleWorkers →
    MeasurableSet (o.matching '' Y) ∧
    (∫ u in Y, E.helpCost * (1 - u) ∂E.population) =
      ∫ _u in o.matching '' Y, (1 : ℝ) ∂E.population

/-- Compute use induced by the occupation sets. -/
def ComputeUseConsistent (E : Economy) (o : Outcome) (a : ℝ) : Prop :=
  o.computeSolvers =
      ∫ z in o.aiAssistedWorkers, E.helpCost * (1 - z) ∂E.population ∧
  o.computeWorkers = span E a *
      (∫ _z in o.aiAssistedSolvers, (1 : ℝ) ∂E.population)

/-- Market clearing under a given technology. -/
def MarketsClear (E : Economy) (technology : Technology) (o : Outcome) (a : ℝ) : Prop :=
  0 ≤ o.computeIndependent ∧ 0 ≤ o.computeWorkers ∧
  0 ≤ o.computeSolvers ∧
  o.computeIndependent + o.computeWorkers + o.computeSolvers = E.compute ∧
  HumanMarketPartition E o ∧ MatchingClears E o ∧ ComputeUseConsistent E o a ∧
  (technology = .preAI →
    o.computeIndependent = 0 ∧ o.computeWorkers = 0 ∧ o.computeSolvers = 0 ∧
    o.aiAssistedWorkers = ∅ ∧ o.aiAssistedSolvers = ∅) ∧
  (technology = .nonAutonomousAI →
    o.computeWorkers = 0 ∧ o.aiAssistedSolvers = ∅)

/-- Every available firm earns at most zero and every active firm earns zero. -/
def FirmsOptimize (E : Economy) (technology : Technology) (o : Outcome) (a : ℝ) : Prop :=
  o.rent ≥ 0 ∧ (∀ z ∈ Icc (0 : ℝ) 1, 0 ≤ o.wage z) ∧
  (∀ z ∈ Icc (0 : ℝ) 1, independentHumanProfit o z ≤ 0) ∧
  (∀ s ∈ Icc (0 : ℝ) 1, ∀ z ∈ Icc (0 : ℝ) s,
    peopleFirmProfit E o s z ≤ 0) ∧
  (∀ z ∈ o.independent, independentHumanProfit o z = 0) ∧
  (∀ z ∈ o.peopleWorkers, peopleFirmProfit E o (o.matching z) z = 0) ∧
  (technology = .autonomousAI →
    independentAIProfit o a ≤ 0 ∧
    (∀ z ∈ Icc (0 : ℝ) a, aiSolverProfit E o a z ≤ 0) ∧
    (∀ s ∈ Icc a 1, aiWorkerProfit E o a s ≤ 0) ∧
    (0 < o.computeIndependent → independentAIProfit o a = 0) ∧
    (∀ z ∈ o.aiAssistedWorkers, aiSolverProfit E o a z = 0) ∧
    (∀ s ∈ o.aiAssistedSolvers, aiWorkerProfit E o a s = 0)) ∧
  (technology = .nonAutonomousAI →
    (∀ z ∈ Icc (0 : ℝ) a, aiSolverProfit E o a z ≤ 0) ∧
    (∀ z ∈ o.aiAssistedWorkers, aiSolverProfit E o a z = 0))

/-- Source definition: competitive equilibrium. -/
def CompetitiveEquilibrium
    (E : Economy) (technology : Technology) (a : ℝ) (o : Outcome) : Prop :=
  MarketsClear E technology o a ∧ FirmsOptimize E technology o a

/-- The source sufficient condition for compute to be abundant relative to human time. -/
def ComputeAbundant (E : Economy) (a : ℝ) : Prop :=
  (∫ z in Icc (0 : ℝ) a, (span E z)⁻¹ ∂E.population) +
      span E a * (1 - (E.population (Iic a)).toReal) < E.compute

/-- Total output under the paper's five firm configurations. -/
def totalOutput (E : Economy) (technology : Technology) (o : Outcome) (a : ℝ) : ℝ :=
  (∫ z in o.independent, z ∂E.population) +
  (if technology = .autonomousAI then a * o.computeIndependent else 0) +
  (∫ z in o.peopleWorkers, o.matching z ∂E.population) +
  (∫ z in o.aiAssistedSolvers, span E a * z ∂E.population) +
  (∫ _z in o.aiAssistedWorkers, a ∂E.population)

/-- Total labor income. -/
def laborIncome (E : Economy) (o : Outcome) : ℝ :=
  ∫ z in Icc (0 : ℝ) 1, o.wage z ∂E.population

/-- Output efficiency holds against allocations with the same exogenous environment. -/
def Efficient (E : Economy) (technology : Technology) (o : Outcome) (a : ℝ) : Prop :=
  ∀ other, MarketsClear E technology other a →
    totalOutput E technology other a ≤ totalOutput E technology o a

/-- Labor-income maximality holds against allocations in the same environment. -/
def MaximizesLaborIncome
    (E : Economy) (technology : Technology) (o : Outcome) (a : ℝ) : Prop :=
  ∀ other, MarketsClear E technology other a → laborIncome E other ≤ laborIncome E o

/-- Worker productivity: the knowledge of the solver assisting the worker. -/
def workerProductivity (a : ℝ) (o : Outcome) (z : ℝ) : ℝ :=
  by
    classical
    exact if z ∈ o.aiAssistedWorkers then a else o.matching z

/-- Solver span of control, increasing with the matched workers' knowledge. -/
def solverSpan (E : Economy) (a : ℝ) (o : Outcome) (z : ℝ) : ℝ :=
  by
    classical
    exact span E (if z ∈ o.aiAssistedSolvers then a else o.employeeMatching z)

/-- Humans weakly below AI who gain from autonomous AI. -/
def bottomWinners (a : ℝ) (pre post : Outcome) : Set ℝ :=
  {z | z ∈ Icc (0 : ℝ) a ∧ pre.wage z < post.wage z}

/-- Humans weakly above AI who gain from autonomous AI. -/
def topWinners (a : ℝ) (pre post : Outcome) : Set ℝ :=
  {z | z ∈ Icc a 1 ∧ pre.wage z < post.wage z}

/-- The distribution-dependent pre-AI organization threshold characterized in Proposition 1. -/
def PreAIThreshold (E : Economy) (h₀ : ℝ) : Prop :=
  h₀ ∈ Ioo (0 : ℝ) 1 ∧
  ∀ o, CompetitiveEquilibrium E .preAI 0 o →
    (o.independent.Nonempty ↔ h₀ < E.helpCost)

/-- The paper's zero-profit span identity, used throughout its wage formulas. -/
theorem span_mul_helpCost_one_sub
    (E : Economy) (z : ℝ) (hz : z < 1) :
    span E z * (E.helpCost * (1 - z)) = 1 := by
  rw [span]
  exact one_div_mul_cancel (mul_ne_zero (ne_of_gt E.helpCost_pos) (sub_ne_zero.mpr (ne_of_gt hz)))

end IT25KnowledgeEconomy
