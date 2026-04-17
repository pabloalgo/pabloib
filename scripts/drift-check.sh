#!/bin/bash
# drift-check.sh v2.5 — Detect drift between docs and reality
# Usage: bash scripts/drift-check.sh [project_root]
# Returns exit 0 if no drift, exit 1 if drift detected

set -uo pipefail

ROOT="${1:-.}"
DRIFT=0

echo "=== DRIFT CHECK v2.5 ==="
echo ""

# --- Versioning ---

# 1. package.json version vs CHANGELOG latest
PKG_VER=$(cd "$ROOT" && grep -oP '"version":\s*"\K[0-9.]+' package.json 2>/dev/null || echo 'none')
CHANGELOG_VER=$(cd "$ROOT" && grep -oP '\[\K[0-9.]+(?=\])' CHANGELOG.md 2>/dev/null | head -1 || echo 'none')
if [ "$PKG_VER" != "$CHANGELOG_VER" ]; then
  echo "❌ Version drift: package.json=$PKG_VER CHANGELOG=$CHANGELOG_VER"
  DRIFT=1
else
  echo "✅ Version aligned: $PKG_VER"
fi

# --- Content counts ---

# 2. Post count
POST_COUNT=$(cd "$ROOT" && find content/posts/ -name '*.md' ! -name '_index.md' 2>/dev/null | wc -l | tr -d ' ')
echo "✅ Posts: $POST_COUNT"

# 3. Prompt count
PROMPT_COUNT=$(cd "$ROOT" && find content/prompts/ -name '*.md' ! -name '_index.md' 2>/dev/null | wc -l | tr -d ' ')
if [ "$PROMPT_COUNT" -eq 0 ]; then
  echo "❌ No prompts found in content/prompts/"
  DRIFT=1
else
  echo "✅ Prompts: $PROMPT_COUNT"
fi

# --- Build integrity ---

# 4. Tailwind output.css exists and is non-empty (correct path: static/css/)
CSS_SIZE=$(cd "$ROOT" && stat --printf='%s' static/css/output.css 2>/dev/null || echo '0')
if [ "$CSS_SIZE" -lt 100 ]; then
  echo "❌ static/css/output.css missing or too small (${CSS_SIZE} bytes) — run npm run build"
  DRIFT=1
else
  CSS_KB=$((CSS_SIZE / 1024))
  echo "✅ output.css: ${CSS_KB}KB"
fi

# 5. Build passes (dry run)
echo -n "   Build check: "
BUILD_OUTPUT=$(cd "$ROOT" && npm run build 2>&1)
BUILD_EXIT=$?
if [ $BUILD_EXIT -ne 0 ]; then
  echo "❌ npm run build failed"
  echo "$BUILD_OUTPUT" | tail -5
  DRIFT=1
else
  PAGE_COUNT=$(echo "$BUILD_OUTPUT" | grep -oP '\d+(?=\s+Pages)' | head -1 || echo '?')
  echo "✅ Build OK ($PAGE_COUNT pages)"
fi

# --- Security ---

# 6. Tailwind CDN check (should not exist)
if cd "$ROOT" && grep -q 'cdn.tailwindcss.com' layouts/partials/head.html 2>/dev/null; then
  echo "❌ Tailwind CDN still in head.html"
  DRIFT=1
else
  echo "✅ No Tailwind CDN"
fi

# 7. goldmark unsafe should be false
UNSAFE=$(cd "$ROOT" && grep -A5 'goldmark' hugo.toml 2>/dev/null | grep 'unsafe' | grep -oP '(true|false)' || echo 'not-set')
if [ "$UNSAFE" = "true" ]; then
  echo "❌ goldmark unsafe=true (security risk)"
  DRIFT=1
else
  echo "✅ goldmark unsafe=$UNSAFE"
fi

# 8. _headers exists
if cd "$ROOT" && test -f static/_headers; then
  echo "✅ _headers present"
else
  echo "❌ _headers missing"
  DRIFT=1
fi

# 9. No inline scripts in layouts (CSP compliance)
INLINE_SCRIPTS=$(cd "$ROOT" && grep -rn '<script>' layouts/ 2>/dev/null | grep -v 'application/ld+json' | grep -v 'src=' || true)
if [ -n "$INLINE_SCRIPTS" ]; then
  echo "❌ Inline scripts found (CSP violation):"
  echo "$INLINE_SCRIPTS"
  DRIFT=1
else
  echo "✅ No inline scripts in layouts"
fi

# --- Theme integrity ---

# 10. themes/paper/ should not have local modifications
if cd "$ROOT" && test -d themes/paper/.git; then
  PAPER_CHANGES=$(cd "$ROOT/themes/paper" && git diff --stat HEAD 2>/dev/null || true)
  if [ -n "$PAPER_CHANGES" ]; then
    echo "❌ themes/paper/ has local modifications — overrides go in layouts/"
    DRIFT=1
  else
    echo "✅ themes/paper/ clean"
  fi
fi

# --- Git submodules ---

# 11. Git submodule status
if cd "$ROOT" && test -f .gitmodules; then
  SUBMODULES=$(cd "$ROOT" && git submodule status 2>/dev/null | grep -c '^-' | tr -d '[:space:]' || echo '0')
  if [ "$SUBMODULES" -gt 0 ]; then
    echo "❌ $SUBMODULES git submodule(s) not initialized"
    DRIFT=1
  else
    echo "✅ Git submodules OK"
  fi
fi

# --- Dependencies ---

# 12. npm vulnerabilities
VULNS=$(cd "$ROOT" && npm audit 2>/dev/null | grep -oP '\d+(?= vulnerability)' | head -1 || echo '0')
if [ "${VULNS:-0}" -gt 0 ]; then
  echo "⚠️  npm vulnerabilities: $VULNS"
else
  echo "✅ No npm vulnerabilities"
fi

# --- Prompts section (v2.5) ---

echo ""
echo "--- Prompts section ---"

# 13. /prompts/ section exists in hugo menu
if cd "$ROOT" && grep -q "identifier = 'prompts'" hugo.toml 2>/dev/null; then
  echo "✅ Prompts in main menu"
else
  echo "❌ Prompts missing from hugo.toml menu"
  DRIFT=1
fi

# 14. Prompts section generated in public/
if cd "$ROOT" && test -d public/prompts/ 2>/dev/null; then
  PROMPT_PAGES=$(find "$ROOT/public/prompts/" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')
  echo "✅ /prompts/ generated ($PROMPT_PAGES prompt pages)"
else
  echo "⚠️  public/prompts/ not found — run npm run build first"
fi

# 15. prompts.js exists and is non-empty
PROMPTS_JS_SIZE=$(cd "$ROOT" && stat --printf='%s' static/js/prompts.js 2>/dev/null || echo '0')
if [ "$PROMPTS_JS_SIZE" -lt 10 ]; then
  echo "❌ static/js/prompts.js missing or empty"
  DRIFT=1
else
  echo "✅ prompts.js present (${PROMPTS_JS_SIZE} bytes)"
fi

# 16. prompts.js uses data-copy-target (not fragile selectors)
if cd "$ROOT" && grep -q 'data-copy-target' static/js/prompts.js 2>/dev/null; then
  echo "✅ prompts.js uses data-copy-target selectors"
else
  echo "❌ prompts.js missing data-copy-target selector"
  DRIFT=1
fi

# 17. Prompt templates exist (layouts/prompts/)
if cd "$ROOT" && test -f layouts/prompts/list.html && test -f layouts/prompts/single.html; then
  echo "✅ layouts/prompts/ templates present"
else
  echo "❌ Missing layouts/prompts/list.html or single.html"
  DRIFT=1
fi

# 18. Archetype for prompts exists
if cd "$ROOT" && test -f archetypes/prompts.md; then
  echo "✅ archetypes/prompts.md present"
else
  echo "❌ archetypes/prompts.md missing"
  DRIFT=1
fi

# 19. All published prompts have 'prompt:' in front matter
MISSING_PROMPT=$(cd "$ROOT" && for f in content/prompts/*.md; do
  [ "$(basename "$f")" = "_index.md" ] && continue
  grep -q '^prompt:' "$f" || echo "$f"
done | head -5)
if [ -n "$MISSING_PROMPT" ]; then
  echo "❌ Prompts missing 'prompt:' field in front matter:"
  echo "$MISSING_PROMPT"
  DRIFT=1
else
  echo "✅ All prompts have 'prompt:' in front matter"
fi

# 20. Reusable partials exist
PARTIALS_OK=true
for p in prompt-metadata.html tags-footer.html related-section.html; do
  if ! cd "$ROOT" && test -f "layouts/partials/$p"; then
    PARTIALS_OK=false
  fi
done
if $PARTIALS_OK; then
  echo "✅ Reusable partials present"
else
  echo "⚠️  Some reusable partials missing (prompt-metadata, tags-footer, related-section)"
fi

# --- Summary ---

echo ""
if [ $DRIFT -eq 0 ]; then
  echo "✅ No drift detected"
  exit 0
else
  echo "❌ Drift detected — fix before committing"
  exit 1
fi
