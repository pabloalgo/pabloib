#!/bin/bash
# drift-check.sh — Detect drift between docs and reality
# Usage: bash scripts/drift-check.sh [project_root]
# Returns exit 0 if no drift, exit 1 if drift detected

set -uo pipefail

ROOT="${1:-.}"
DRIFT=0

echo "=== DRIFT CHECK ==="

# 1. package.json version vs CHANGELOG latest
PKG_VER=$(cd "$ROOT" && grep -oP '"version":\s*"\K[0-9.]+' package.json 2>/dev/null || echo 'none')
CHANGELOG_VER=$(cd "$ROOT" && grep -oP '\[\K[0-9.]+(?=\])' CHANGELOG.md 2>/dev/null | head -1 || echo 'none')
if [ "$PKG_VER" != "$CHANGELOG_VER" ]; then
  echo "❌ Version drift: package.json=$PKG_VER CHANGELOG=$CHANGELOG_VER"
  DRIFT=1
else
  echo "✅ Version aligned: $PKG_VER"
fi

# 2. README post count vs actual
README_COUNT=$(cd "$ROOT" && grep -oP '\d+(?= artículos)' README.md 2>/dev/null | head -1 || echo '0')
ACTUAL_COUNT=$(cd "$ROOT" && find content/posts/ -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
if [ "$README_COUNT" != "$ACTUAL_COUNT" ]; then
  echo "❌ Post count drift: README=$README_COUNT actual=$ACTUAL_COUNT"
  DRIFT=1
else
  echo "✅ Post count: $ACTUAL_COUNT"
fi

# 3. Tailwind CDN check (should not exist)
if cd "$ROOT" && grep -q 'cdn.tailwindcss.com' layouts/partials/head.html 2>/dev/null; then
  echo "❌ Tailwind CDN still in head.html"
  DRIFT=1
else
  echo "✅ No Tailwind CDN"
fi

# 4. output.css exists and is non-empty
CSS_SIZE=$(cd "$ROOT" && stat --printf='%s' assets/css/output.css 2>/dev/null || echo '0')
if [ "$CSS_SIZE" -lt 100 ]; then
  echo "❌ output.css missing or too small (${CSS_SIZE} bytes)"
  DRIFT=1
else
  CSS_KB=$((CSS_SIZE / 1024))
  echo "✅ output.css: ${CSS_KB}KB"
fi

# 5. goldmark unsafe should be false
UNSAFE=$(cd "$ROOT" && grep -A5 'goldmark' hugo.toml 2>/dev/null | grep 'unsafe' | grep -oP '(true|false)' || echo 'not-set')
if [ "$UNSAFE" = "true" ]; then
  echo "❌ goldmark unsafe=true (security risk)"
  DRIFT=1
else
  echo "✅ goldmark unsafe=$UNSAFE"
fi

# 6. _headers exists
if cd "$ROOT" && test -f static/_headers; then
  echo "✅ _headers present"
else
  echo "❌ _headers missing"
  DRIFT=1
fi

# 7. SRI on external scripts
SRI_COUNT=$(cd "$ROOT" && { grep -c 'integrity=' static/js/main.js 2>/dev/null || true; } | tr -d '[:space:]')
EXT_SCRIPTS=$(cd "$ROOT" && { grep -c 'https://' static/js/main.js 2>/dev/null || true; } | tr -d '[:space:]')
echo "ℹ️  SRI hashes: $SRI_COUNT / External scripts: $EXT_SCRIPTS"

# 8. Git submodule status
if cd "$ROOT" && test -f .gitmodules; then
  SUBMODULES=$(cd "$ROOT" && git submodule status 2>/dev/null | grep -c '^-' | tr -d '[:space:]' || echo '0')
  if [ "$SUBMODULES" -gt 0 ]; then
    echo "❌ $SUBMODULES git submodule(s) not initialized"
    DRIFT=1
  else
    echo "✅ Git submodules OK"
  fi
fi

# 9. npm vulnerabilities
VULNS=$(cd "$ROOT" && npm audit 2>/dev/null | grep -oP '\d+(?= vulnerability)' | head -1 || echo '0')
if [ "${VULNS:-0}" -gt 0 ]; then
  echo "⚠️  npm vulnerabilities: $VULNS"
else
  echo "✅ No npm vulnerabilities"
fi

# 10. README says (CDN) when it should say (build local)
if cd "$ROOT" && grep -qi 'tailwind.*cdn' README.md 2>/dev/null; then
  echo "⚠️  README mentions Tailwind CDN — verify if still accurate"
fi

echo ""
if [ $DRIFT -eq 0 ]; then
  echo "✅ No drift detected"
  exit 0
else
  echo "❌ Drift detected — fix before committing"
  exit 1
fi
