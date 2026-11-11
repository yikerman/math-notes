import Mathlib

namespace Math140A

abbrev Seq :=  ℕ → ℝ

def SeqConvTo (a : Seq) (L : ℝ) : Prop :=
  ∀ ε : ℝ, ε > 0 → ∃ N : ℕ, ∀ n : ℕ, N ≤ n → |a n - L| < ε

-- constant sequence a n = c converges to c
theorem constant_sequence_converges (c : ℝ) :
    -- ∀ ε : ℝ, 0 < ε →
    -- ∃ N : ℕ, ∀ n : ℕ, N ≤ n → |c - c| < ε
  SeqConvTo (fun _n ↦ c) c
:= by
  intro ε hε
  use 1 -- refine ⟨1, ?_⟩
  simp only [sub_self, abs_zero]
  intro n hn
  exact hε

lemma eq_of_arbitr_small_dist (x y : ℝ) :
  (∀ ε > 0, |x - y| < ε) ↔ x = y := by
  constructor
  · intro h -- =>
    contrapose! h
    use |x - y|
    simp
    exact sub_ne_zero.mpr h
  · intro h -- <=
    rw [h]
    simp only [sub_self, abs_zero]
    intro ε hε
    exact hε

theorem limit_uniqueness (a : Seq) :
  ∀ M N : ℝ, (SeqConvTo a M ∧ SeqConvTo a N) → M = N := by
  intro M N h
  apply (eq_of_arbitr_small_dist M N).mp
  intro ε hε
  have hhalf : 0 < ε / 2 := by
    apply div_pos
    · exact hε
    · norm_num
  obtain ⟨hM, hN⟩ := h
  obtain ⟨N₁, h₁⟩ := hM (ε / 2) hhalf
  obtain ⟨N₂, h₂⟩ := hN (ε / 2) hhalf
  let K := max N₁ N₂
  have hMk : |a K - M| < ε / 2 :=
    h₁ K (le_max_left N₁ N₂)
  have hNk : |a K - N| < ε / 2 :=
    h₂ K (le_max_right N₁ N₂)
  have hMk' : |M - a K| < ε / 2 := by
    rw [abs_sub_comm]
    exact hMk
  calc
    |M - N| ≤ |M - a K| + |a K - N| := abs_sub_le M (a K) N
    _ < ε / 2 + ε / 2 := add_lt_add hMk' hNk
    _ = ε := by ring



end Math140A
