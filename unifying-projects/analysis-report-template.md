# Unification & Reuse Analysis — <project>

> Fill this from the **real files on disk**. Every row must cite a real `path:line`.
> Present this and WAIT for approval before any structural change.

## 1. Survey evidence

- Files inspected: `<paths>` (from `ls` / `rg -n`)
- Search commands run **and their key output** — paste the actual hit lines / jscpd clone block / `ast-grep` match, not just the command. A command with no output shown is assumed not run.
- For each candidate below, a quoted 2–5 line excerpt of the **actual on-disk body** (not the prompt snippet). If you acted on a pasted snippet, show it matches disk.
- One-line state of the codebase: `<e.g. "already consolidated", "3 real duplication clusters">`

If the claimed duplication does not exist on disk, say so here and stop. "Nothing to extract" is a valid outcome.

## 2. Findings, classified

| # | Candidate (real `file:line`) | Dimension | Bucket | Same reason to change? | Proposed action |
|---|------------------------------|-----------|--------|------------------------|-----------------|

- **Dimension:** code-dup / abstraction / convention / deps-config-style
- **Bucket:** exact+same-concept · same-concept-different-values · coincidental (leave separate) · near-duplicate (test first)

### Left deliberately separate (coincidental)
- `<file:line>` — why these will diverge (different domains/reasons): `<...>`

## 3. Prioritized plan (value vs. risk)

| Order | Item (`file:line`) | Value | Risk / blast radius | Behavior to preserve | Verification |
|-------|--------------------|-------|---------------------|----------------------|--------------|

## 4. Blockers / open questions

- `<divergence or coupling concerns that must be resolved BEFORE the change>`

## 5. Out of scope (explicitly not doing)

- `<no formula rewrites, no env/DI/framework scope creep, no premature abstraction>`
