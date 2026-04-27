# Pablo IB — Blog Personal Hugo

Blog estático sobre tecnología, IA y productividad. Deploy en pabloib.com vía Cloudflare Pages.

## Stack

- Hugo v0.159.2 extended (vía npx, no binario global), Tailwind CSS v3.4 build local, tema Paper (submodule)
- Node.js 18, Cloudflare Pages, dominio pabloib.com
- 15 artículos publicados, v2.5.0

## Comandos

```
npm run dev     # Tailwind watch + Hugo server :1315
npm run build   # Tailwind minify + Hugo minify → public/
npm run clean   # rm -rf public resources static/css/output.css
```

Después de cambios en código (no docs): `npm run build` → verificar sin errores → `git push` → verificar deploy en Cloudflare Pages.

## Estructura clave

- `content/posts/*.md` — Artículos. Front matter obligatorio: title, description, date, lastmod, categories, tags, readingTime, mode, image, aliases
- `content/about.md` — Página About (contiene HTML, ojo con Goldmark unsafe=false)
- `layouts/` — Templates Hugo. Overrides del tema Paper (NO editar themes/paper/)
- `layouts/partials/` — head.html (SEO/meta), jsonld.html (Schema.org), og-image.html (OG dinámicas)
- `static/css/output.css` — Tailwind compilado (generado por build, NO editar manualmente)
- `assets/css/input.css` — Tailwind input
- `hugo.toml` — Config Hugo (taxonomías, menú, markup unsafe=false, outputs HTML+RSS+JSON)
- `archetypes/posts.md` — Archetype para nuevos posts (campos y estructura editorial)
- `tailwind.config.js` — Design system (colores Material Design, tipografías, plugins)
- `static/_headers` — Security headers para Cloudflare
- `static/js/main.js` — Búsqueda Fuse.js, filtros, dark mode, prefetch
- `static/js/theme-init.js` — Dark mode init (externo para CSP compliance)

## Patrones

**Nuevos posts** — Crear en `content/posts/YYYY-MM-DD-slug.md`:

```yaml
---
title: "Título del artículo"
description: "Descripción SEO de máximo 160 caracteres para Google snippets"
date: 2026-04-13
lastmod: 2026-04-13
categories: ["Pi"]
tags: ["pi", "tutorial"]
readingTime: 8
mode: guide
image: ""
aliases: []
draft: false
---
```

Modos disponibles: `tutorial`, `guide`, `opinion`, `review`

**Layouts** — Todos heredan baseof.html con blocks `head` y `main`. SEO en partials:

- `head.html` → meta tags, OG, Twitter cards (usa description del front matter)
- `jsonld.html` → Article + BreadcrumbList por página
- `og-image.html` → SVG dinámico con título del post via `resources.FromString`

**CSS** — `assets/css/input.css` → Tailwind CLI → `static/css/output.css` → Hugo copia a `public/css/`

**JavaScript** — Solo client-side. Archivos externos en `static/js/`.

**Checklist rápido para posts sobre Pi**:

- Verificar comandos, flags y rutas contra docs oficiales o código fuente de Pi
- No extrapolar reglas de `.pi/` a `AGENTS.md`/`CLAUDE.md`
- Usar placeholders neutros (`<tu-api-key>`) — nunca strings que parezcan secrets reales
- Si se edita un post existente: revisar front matter, links internos y actualizar `lastmod`

## Convenciones

### Rutas absolutas siempre

Usar **siempre rutas absolutas** en archivos, comandos, y comunicación. Nunca rutas relativas (`../`, `./`). Esto evita errores del agente al escribir archivos y confusión del usuario al leer.

- **Commits:** Conventional Commits. Ejemplo: `feat(seo): add JSON-LD for articles`
- **Versión:** Semantic Versioning en `package.json`
- **Changelog:** Keep a Changelog en `CHANGELOG.md`
- **Idioma:** Contenido en español (es-es)

## Deployment (Cloudflare Pages)

- **Plataforma:** Cloudflare Pages (NO Workers)
- **Build command:** `npm run build` (Tailwind + Hugo v0.159.2 via npx)
- **Output:** `public/`
- **Auto-deploy:** en cada push a `master`
- **Custom domain:** `pabloib.com` via Pages → Custom domains
- **Sin config files** — Pages no necesita wrangler.toml ni ningún archivo de config

## Seguridad (defense-in-depth)

- Goldmark `unsafe = false` — No HTML crudo en markdown
- CSP estricto — No inline scripts, solo `self` + cdn.jsdelivr.net
- SRI para recursos externos
- HSTS preload, X-Frame-Options DENY, headers completos en `static/_headers`

## Integraciones pendientes

### Consolto Video Chat (v2.6 — en exploración)

- Widget de video chat / live chat para todo el sitio
- Widget ID: `65e937c3dcea669377311401`, Agent ID: `65ecb711dcea66937739bdf0`
- Requiere: relajar CSP (`script-src`, `connect-src`, `frame-src` para `*.consolto.com`), habilitar `camera=(self)`, `microphone=(self)`
- Primera implementación: script loader externalizado en `/static/js/consolto.js`, deployado y verificado en producción, luego revertido
- Siguiente paso: evaluar enfoques alternativos de integración
- Referencia: tag `consolto-deployed` en git history con la implementación que funcionó

## Wiki (LLM Wiki — patrón Karpathy)

Base de conocimiento privada que Pi mantiene incrementalmente. Las notas maduras se promueven a posts del blog.

- `wiki/` — NO es contenido Hugo, no se publica. Es el "taller" privado del blog.
- `wiki/conventions.md` — Reglas completas de la wiki (front matter, workflows, estados)
- **4 workflows**: ingest (procesar fuentes), query (responder desde wiki), lint (health check), promote (nota → post)
- **Estados**: `seedling` → `budding` → `mature` → `post`
- `wiki/index.md` — Catálogo de todas las notas (actualizar en cada ingest)
- `wiki/log.md` — Log cronológico append-only
- `wiki/topics/` — Páginas de síntesis por tema (las que maduran → posts)
- `wiki/sources/` — Resúmenes de fuentes (artículos, papers, videos)
- `wiki/concepts/` — Definiciones breves de conceptos
- Al promover un topic a post: usar skill `pabloib-writer`, crear en `content/posts/`, actualizar status a `post`

## Restricciones

- Tailwind output va a `static/css/output.css`, NO a `assets/css/` — Hugo no sirve assets como static files
- No crear CNAME DNS manual a `.workers.dev` o `.pages.dev` — da error 1014 cross-user banned. Usar Pages → Custom domains
- `_redirects` solo acepta códigos: 200, 301, 302, 303, 307, 308
- No instalar paquetes sin añadir a devDependencies
- No editar `themes/paper/` — es submodule, overrides en `layouts/`
- No inline scripts en templates — CSP los bloquea, usar archivos .js externos
- No olvidar `description` en front matter de nuevos posts — obligatorio para meta tags, OG, Schema.org
- No usar Tailwind CDN — build local con purge (~28KB vs ~200KB)
