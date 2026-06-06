# Changelog

## 1.0.0

Initial release. Two skills, authored via test-driven development with adversarial loophole-hardening rounds:

- **unifying-projects** — consolidate duplication by the "do these change for the same reason?" judgment; leaves coincidental look-alikes separate.
- **cleaning-up-projects** — remove cruft only when provably dead across five reachability paths (dynamic, public-API, docs, config, cross-boundary); behavior-preserving, approval-gated.

Packaged as a Claude Code plugin marketplace (`codebase-hygiene` plugin).
