# Math Notes Agent

LaTeX notes for university math courses.

## Structure

```
preamble.tex                  # shared preamble (packages, environments, shortcuts)
<course-code>_<course-name>/
├── Makefile
├── main.tex              # master document (title, TOC, \section per chapter, \input sections)
└── sections/
    └── <chap>_<topic>.tex # one file per textbook chapter (all subsections together)
```

## Shared Preamble (`preamble.tex`)

All courses `\input{../preamble}` before `\begin{document}`. Read `preamble.tex` for available environments, shortcuts, and styling. Add new shared commands/environments here, not in individual course files.

## Conventions

- **One file per textbook chapter**: named `<chap>_<topic>.tex` (e.g. `10_parametric-curves.tex`). All subsections from that chapter go in the same file.
- **Heading hierarchy**: `main.tex` uses `\section` per textbook chapter. Section files use `\subsection` for topics and `\subsubsection` for sub-topics. This produces TOC entries like 1.1, 1.2, 1.2.1, etc.
- Keep LaTeX **minimal and clean** — no excessive comments or boilerplate.
- Use `amsmath`, `amssymb` for math; `pgfplots` with `tikzpicture` for graphs.
- Wrap examples in `\begin{example}...\end{example}` — they render as gray boxes.

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

## Handwriting Transcription

When given a photo of handwritten notes:

1. Read the section number and title if applicatable, and ask user to clarify blurry sketches if needed.
2. Transcribe math into clean LaTeX — use `\[ \]` for display math, `align` for multi-line.
3. **Draw graphs** using `pgfplots`/`tikzpicture` whenever the notes include a sketch — **do not skip graphs**; every sketch in the notes must appear in the output.
4. Mark endpoints on parametric/interval plots with `\addplot[only marks, mark=*]`.
5. Keep prose minimal — bullet points or short sentences, not paragraphs.
6. Place output in the appropriate `sections/` file and add `\input` to `main.tex` if new.
7. Run `make` to verify compilation.

## Building

After any LaTeX edit, run `make` in the affected course directory to rebuild the PDF and verify compilation.

## Adding a New Course

1. Create `<course-dir>/` with `main.tex`, `Makefile`, and `sections/`.
2. Copy the Makefile template from an existing course.
3. The pre-commit hook will automatically pick it up.
