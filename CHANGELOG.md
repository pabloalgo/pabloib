# Changelog

Todos los cambios notables de este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

---

## [2.5.0] - 2026-04-13

### Added
- SEO descriptions in front matter for all 15 posts (improves Google snippets)
- Schema.org JSON-LD structured data: Article schema on posts, BreadcrumbList on all pages, Person schema on About, WebSite schema on homepage
- Custom sitemap template with smart priorities: homepage 1.0, posts 0.8, tags 0.4, about 0.6
- Dynamic OG images per post (SVG with article title + blog branding)

### Changed
- Migrated from Cloudflare Workers to **Cloudflare Pages** (correct platform for static sites)
- Removed `wrangler.toml` — Pages uses zero config files
- Tailwind CSS output moved from `assets/css/` to `static/css/` to fix 404 in production
- Build command: `npm run build` (Tailwind + Hugo v0.159.2 via npx)
- Custom domain `pabloib.com` configured via Pages dashboard
- Version bumped from 2.4.2 to 2.5.0
- AGENTS.md optimized from ~1200 to ~637 tokens (47% reduction)
- Installed 3 agent skills: ui-ux-pro-max, hugo-template-dev, seo-content-writer
- README updated with deployment documentation
- ROADMAP v2.5 marked as completed

### Fixed
- CSS 404 in production: Tailwind output was in `assets/` (not served by Hugo as static)
- `_redirects` file: removed invalid 404 status code
- Cloudflare deployment: removed `[site]` section from wrangler.toml that triggered Workers mode incorrectly

## [2.4.2] - 2026-04-06

### Fixed
- CSP compliance: moved 3 inline scripts from `baseof.html` to external JS files (`theme-init.js`, `main.js`), eliminating `unsafe-inline` requirement in `script-src`
- Related posts partial: fixed filter using `Type "page"` instead of `Section "posts"`, which could miss articles
- `drift-check.sh`: fixed false positive in post count regex (matched pagination text), fixed SRI count and submodule status parsing with whitespace trimming

### Changed
- `baseURL` updated from GitHub Pages URL to `https://pabloib.com/` for Cloudflare Pages deployment
- `.gitignore`: added `assets/css/output.css` (generated) and `.pi-lens/`

---


## [2.4.1] - 2026-04-06

### Changed
- El build y el preview del sitio ahora usan `hugo-extended` vía `npm run build` y `npm run dev`, evitando depender de un binario global de Hugo.
- CHANGELOG.md categorías migradas a formato Keep a Changelog v1.1.0 (texto plano, sin emojis)
- teamleader.md refactorizado: specs delegadas a skills, solo reglas específicas del proyecto
- Skills instaladas: changelog-automation, conventional-commit, context7-cli

---

## [2.4.0] - 2026-04-06

### Added
- Security headers — `_headers` para Cloudflare Pages con HSTS (1 año + preload), X-Frame-Options DENY, X-Content-Type-Options nosniff, Referrer-Policy, Permissions-Policy
- Content Security Policy — CSP endurecido: solo `self` + `cdn.jsdelivr.net` para Fuse.js con SRI
- SRI para Fuse.js — Hash sha384 de integridad en la carga dinámica del script de búsqueda
- SVG placeholders — og-image.svg (1200×630), icon-192.svg, icon-512.svg para PWA

### Changed
- `unsafe = false` en Goldmark renderer (elimina posibilidad de XSS en contenido markdown)
- `baseURL` configurado con URL real de producción
- Tailwind CDN eliminado completamente → build local vía `output.css`
- `postcss.config.js` eliminado (proyecto usa Tailwind CLI v3, no PostCSS v4)
- `tailwind.config.js`: plugins `@tailwindcss/forms` y `@tailwindcss/container-queries` agregados
- Google Fonts: `crossorigin="anonymous"` aplicado (SRI no aplicable a URLs dinámicas)
- `manifest.json`: referencias de iconos actualizadas a .svg

---

## [2.3.0] - 2026-03-26

### Added
- Service Worker / PWA — Cache offline y modo instalable
- Prefetch inteligente — Precarga de páginas en hover (solo desktop)
- Tailwind build local — Migración de CDN a build local de CSS
- Manifest.json — PWA manifest para instalación

### Changed
- `head.html` incluye manifest y theme-color dinámico
- `main.js` incluye prefetch en hover

---

## [2.2.0] - 2026-03-26

### Added
- Sistema de paginación — Navegación entre páginas de artículos (10 por página)
- Artículos relacionados — 3 posts relacionados basados en tags al final de cada artículo
- Scroll progress indicator — Barra de progreso de lectura en el header
- Back to top button — Botón flotante para volver arriba (aparece después de scroll)

### Changed
- `index.html` ahora usa `.Paginator` de Hugo
- `single.html` incluye artículos relacionados
- `baseof.html` incluye scroll progress y back to top
- `main.js` incluye scroll tracking y back to top
- `hugo.toml` configurado con `paginate = 10`

---

## [2.1.0] - 2026-03-26

### Added
- Búsqueda funcional — Fuse.js para búsqueda client-side de artículos
- Filtrado por categorías — Botones clickeables en el carrusel de categorías
- Copy code button — Botón para copiar bloques de código con feedback visual
- Lazy loading imágenes — Carga diferida de imágenes para mejor rendimiento
- Página About rediseñada — Layout completo con bio, stack, filosofía y stats
- JSON search index — `/index.json` para búsqueda de artículos

### Changed
- Añadido `loading="lazy"` a todas las imágenes
- Mejorado el script de dark mode
- Añadido `/js/main.js` con funcionalidades interactivas

---

## [2.0.0] - 2026-03-26

### Added
- Nuevo diseño "Architectural Editor" — Estilo editorial moderno inspirado en revistas técnicas
- Tailwind CSS v3.4 — Sistema de diseño via CDN con configuración personalizada
- Dark Mode completo — Toggle en header con persistencia en localStorage
- Material Symbols — Iconografía de Google Material Design
- Bottom Navigation — Navegación móvil optimizada (Feed, Archivos, Tags, About)
- Categorías visuales — Carrusel horizontal de categorías
- Artículo destacado — Primer post con estilo featured en homepage
- Efecto grayscale hover — Transición de B/N a color en imágenes

### Changed
- Layouts completamente reescritos
- `baseof.html` ahora incluye navegación fija
- `head.html` con configuración Tailwind inline
- Soporte completo para modo oscuro en todos los componentes

### Removed
- Glassmorphism anterior (reemplazado por diseño editorial limpio)
- Blobs animados de fondo (reemplazado por fondos sólidos)
- CSS custom anterior (~15KB → ahora con Tailwind)

---

## [1.2.0] - 2026-03-25

### Added
- Configuración de dominio personalizado: `pabloib.com`
- Adopción oficial de la especificación Conventional Commits
- Integración de reglas de `hugo-template-dev` para robustez de layouts
- Registro de estándares oficiales de Hugo en la configuración del agente

---

## [1.1.0] - 2026-03-25

### Added
- Rediseño moderno con SEO optimizado (Meta, OG, JSON-LD)
- Hero section personalizada en la Home
- Dark mode nativo con persistencia
- 7 artículos migrados de Obsidian

---

## [1.0.0] - 2026-03-25

### Added
- Proyecto inicializado
- Hugo + Paper theme (Git Submodule)
- Estructura base del blog

---

[2.5.0]: https://github.com/pabloalgo/pabloib/compare/v2.4.2...v2.5.0
[2.4.2]: https://github.com/pabloalgo/pabloib/compare/v2.4.1...v2.4.2
[2.4.1]: https://github.com/pabloalgo/pabloib/compare/v2.4.0...v2.4.1
[2.4.0]: https://github.com/pabloalgo/pabloib/compare/v2.3.0...v2.4.0
[2.3.0]: https://github.com/pabloalgo/pabloib/compare/v2.2.0...v2.3.0
[2.2.0]: https://github.com/pabloalgo/pabloib/compare/v2.1.0...v2.2.0
[2.1.0]: https://github.com/pabloalgo/pabloib/compare/v2.0.0...v2.1.0
[2.0.0]: https://github.com/pabloalgo/pabloib/compare/v1.2.0...v2.0.0
[1.2.0]: https://github.com/pabloalgo/pabloib/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/pabloalgo/pabloib/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/pabloalgo/pabloib/releases/tag/v1.0.0

---

*Última actualización: 2026-04-13*
