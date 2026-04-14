# 🚀 Pablo IB - Blog Personal

> Mi segunda memoria refinada. Blog sobre tecnología, IA y productividad.
>
> **Última actualización:** 2026-04-13

![Hugo](https://img.shields.io/badge/Hugo-v0.159.2-ff4081?logo=hugo&logoColor=white)
![TailwindCSS](https://img.shields.io/badge/TailwindCSS-v3.4%20(build%20local)-38bdf8?logo=tailwindcss&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Características

- 🎨 **Diseño Editorial** - Inspirado en revistas técnicas modernas
- 🌓 **Dark Mode** - Toggle con persistencia en localStorage
- 📱 **Mobile First** - Bottom navigation optimizada para móvil
- 🔎 **Búsqueda Client-Side** - Fuse.js para búsqueda instantánea
- 🏷️ **Filtrado por Categorías** - Filtro interactivo sin recargar
- 📄 **Paginación** - Navegación entre páginas (10 posts/página)
- 🔗 **Artículos Relacionados** - Basados en tags compartidos
- 📊 **Scroll Progress** - Barra de progreso de lectura
- ⬆️ **Back to Top** - Botón flotante para volver arriba
- 📋 **Copy Code Button** - Copiar código con un click
- ⚡ **PWA Ready** - Service Worker + manifest para instalación
- 🚀 **Prefetch Inteligente** - Precarga de páginas en hover
- 📈 **SEO Optimizado** - Meta descriptions, Open Graph, JSON-LD, sitemap, OG images dinámicas

## 🛠️ Stack Tecnológico

| Categoría | Tecnología |
|-----------|------------|
| **SSG** | Hugo v0.159.2 (extended, vía npm) |
| **CSS** | Tailwind CSS v3.4 (build local) |
| **Fuentes** | Plus Jakarta Sans, Inter, Space Grotesk |
| **Iconos** | Material SymbolsOutlined |
| **Hosting** | Cloudflare Pages |
| **Dominio** | pabloib.com (via Cloudflare Pages) |

## 📁 Estructura del Proyecto

```
pabloib/
├── content/
│   ├── posts/          # Artículos del blog
│   └── about.md        # Página About
├── layouts/
│   ├── _default/
│   │   ├── baseof.html      # Template base + navegación
│   │   ├── single.html      # Páginas individuales + relacionados
│   │   ├── list.html        # Listados (tags, categorías)
│   │   ├── about.html       # Página About personalizada
│   │   ├── index.json       # Índice de búsqueda JSON
│   │   └── sitemap.xml      # Sitemap custom con prioridades
│   ├── partials/
│   │   ├── head.html        # Head con Tailwind + SEO meta + PWA manifest
│   │   ├── jsonld.html      # Schema.org JSON-LD structured data
│   │   ├── og-image.html    # OG images dinámicas (SVG)
│   │   ├── pagination.html  # Sistema de paginación
│   │   └── related.html     # Artículos relacionados
│   └── index.html           # Homepage con paginación
├── assets/
│   └── css/
│       └── input.css        # Tailwind CSS input
├── static/
│   ├── css/
│   │   └── output.css       # Tailwind compilado (generado por build)
│   ├── js/
│   │   ├── main.js          # Búsqueda, filtros, scroll, prefetch
│   │   └── theme-init.js    # Dark mode init (CSP compliant)
│   ├── images/              # Imágenes estáticas (og-image.svg)
│   ├── favicon.ico          # Favicon del sitio
│   ├── apple-touch-icon.png # Icono para iOS (PWA)
│   ├── icon-192.svg         # Icono PWA 192px
│   ├── icon-512.svg         # Icono PWA 512px
│   ├── _headers             # Security headers (CSP, HSTS, etc.)
│   ├── _redirects           # Redirects Cloudflare Pages
│   ├── manifest.json        # PWA manifest
│   ├── robots.txt           # Robots para crawlers
│   └── sw.js                # Service Worker
├── themes/paper/       # Theme base (submodule, NO editar)
├── hugo.toml           # Configuración Hugo
├── package.json        # NPM config (Tailwind + Hugo build)
├── tailwind.config.js  # Tailwind design system
├── README.md           # Este archivo
├── CHANGELOG.md        # Historial de cambios
└── ROADMAP.md          # Plan de desarrollo
```

## 🚀 Desarrollo

```bash
# Clonar repositorio
git clone https://github.com/pabloalgo/pabloib.git
cd pabloib

# Inicializar submodules
git submodule update --init --recursive

# Iniciar servidor de desarrollo
npm run dev

# Build para producción
npm run build
```

### Requisitos

- Node.js y npm
- Git
- Hugo extended v0.159.2 se descarga automáticamente vía los scripts de npm; no requiere instalación global

## ☁️ Deployment (Cloudflare Pages)

El sitio se deploya automáticamente via Cloudflare Pages conectado al repo `pabloalgo/pabloib`.

**Configuración en Cloudflare Dashboard:**

| Parámetro | Valor |
|-----------|-------|
| Framework preset | None |
| Build command | `npm run build` |
| Build output directory | `public` |
| Root directory | `/` |
| NODE_VERSION | `18` |

**Custom domain:** `pabloib.com` configurado via Pages → Custom domains.

**Sin wrangler.toml** — Pages no necesita config files. Build directo con `npm run build`.

## 📝 Contenido

- Artículos sobre Pi, IA, desarrollo y productividad
- Categorías: Pi, Hugo, AI
- Tags: pi, agentes, productividad, typescript, skills, debugging, prompt-engineering, contexto, multi-agente, y más

## 🏷️ Versiones

| Versión | Estado | Descripción |
|---------|--------|-------------|
| v2.0 | ✅ Completado | Rediseño "Architectural Editor" + Tailwind |
| v2.1 | ✅ Completado | Búsqueda, filtros, copy code, about page |
| v2.2 | ✅ Completado | Paginación, relacionados, scroll progress, back to top |
| v2.3 | ✅ Completado | PWA, Service Worker, prefetch, Tailwind build local |
| v2.4 | ✅ Completado | Security hardening: HSTS, CSP, SRI, unsafe=false |
| v2.5 | ✅ Completado | SEO + migración a Cloudflare Pages + fix CSS 404 |
| v2.6 | 📋 Planificado | Comentarios, newsletter |
| v3.0 | 💭 Visión | Nuevas secciones: proyectos, /now, /uses |

Ver [ROADMAP.md](./ROADMAP.md) para detalles completos.

## 📜 Changelog

Ver [CHANGELOG.md](./CHANGELOG.md) para el historial de cambios.

## 📄 Licencia

MIT © Pablo IB

---

*Hecho con ❤️ y [Hugo](https://gohugo.io) — *Última actualización: 2026-04-13*
