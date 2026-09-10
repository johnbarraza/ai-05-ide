"""Symbolic audit and figure for the three-type reduced-form exercise."""

from pathlib import Path

import matplotlib.pyplot as plt
import numpy as np
import sympy as sp


def symbolic_checks() -> None:
    a, h, z_l, w0 = sp.symbols("a h z_L w_L0", positive=True)
    n_l = 1 / (h * (1 - z_l))
    wage_autonomous = sp.solve(sp.Eq(n_l * (a - sp.Symbol("wA")) - a, 0), sp.Symbol("wA"))[0]
    expected = a * (1 - h * (1 - z_l))
    assert sp.simplify(wage_autonomous - expected) == 0

    threshold = sp.simplify(w0 / (1 - h * (1 - z_l)))
    assert sp.simplify(expected.subs(a, threshold) - w0) == 0

    wage_non_autonomous = sp.solve(
        sp.Eq(n_l * (a - sp.Symbol("wN")), 0), sp.Symbol("wN")
    )[0]
    wedge = sp.simplify(wage_non_autonomous - wage_autonomous)
    assert wedge == a * h * (1 - z_l)

    print("Symbolic autonomous wage:", wage_autonomous)
    print("Bottom-winner threshold (for 0<h<1 and 0<=z_L<1): a >", threshold)
    print("Non-autonomy wage wedge:", wedge)


def make_figure() -> None:
    z_l, h, w0 = 0.10, 0.40, 0.25
    capability = np.linspace(0.0, 0.95, 500)
    factor = 1 - h * (1 - z_l)
    threshold_aut = w0 / factor

    wage_a = factor * capability
    wage_n = np.where(capability > w0, capability, w0)

    assert np.isclose(factor, 0.64)
    assert np.isclose(threshold_aut, 0.390625)
    assert factor * 0.30 < w0 < factor * 0.60
    assert 0.30 > w0

    plt.rcParams.update({"font.family": "DejaVu Sans", "font.size": 11})
    fig, ax = plt.subplots(figsize=(9.2, 4.8))
    ax.plot(capability, np.full_like(capability, w0), color="#333333", lw=2, label="Pre-AI wage")
    ax.plot(capability, wage_a, color="#982A34", lw=3, label="Autonomous AI")
    ax.plot(capability, wage_n, color="#0C2852", lw=3, label="Non-autonomous AI")
    ax.axvline(w0, color="#0C2852", ls="--", lw=1.3)
    ax.axvline(threshold_aut, color="#982A34", ls="--", lw=1.3)
    ax.text(w0 - 0.01, 0.79, r"adoption: $a>w(0)$", color="#0C2852", rotation=90,
            va="top", ha="right", transform=ax.get_xaxis_transform())
    ax.text(threshold_aut + 0.01, 0.79, r"autonomous bottom winner: $a>\bar a_L$",
            color="#982A34", rotation=90, va="top", ha="left", transform=ax.get_xaxis_transform())
    ax.set(xlabel=r"AI capability $a=z_{AI}$", ylabel=r"Low-type wage",
           xlim=(0, 0.95), ylim=(0, 0.75))
    ax.grid(axis="y", color="#EBEEF1", lw=1)
    ax.spines[["top", "right"]].set_visible(False)
    ax.legend(frameon=False, ncol=3, loc="upper left")
    fig.tight_layout()

    out = Path(__file__).parent / "extra" / "figures"
    out.mkdir(parents=True, exist_ok=True)
    fig.savefig(out / "discrete-bottom-gains.pdf", bbox_inches="tight")
    fig.savefig(out / "discrete-bottom-gains.png", dpi=220, bbox_inches="tight")
    plt.close(fig)


if __name__ == "__main__":
    symbolic_checks()
    make_figure()
    print("Wrote extra/figures/discrete-bottom-gains.{pdf,png}")
