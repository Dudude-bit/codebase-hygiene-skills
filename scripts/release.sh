#!/usr/bin/env bash
#
# Release a new version of the codebase-hygiene plugin.
#
#   ./scripts/release.sh <version>      e.g.  ./scripts/release.sh 1.1.0
#
# It bumps the version in both manifests, validates, commits, pushes, and
# creates the matching GitHub release (notes pulled from CHANGELOG.md).
#
# Prereqs (do this first):
#   1. Add a "## X.Y.Z" section to CHANGELOG.md describing the release.
#   2. Commit & push it (the script requires a clean, in-sync main).
#
set -euo pipefail

VERSION="${1:-}"
[ -n "$VERSION" ] || { echo "usage: $0 <version>   (e.g. 1.1.0)"; exit 1; }
VERSION="${VERSION#v}"          # accept either 1.1.0 or v1.1.0
TAG="v$VERSION"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

echo "$VERSION" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' \
  || { echo "ERROR: '$VERSION' is not semver X.Y.Z"; exit 1; }

# --- preflight ---------------------------------------------------------------
[ -z "$(git status --porcelain)" ] \
  || { echo "ERROR: working tree not clean — commit or stash first"; exit 1; }
[ "$(git rev-parse --abbrev-ref HEAD)" = "main" ] \
  || { echo "ERROR: not on main"; exit 1; }
git fetch -q --tags origin main
[ "$(git rev-parse HEAD)" = "$(git rev-parse origin/main)" ] \
  || { echo "ERROR: local main is not in sync with origin/main"; exit 1; }
! git rev-parse -q --verify "refs/tags/$TAG" >/dev/null \
  || { echo "ERROR: tag $TAG already exists"; exit 1; }
grep -q "^## ${VERSION}\$" CHANGELOG.md \
  || { echo "ERROR: add a '## ${VERSION}' section to CHANGELOG.md (and commit it) first"; exit 1; }

# --- bump versions in both manifests ----------------------------------------
tmp=$(mktemp); jq --arg v "$VERSION" '.version=$v'            .claude-plugin/plugin.json      >"$tmp" && mv "$tmp" .claude-plugin/plugin.json
tmp=$(mktemp); jq --arg v "$VERSION" '.plugins[0].version=$v' .claude-plugin/marketplace.json >"$tmp" && mv "$tmp" .claude-plugin/marketplace.json

# --- validate ---------------------------------------------------------------
jq empty .claude-plugin/plugin.json .claude-plugin/marketplace.json
command -v claude >/dev/null 2>&1 && claude plugin validate . || echo "(claude CLI not found — skipped plugin validate)"

# --- release notes = the CHANGELOG section for this version ------------------
NOTES="$(awk -v v="## ${VERSION}" '$0==v{f=1;next} /^## /{f=0} f' CHANGELOG.md)"
[ -n "$(echo "$NOTES" | tr -d '[:space:]')" ] || { echo "ERROR: CHANGELOG section for ${VERSION} is empty"; exit 1; }

# --- commit, push, release --------------------------------------------------
git add .claude-plugin/plugin.json .claude-plugin/marketplace.json
git commit -q -m "Release ${TAG}"
git push -q origin main
printf '%s\n' "$NOTES" | gh release create "$TAG" --title "$TAG" --notes-file -

echo "✅ Released ${TAG} → $(gh release view "$TAG" --json url --jq .url)"
