# Pablo IB — Blog Personal Hugo

Blog estático sobre tecnología, IA y productividad. Deploy en pabloib.com.

## Stack

- Hugo v0.159.2 extended (npx, no global), Tailwind CSS v3.4 build local, tema Paper (submodule)
- Node.js 18, Cloudflare Pages, dominio pabloib.com

## Comandos

```
npm run dev     # Tailwind watch + Hugo server :1315
npm run build   # Tailwind minify + Hugo minify → public/
npm run clean   # rm -rf public resources static/css/output.css
```

Después de cambios en código (no docs): `npm run build` y verificar que compila sin errores.

## Estructura clave

- `content/posts/*.md` — Artículos. Front matter obligatorio: title, description, date, categories, tags, readingTime
- `layouts/` — Templates Hugo. Overrides del tema Paper (NO editar themes/paper/)
- `layouts/partials/` — head.html (SEO/meta), jsonld.html (Schema.org), og-image.html (OG dinámicas)
- `static/css/output.css` — Tailwind compilado (generado, no editar)
- `assets/css/input.css` — Tailwind input
- `hugo.toml` — Config Hugo (taxonomías, menú, markup, outputs)
- `wrangler.toml` — NO existe. Pages no necesita config files
- `tailwind.config.js` — Design system

## Patrones

**Nuevos posts** — Crear en `content/posts/YYYY-MM-DD-slug.md`:
```yaml
---
title: "Título del artículo"
description: "Descripción SEO de máximo 160 caracteres para Google snippets"
date: 2026-04-13
categories: ["Pi"]
tags: ["pi", "tutorial"]
readingTime: 8
draft: false
---
```

**Layouts** — Todos heredan baseof.html con blocks `head` y `main`. SEO se gestiona en partials:
- `head.html` → meta tags, OG, Twitter cards (usa description del front matter)
- `jsonld.html` → Article + BreadcrumbList por página
- `og-image.html` → SVG dinámico con título del post via `resources.FromString`

**CSS** — `assets/css/input.css` → Tailwind CLI → `static/css/output.css` → Hugo copia a `public/css/`

**JavaScript** — Solo client-side. Archivos externos en `static/js/`. Nunca inline scripts (CSP).

**Dark mode** — Clase `.dark` en `<html>`, init en `theme-init.js`, toggle en `main.js`

## Convenciones

- **Commits:** Conventional Commits. Ejemplo: `feat(seo): add JSON-LD for articles`
- **Versión:** Semantic Versioning en `package.json`
- **Changelog:** Keep a Changelog en `CHANGELOG.md`
- **Idioma:** Contenido en español (es-es)

## Seguridad (defense-in-depth)

- Goldmark `unsafe = false` — No HTML crudo en markdown
- CSP estricto — No inline scripts, solo `self` + cdn.jsdelivr.net
- SRI para recursos externos
- HSTS preload, X-Frame-Options DENY, headers completos en `static/_headers`

## Restricciones

- Tailwind output va a `static/css/output.css`, NO a `assets/css/` — Hugo no sirve assets como static
- No usar `[site]` ni `[assets]` en wrangler.toml — Pages no usa wrangler. Si se necesita Workers, usar `[assets]` nunca `[site]`
- No crear CNAME DNS manual a `.workers.dev` o `.pages.dev` — da error 1014 cross-user banned. Usar Pages → Custom domains
- `_redirects` solo acepta códigos: 200, 301, 302, 303, 307, 308
- No instalar paquetes sin añadir a devDependencies
- No editar `themes/paper/` — es submodule, overrides en `layouts/`
- No inline scripts en templates — CSP los bloquea, usar archivos .js externos
- No olvidar `description` en front matter — obligatorio para meta tags, OG, Schema.org
- No usar Tailwind CDN — build local con purge (~28KB vs ~200KB)
- No usar `git add -A` ni `git add .` — solo `git add <archivos-específicos>`
