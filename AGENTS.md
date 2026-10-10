# Math Notes

Two responsibilities: transcribe university math notes into LaTeX, and help the student learn Lean alongside their courses.

## Transcription

Produce faithful, concise, compiling notes, including every sketch and marked endpoints on parametric/interval plots. Clarify unreadable content rather than guessing.

- Minimize paraphrasing: preserve the original wording and brevity. Do not expand brief notes into explanatory prose or add unrequested commentary or caveats. For example, write “Takeaway: singular solution is meaningful only relative to a specified general-solution family” without adding a paragraph explaining parameter choices or domain restrictions.
- Preserve meaningful line breaks and the step-by-step layout, especially in intuition passages; do not flatten them into prose paragraphs. Distinguish these from handwriting wraps caused by limited space: use the sentence structure, indentation, and available writing space to identify them, and let LaTeX reflow those lines naturally. For example, keep “Weird things don't happen far out” together; retain separate lines for successive conditions, choices, and conclusions.
- Preserve the author's choice of mathematical symbols versus English in both directions: e.g. keep `\forall` when written, and keep “for every” when written. Apply the mandatory formatting conventions below, but do not otherwise translate between symbolic and verbal statements.
- Correct mechanical, spelling, and factual errors with the smallest necessary change. This is not permission to paraphrase or expand the notes; ask about genuinely unreadable or ambiguous content.
- Each course has `main.tex`, `Makefile`, and `sections/<chap>_<topic>.tex`, with one file per textbook chapter. `main.tex` uses `\section` and imports chapter files; chapters use `\subsection` and `\subsubsection`.
- Shared commands, environments, and styling belong in `preamble.tex`; read it before editing. Use minimal LaTeX, `amsmath`/`amssymb`, and `pgfplots`/TikZ for sketches. Examples belong in the `example` environment.
- After LaTeX edits, rebuild the affected course with `make`. New courses follow the existing layout and Makefile template.

## Lean Instructor Mode

The goal is for the student to understand and independently write definitions and proofs connected to their course notes. Support custom foundations and explain their relationship to Lean and mathlib, including differences in conventions and assumptions.

Preserve the student's ownership of exercises: offer explanations and hints, and provide completed definitions or proofs only when explicitly requested. Carry out requested project maintenance directly while preserving their attempts.

Lean projects live in `<course-dir>/Formalization/`, with pinned toolchains and dependencies. After Lean edits, run `lake build` there; distinguish unfinished exercises using `sorry` from completed, checked proofs.

## Formatting (enforce regardless of handwriting style)

- **Matrices**: use square brackets — `\begin{bmatrix}...\end{bmatrix}` for plain matrices and `\left[\begin{array}{...}...\end{array}\right]` for augmented matrices.
- **Determinants**: use `\det(\mathbf{M})` for a named matrix or `\det\begin{bmatrix}...\end{bmatrix}` for a matrix literal — never vertical bars `|M|` or `\begin{vmatrix}...\end{vmatrix}`.
- **Vectors as components**: use angle brackets via `\ve{...}`, e.g. `\ve{x(t),\, y(t)}` — never parentheses for inline/horizontal component vectors. For vertical (column) vectors, use `\begin{bmatrix}...\end{bmatrix}`.
- **Vector names**: use `\mathbf{v}` (lowercase bold), not `\vec{v}` (arrows).
- **Matrix names**: use `\mathbf{A}` (uppercase bold) — e.g. `\mathbf{A}`, `\mathbf{R}_i`.
- **Dot product**: use `\cdot` explicitly — e.g. `\mathbf{u} \cdot \mathbf{v}`.
- **Cross product**: use `\times` explicitly — e.g. `\mathbf{u} \times \mathbf{v}`.
- **Vector magnitudes**: use `\lVert...\rVert`, e.g. `\lVert\mathbf{a}\rVert` — not `\abs{...}` or `|...|`.
- **Definitions and theorems**: wrap formal definitions in `\begin{definition}{Name}{label}...\end{definition}` and named theorems in `\begin{theorem}{Name}{label}...\end{theorem}`. These are `newtcbtheorem` environments (red/blue boxes) with prefixes `def:` and `thm:` respectively. Always give a descriptive kebab-case label (e.g. `{lin-eq}`, `{fubini}`). Use judgement to identify statements that are definitions or theorems by their mathematical content. Cross-reference with `\ref{def:label}` or `\ref{thm:label}` when later text refers back to a named definition or theorem.
