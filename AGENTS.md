# Pablo IB — Blog Personal

Blog estático sobre tecnología, IA y productividad. Mi segunda memoria refinada.

## Stack

- **SSG:** Hugo v0.159.2 extended (vía npx, sin binario global)
- **CSS:** Tailwind CSS v3.4 build local (CLI, no PostCSS, no CDN)
- **Plugins Tailwind:** @tailwindcss/forms, @tailwindcss/container-queries
- **Tema:** Paper (Git submodule en themes/paper)
- **Fuentes:** Plus Jakarta Sans (headlines), Inter (body), Space Grotesk (labels/code)
- **Iconos:** Material Symbols Outlined
- **Búsqueda:** Fuse.js client-side con índice JSON autogenerado
- **Hosting:** Cloudflare Workers (static assets) en pabloib.com
- **Node.js:** 18

## Comandos

- `npm run dev` — Servidor de desarrollo (Tailwind watch + Hugo server puerto 1315)
- `npm run build` — Build producción (Tailwind minify + Hugo minify)
- `npm run clean` — Limpiar public/, resources/ y output.css

## Estructura

```
content/
  posts/          — Artículos del blog (15 posts, front matter con title, description, date, categories, tags, readingTime)
  about.md        — Página About (HTML en markdown, requiere markup.goldmark.renderer.unsafe=true para editar)
layouts/
  _default/
    baseof.html       — Template base (header + nav + footer + JSON-LD)
    single.html       — Posts individuales + navegación + relacionados
    list.html         — Listados (tags, categorías)
    index.json        — Índice de búsqueda JSON para Fuse.js
    sitemap.xml       — Sitemap custom con prioridades por tipo de página
  partials/
    head.html         — Head HTML + SEO meta + OG tags + OG images dinámicas
    jsonld.html       — Schema.org JSON-LD (Article, BreadcrumbList, Person, WebSite)
    og-image.html     — Genera SVG dinámico por post via resources.FromString
    pagination.html   — Sistema de paginación
    related.html      — Artículos relacionados basados en tags
  index.html         — Homepage con featured post + feed + paginación
assets/
  css/
    input.css         — Tailwind CSS input (NO output — output va a static/)
static/
  css/
    output.css        — Tailwind CSS compilado ( generado por build, NO editar manualmente)
  js/
    main.js           — Búsqueda Fuse.js, filtros, scroll progress, back to top, prefetch
    theme-init.js     — Dark mode init (script externo para CSP compliance)
  images/
    og-image.svg      — OG image default para homepage
  _headers            — Security headers para Cloudflare
  _redirects          — Redirects para Cloudflare
  manifest.json       — PWA manifest
  sw.js               — Service Worker
hugo.toml             — Configuración Hugo
wrangler.toml         — Configuración Cloudflare Workers
package.json          — Build pipeline y versión
tailwind.config.js    — Design system (colores Material Design, tipografías, plugins)
```

## Patrones

- **Layouts:** Todos usan baseof.html con blocks `head` y `main`
- **CSS:** Tailwind build local → `static/css/output.css`. Hugo lo copia a `public/css/`
- **SEO:** Cada post DEBE tener `description` en front matter. Se usa en meta tags, OG, Schema.org
- **OG Images:** Se generan automáticamente via partial `og-image.html` usando `resources.FromString`. SVG con título del post + branding
- **JSON-LD:** Se inyecta en baseof.html via partial `jsonld.html`. Genera Article + BreadcrumbList por defecto
- **Sitemap:** Template custom con prioridades: homepage=1.0, posts=0.8, tags=0.4, about=0.6
- **JavaScript:** Toda interactividad es client-side. No dependencias server-side
- **Dark mode:** Clase `.dark` en `<html>`, toggle con localStorage, init en theme-init.js externo

## Convenciones

- **Commits:** Conventional Commits en español. Formato: `tipo(ámbito): descripción`
  - Tipos: feat, fix, refactor, docs, chore, style, test
  - Ejemplo: `feat(seo): add JSON-LD structured data for articles`
- **Versionado:** Semantic Versioning en package.json
- **Changelog:** Keep a Changelog v1.1.0 en CHANGELOG.md
- **Front matter posts:** Campos obligatorios: title, description, date, categories, tags, readingTime, draft
- **Idioma:** Contenido en español (es-es)

## Seguridad

- **CSP estricto:** default-src 'self'; script-src 'self' cdn.jsdelivr.net; style-src 'self' 'unsafe-inline' fonts.googleapis.com
- **Goldmark:** `unsafe = false` — NO se puede usar HTML crudo en markdown (excepto about.md que usa shortcodes)
- **HSTS:** max-age=31536000; includeSubDomains; preload
- **SRI:** Para recursos externos (Fuse.js con hash sha384)
- **Headers:** X-Frame-Options DENY, X-Content-Type-Options nosniff, Referrer-Policy, Permissions-Policy
- **Scripts externos:** Todos los scripts inline se movieron a archivos .js externos para cumplir CSP

## Deployment

- **Plataforma:** Cloudflare Workers con static assets
- **Repo:** pabloalgo/pabloib → auto-deploy en push a master
- **Build command:** `npm run build`
- **Deploy command:** `npx wrangler deploy` (automático via Cloudflare Dashboard)
- **Output:** `public/`
- **Custom domain:** `pabloib.com` via wrangler.toml routes con `custom_domain = true`

## Lo que NO debes hacer

- **NO** poner Tailwind output en `assets/css/` — va a `static/css/output.css`. Hugo no sirve assets como static files
- **NO** usar `[site]` en wrangler.toml — usa `[assets]` para static sites. `[site]` activa modo Workers legacy
- **NO** crear CNAME DNS manual a `.workers.dev` o `.pages.dev` — da error 1014 cross-user banned. Usar `custom_domain = true` en routes
- **NO** usar código 404 en `_redirects` — Cloudflare solo acepta 200, 301, 302, 303, 307, 308
- **NO** instalar paquetes npm sin añadirlos a devDependencies en package.json
- **NO** modificar `themes/paper/` directamente — es Git submodule. Overrides van en `layouts/`
- **NO** usar HTML crudo en markdown (Goldmark unsafe=false). Para about.md, usar shortcodes o configuración temporal
- **NO** añadir inline scripts en templates — CSP los bloquea. Crear archivos .js externos
- **NO** olvidar `description` en front matter de nuevos posts — es obligatorio para SEO
- **NO** usar Tailwind CDN — build local con purge automático (~28KB vs ~200KB CDN)
