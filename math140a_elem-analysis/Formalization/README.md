# Math 140A: Lean companion

Lean exercises alongside the LaTeX course notes. Lean and mathlib are pinned to
v4.29.0; `lake-manifest.json` records the resolved dependency revisions.

## Open and build

Open `math140a_elem-analysis/Formalization` in VS Code with the **Lean 4**
extension (`leanprover.lean4`).
Start in `Math140A/NaturalNumbers.lean` and use Lean's Infoview to inspect goals.

From this directory, initialize dependencies on a fresh checkout:

```sh
lake update
lake exe cache get
```

Build all imported course chapters:

```sh
lake build
```

Check just the first chapter while working:

```sh
lake env lean Math140A/NaturalNumbers.lean
```

From this directory, `make -C ..` builds the LaTeX notes;
`lake build` checks the Lean proofs.

## Organization

- `Math140A.lean`: imports the course chapters.
- `Math140A/NaturalNumbers.lean`: companion to `../sections/1_natural-numbers.tex`.
- `lakefile.toml`: library configuration and mathlib dependency.
- `lean-toolchain`: Lean version.
- `lake-manifest.json`: dependency lockfile; keep it in version control.
- `.lake/`: downloaded dependencies and build output; ignored by Git.

Add one Lean module per textbook chapter and import it in `Math140A.lean`.
Begin with `import Mathlib` in each chapter and use the standard number types.
Lean's `ℕ` includes zero, so translate the course's convention explicitly.

## Learning workflow

Write the informal proof first, check that the Lean statement expresses it,
then build the proof one goal at a time. Ask AI for hints, explanations, and
library searches. Compile completed proofs and remove any `sorry` placeholders.

For induction exercises, use the recursive equations and induction hypothesis
rather than invoking the result you are practicing.

Reference: [Mathematics in Lean](https://leanprover-community.github.io/mathematics_in_lean/).
