# codebase-hygiene-skills

[![Release](https://img.shields.io/github/v/release/Dudude-bit/codebase-hygiene-skills?label=release&color=da7756)](https://github.com/Dudude-bit/codebase-hygiene-skills/releases)
[![License: MIT](https://img.shields.io/github/license/Dudude-bit/codebase-hygiene-skills?color=blue)](./LICENSE)
[![Claude Code plugin](https://img.shields.io/badge/Claude%20Code-plugin-da7756)](https://code.claude.com/docs/en/plugins)
[![Skills](https://img.shields.io/badge/skills-2-success)](#)

Two sibling [Agent Skills](https://agentskills.io) for keeping a codebase healthy — one **unifies**, one **removes**. Both are *judgment* skills: the dangerous part of refactoring isn't finding candidates (tools do that), it's deciding what to touch without coupling the wrong things or shipping a silent breakage.

| Skill | What it does | Core judgment |
|-------|--------------|---------------|
| [`unifying-projects`](./skills/unifying-projects) | Analyze a project and consolidate duplication / reuse | **"Do these change for the same reason?"** — identical code from different domains stays separate. *Duplication is cheaper than the wrong abstraction.* |
| [`cleaning-up-projects`](./skills/cleaning-up-projects) | Audit a whole project for accumulated cruft and remove it | **"Is it provably dead?"** — absence of a reference is not proof of death (dynamic dispatch, public API, docs, config, cross-boundary). |

Both follow the same spine: **survey the real files → classify → prioritized plan → user approval → apply (behavior-preserving) → verify by execution.** They cross-reference each other; `cleaning-up-projects` removes, `unifying-projects` merges.

## Install

### Claude Code plugin (recommended)

This repo is also a Claude Code plugin marketplace. Add it once, install the plugin:

```text
/plugin marketplace add Dudude-bit/codebase-hygiene-skills
/plugin install codebase-hygiene@codebase-hygiene-skills
```

The skills then load automatically by their `description` triggers, or invoke them explicitly (namespaced by the plugin):

```text
/codebase-hygiene:unifying-projects
/codebase-hygiene:cleaning-up-projects
```

### Manual (any skill-aware agent)

Each skill is a self-contained folder (`SKILL.md` + a report template) following the [agentskills.io](https://agentskills.io/specification) spec, so it also works standalone (Codex, Gemini CLI, etc.):

```bash
git clone https://github.com/Dudude-bit/codebase-hygiene-skills.git
cp -r codebase-hygiene-skills/skills/* ~/.claude/skills/
```

Then invoke with `/unifying-projects` / `/cleaning-up-projects`, or just describe the task ("приведи проект к переиспользованию", "почисти мёртвый код").

## How they were built

Both skills were authored with **test-driven development for documentation** (the [superpowers `writing-skills`](https://github.com/obra/superpowers) method): write pressure scenarios, watch subagents fail *without* the skill (RED), write the skill to close those exact failures (GREEN), then run adversarial agents to hunt rationalization loopholes and patch them (REFACTOR). Each skill went through a baseline round, a green/verify round, and multiple adversarial hardening rounds — the rationalization tables and red-flag lists are the captured output of agents trying to wriggle around the rules.

## Releasing

1. Add a `## X.Y.Z` section to [`CHANGELOG.md`](./CHANGELOG.md); commit & push it.
2. Run the release command — it bumps the version in both manifests, validates (`claude plugin validate`), commits, pushes, and cuts the GitHub release (notes taken from that CHANGELOG section):

```bash
./scripts/release.sh X.Y.Z
```

It refuses to run on a dirty/out-of-sync tree, an existing tag, or a missing CHANGELOG section — so a release always has a matching tag, bumped manifests, and notes.

## License

MIT — see [LICENSE](./LICENSE).
