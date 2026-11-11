namespace Math140A

class NatStruct (N : Type) where
  one : N
  succ : N → N
  one_ne_succ : ∀ n : N, one ≠ succ n
  succ_inj : ∀ m n : N, succ m = succ n → m = n
  induction_principle :
    ∀ P : N → Prop,
    P one → (∀ n : N, P n → P (succ n)) →
    ∀ n : N, P n

-- every nat is either one or succ of smth
theorem one_or_succ {N : Type} [NatStruct N] (n : N) :
  n = NatStruct.one ∨ ∃ m : N, n = NatStruct.succ m := by
  refine NatStruct.induction_principle
    (fun k : N => k = NatStruct.one ∨ ∃ m : N, k = NatStruct.succ m)
    ?_
    ?_
    n
  · left
    rfl
  · intro k _ih
    right
    exact ⟨k, rfl⟩

end Math140A
