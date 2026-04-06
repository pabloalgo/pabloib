#!/bin/bash
# audit-stack.sh — Discover project stack, versions and state at runtime
# Usage: bash scripts/audit-stack.sh [project_root]
set -uo pipefail

ROOT="${1:-.}"

echo "=== STACK AUDIT ==="
echo "Root: $(cd "$ROOT" && pwd)"

# Hugo
HUGO_VER=$(cd "$ROOT" && grep -oP 'hugo-extended@\K[0-9.]+' package.json 2>/dev/null || echo 'not-found')
echo "Hugo: $HUGO_VER"

# Tailwind
TW_VER=$(cd "$ROOT" && node -e "console.log(require('./package.json').devDependencies.tailwindcss || 'none')" 2>/dev/null || echo 'not-found')
TW_LOCAL=$(cd "$ROOT" && test -f assets/css/output.css && echo 'build-local' || echo 'missing')
TW_CDN=$(cd "$ROOT" && grep -q 'cdn.tailwindcss.com' layouts/partials/head.html 2>/dev/null && echo 'CDN' || echo 'no-cdn')
echo "Tailwind: $TW_VER ($TW_LOCAL, $TW_CDN)"

# Version
PKG_VER=$(cd "$ROOT" && node -e "console.log(require('./package.json').version)" 2>/dev/null || echo 'not-found')
echo "package.json: $PKG_VER"

# Content
POST_COUNT=$(cd "$ROOT" && find content/posts/ -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
TEMPLATE_COUNT=$(cd "$ROOT" && find layouts/ -name '*.html' 2>/dev/null | wc -l | tr -d ' ')
echo "Posts: $POST_COUNT | Templates: $TEMPLATE_COUNT"

# CSS output
CSS_SIZE=$(cd "$ROOT" && wc -c < assets/css/output.css 2>/dev/null || echo '0')
echo "output.css: $((CSS_SIZE / 1024))KB"

# Security quick check
UNSAFE=$(cd "$ROOT" && grep -A5 'goldmark' hugo.toml 2>/dev/null | grep 'unsafe' | grep -oP '(true|false)' || echo 'not-set')
HEADERS=$(cd "$ROOT" && test -f static/_headers && echo 'yes' || echo 'no')
SRI=$(cd "$ROOT" && grep -c 'integrity=' static/js/main.js 2>/dev/null || echo '0')
echo "unsafe=$UNSAFE | _headers=$HEADERS | SRI hashes=$SRI"

# npm
VULNS=$(cd "$ROOT" && npm audit --prefix . 2>/dev/null | grep -oP '\d+(?= vulnerability)' | head -1 || echo '0')
echo "npm vulnerabilities: ${VULNS:-0}"

# BaseURL
BASEURL=$(cd "$ROOT" && grep 'baseURL' hugo.toml 2>/dev/null | head -1 | sed "s/.*=['\"]//;s/['\"].*//")
echo "baseURL: $BASEURL"

# Build scripts
echo ""
echo "=== BUILD SCRIPTS ==="
cd "$ROOT" && node -e "const p=require('./package.json'); Object.entries(p.scripts||{}).forEach(([k,v])=>console.log('  '+k+': '+v))" 2>/dev/null
