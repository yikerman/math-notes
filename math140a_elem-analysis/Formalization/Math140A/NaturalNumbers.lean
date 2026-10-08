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

end Math140A
