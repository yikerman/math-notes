/-
Math 3A — Linear Algebra: §1 Linear Systems (Lean formalization)

Accompanies `sections/1_linear-systems.tex`. Trivial definitions are
pulled from Mathlib; the structural theorems are proved by hand;
theorems that depend on row-echelon / RREF are left as `sorry`
(the course defers these, and Mathlib does not yet expose a clean
`IsRowEchelon` predicate).

Cross-references: `def:<label>` / `thm:<label>` point at the
corresponding block in the LaTeX source.
-/
import Mathlib

namespace Math3a.LinearSystems

/-!
## §1.1–§1.2  Linear systems, augmented matrix, echelon form

A linear equation (`def:lin-eq`)
  `a₁x₁ + ⋯ + aₙxₙ = b`
and an `m × n` linear system (`def:lin-sys`)
```
⎧ a₁₁x₁ + ⋯ + a₁ₙxₙ = b₁
⎨       ⋮
⎩ aₘ₁x₁ + ⋯ + aₘₙxₙ = bₘ
```
are packaged as a single matrix equation
  `A.mulVec x = b`
with `A : Matrix (Fin m) (Fin n) ℝ`, unknowns `x : Fin n → ℝ`,
right-hand side `b : Fin m → ℝ`.

Row operations (`def:elem-row-ops`), echelon form (`def:echelon`),
and reduced echelon form (`def:rref`) are *algorithms* for solving
this equation; they are not needed as formal objects to state the
structural results below, so we do not formalize them here.
-/

/-- `x` is a solution to the system `A x = b`. See `def:lin-sys`. -/
def IsSolution {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ)
    (b : Fin m → ℝ) (x : Fin n → ℝ) : Prop :=
  A.mulVec x = b

/-!
## §1.3  Existence and uniqueness (echelon-form theorems)

Three theorems in the notes reason about the echelon form of `A`:

* `thm:inconsistent` — inconsistent iff echelon has a `[0 ⋯ 0 | b]`
  row with `b ≠ 0`;
* `thm:unique-inf` — unique iff no free variables;
* `thm:existence` — `A x = b` solvable for every `b` iff the
  echelon form of `A` has a pivot in every row.

Mathlib does not yet ship a usable `IsRowEchelon` predicate, so the
formal statements require a notion we have not built. They are
placeholders below; we will revisit them via `Matrix.rank` later
in the course.
-/

-- thm:inconsistent
theorem inconsistent_iff_zero_row_nonzero_rhs :
    True := by sorry

-- thm:unique-inf
theorem unique_iff_no_free_variable :
    True := by sorry

-- thm:existence
theorem solvable_forall_iff_pivot_every_row :
    True := by sorry

/-!
## §1.4  Homogeneous and non-homogeneous systems
-/

-- def:homo-sys
/-- The homogeneous system `A x = 0`. -/
def IsHomogeneousSolution {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (x : Fin n → ℝ) : Prop :=
  A.mulVec x = 0

/-- Zero is always a solution to the homogeneous system — the
"trivial solution" remarked on after `def:homo-sys`. -/
theorem mulVec_zero_eq_zero {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    A.mulVec (0 : Fin n → ℝ) = 0 :=
  Matrix.mulVec_zero A

-- thm:general-soln
/--
**General solution decomposition.** If `xₚ` is a particular
solution to `A x = b`, then for every `x`,
  `A x = b ↔ A (x - xₚ) = 0`,
i.e. the general solution is `xₚ + xₕ` where `xₕ` ranges over
solutions of the homogeneous system.

Informal proof from the notes:
  `A(x - xₚ) = A x - A xₚ = b - b = 0`,
so `xₕ := x - xₚ` solves the homogeneous system; conversely any
`xₚ + xₕ` with `A xₕ = 0` is a solution.
-/
theorem general_solution {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (b : Fin m → ℝ)
    {xₚ : Fin n → ℝ} (hp : A.mulVec xₚ = b) (x : Fin n → ℝ) :
    A.mulVec x = b ↔ A.mulVec (x - xₚ) = 0 := by
  rw [Matrix.mulVec_sub, hp, sub_eq_zero]

/-!
## §1.5  Linear Independence
-/

-- def:lin-dep-indep
/-- Linear dependence: the negation of Mathlib's
`LinearIndependent`. A family `v : Fin n → (Fin m → ℝ)` is
dependent iff some non-trivial combination of the `vᵢ` vanishes. -/
abbrev LinDep {m n : ℕ} (v : Fin n → (Fin m → ℝ)) : Prop :=
  ¬ LinearIndependent ℝ v

-- thm:zero-vec-dep
/--
If some `vᵢ = 0` then `v₁, …, vₙ` is linearly dependent.

Informal proof (notes): take `xᵢ = 1`, `xⱼ = 0` for `j ≠ i`, then
`x₁ v₁ + ⋯ + xₙ vₙ = vᵢ = 0` is a non-trivial relation.

Formal proof: `LinearIndependent.ne_zero` says every vector in a
linearly independent family is non-zero; contradicting `hi`.
-/
theorem linDep_of_zero_mem {m n : ℕ} (v : Fin n → (Fin m → ℝ))
    (i : Fin n) (hi : v i = 0) : LinDep v := fun hind =>
  hind.ne_zero i hi

-- thm:too-many-dep
/--
More vectors than the ambient dimension ⇒ linearly dependent:
`n > m` vectors in `ℝᵐ` are dependent.

Informal proof (notes): `A := [v₁ ⋯ vₙ] ∈ ℝ^{m×n}` has
`#pivots ≤ m < n`, so `#free vars > 0`, so a non-trivial
solution to `A x = 0` exists.

Formal proof: we reuse Mathlib's `finrank`-based version
(`LinearIndependent.fintype_card_le_finrank`), since the course
defers rank but the fact itself is independent of the formalization
route. `Fin m → ℝ` has `finrank ℝ = m`.
-/
theorem linDep_of_too_many {m n : ℕ} (h : m < n)
    (v : Fin n → (Fin m → ℝ)) : LinDep v := fun hind => by
  have hle : Fintype.card (Fin n) ≤ Module.finrank ℝ (Fin m → ℝ) :=
    hind.fintype_card_le_finrank
  simp [Fintype.card_fin, Module.finrank_fintype_fun_eq_card] at hle
  omega

end Math3a.LinearSystems
