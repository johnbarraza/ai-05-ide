# Extensions and audit

## 1. A three-type accounting exercise

This is a transparent discrete reduction, not a claimed reconstruction of the full continuum equilibrium. Let human types be $L<M<H$, let the low type have knowledge $z_L$, and let

$$n_L=\frac{1}{h(1-z_L)}$$

be the number of identical low workers whose unresolved problems exhaust one solver's unit of time.

When autonomous AI of knowledge $a=z_{AI}$ is their solver, its opportunity cost is the compute rent. Abundant compute and independent AI production imply $r^*=a$. Zero profit for the automated team gives

$$n_L[a-w_L^A]-r^*=0
\quad\Longrightarrow\quad
w_L^A(a)=a\left(1-\frac{1}{n_L}\right)
=a[1-h(1-z_L)].$$

Relative to a pre-AI low wage $w_L^0$, bottom workers gain exactly when

$$a>\bar a_L\equiv\frac{w_L^0}{1-h(1-z_L)}.$$

The threshold is a **capability** condition. Autonomy matters because it creates the outside option $r^*=a$, which subtracts from the surplus captured by the assisted workers.

For non-autonomous AI, unused compute has rent $r^\star=0$. If AI is adopted as solver, the same zero-profit equation gives $w_L^N(a)=a$. Proposition 6 supplies the equilibrium adoption condition $a>w(0)$; below it, AI is unused and $w_L^N=w_L^0$. Consequently, when active,

$$w_L^N(a)-w_L^A(a)=a\,h(1-z_L)>0.$$

This is the autonomy comparison, conditional on sufficient capability for adoption. The middle type closes labor markets in the full model; the high type captures a larger span-of-control surplus under autonomy. Keeping $M$ explicit prevents the three-type exercise from pretending that a low–high pair alone clears every role.

## 2. Numerical check

Take $(z_L,h,w_L^0)=(0.10,0.40,0.25)$. Then

$$n_L=\frac{25}{9},\qquad
w_L^A(a)=0.64a,\qquad
\bar a_L=0.390625.$$

At $a=0.30$, non-autonomous AI is active because $0.30>w_L^0$, and the low wage is $0.30$; autonomous AI pays only $0.192<w_L^0$. At $a=0.60$, the wages are $0.60$ and $0.384$, respectively, so the low type wins under either regime but still prefers non-autonomy. The script checks these identities symbolically in SymPy and creates `extra/figures/discrete-bottom-gains.{pdf,png}`.

## 3. What does not hold up

The statement “autonomy, not capability, drives the distributional effect” collapses two margins:

| Margin | Exact condition | Economic role |
|---|---|---|
| Autonomous bottom winners | $z_{AI}>\bar z_{AI}$ | Capability must make the positive share effect dominate the adverse match effect. |
| Non-autonomous adoption | $z_{AI}>w(0)$ | Capability must make AI worth using as a solver. |
| Top winners under autonomy | $h<h_0$ and $z_{AI}<1$ | Low communication cost makes span-of-control gains dominate; this is not unconditional. |
| Output ranking | Same abundant compute and at most two layers | Autonomy lets otherwise idle compute pursue opportunities. |

The paper itself is more careful than the slogan. Proposition 5 states a capability threshold; Proposition 6 separates the inactive and active non-autonomous regimes. The tension is in the common summary, not in those formal statements.

## 4. Limits and corner cases

**Capability $a\downarrow0$.** The discrete autonomous wage tends to zero; it cannot generate bottom winners with positive initial wages. Non-autonomous AI is unused when $a\le w(0)$.

**Capability $a\uparrow1$.** Proposition 5 deliberately uses $a<1$. The accompanying footnote says the most knowledgeable necessarily lose at $a=1$, so “always top winners” must not be extrapolated to the endpoint.

**Communication cost $h\uparrow h_0$.** Team size shrinks. The paper explicitly warns that top winners can disappear for $h\ge h_0$; hence the top result is a theorem inside the maintained low-cost region, not a universal prediction.

**Scarce compute.** Proposition 6 compares regimes holding compute availability identical and abundant. If compute is scarce, non-autonomous rent need not be zero and the simple wage wedge $a/n_L$ changes.

**Two layers.** The welfare comparison is proved in the model with at most two layers. Allowing deeper hierarchies could create additional matching and rent channels; the exercise does not claim invariance.

## 5. Reproducibility

```bash
python -m pip install -r requirements.txt
python discrete_model.py
lualatex presentation.tex
lualatex -output-directory=extra extra/presentation-long.tex
```

The script fails loudly if the symbolic threshold, wage wedge, or selected numerical cases are inconsistent.

## 6. Lean verification

The `lean/` export proves three statements about this discrete extension:

1. `discreteAutonomousZeroProfit`: the proposed autonomous wage satisfies the zero-profit equation;
2. `discreteBottomWinnerThreshold`: the low type wins if and only if capability exceeds the discrete threshold;
3. `discreteNonAutonomousWedge`: the non-autonomous/autonomous wage difference is exactly $ah(1-z_L)$.

The EconCSLib target `IT25AIKnowledgeEconomy` compiled under Lean `v4.30.0-rc2` with no `sorry` or locally declared axioms. `AxiomAudit.lean` reports only `propext`, `Classical.choice`, and `Quot.sound`, the standard foundations inherited through mathlib. This is deliberately a proof of the finite accounting extension—not a claim that Propositions 5 and 6's full continuum equilibrium has been formalized.
