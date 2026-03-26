# 🚀 Pablo IB - Blog Personal

> Mi segunda memoria refinada. Blog sobre tecnología, IA y productividad.

![Hugo](https://img.shields.io/badge/Hugo-v0.145-ff4081?logo=hugo&logoColor=white)
![TailwindCSS](https://img.shields.io/badge/TailwindCSS-v3.4-38bdf8?logo=tailwindcss&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Características

- 🎨 **Diseño Editorial** - Inspirado en revistas técnicas modernas
- 🌓 **Dark Mode** - Toggle con persistencia en localStorage
- 📱 **Mobile First** - Bottom navigation optimizada para móvil
- 🔍 **Búsqueda Client-Side** - Fuse.js para búsqueda instantánea
- 🏷️ **Filtrado por Categorías** - Filtro interactivo sin recargar
- 📄 **Paginación** - Navegación entre páginas (10 posts/página)
- 🔗 **Artículos Relacionados** - Basados en tags compartidos
- 📊 **Scroll Progress** - Barra de progreso de lectura
- ⬆️ **Back to Top** - Botón flotante para volver arriba
- 📋 **Copy Code Button** - Copiar código con un click
- ⚡ **PWA Ready** - Service Worker + manifest para instalación
- 🚀 **Prefetch Inteligente** - Precarga de páginas en hover
- 🔍 **SEO Optimizado** - Meta tags, Open Graph, JSON-LD
- 📰 **RSS Feed** - Sindicación automática

## 🛠️ Stack Tecnológico

| Categoría | Tecnología |
|-----------|------------|
| **SSG** | Hugo v0.145 (extended) |
| **CSS** | Tailwind CSS v3.4 (CDN) |
| **Fuentes** | Plus Jakarta Sans, Inter, Space Grotesk |
| **Iconos** | Material SymbolsOutlined |
| **Hosting** | GitHub Pages / Cloudflare Pages |
| **Dominio** | pabloib.com |

## 📁 Estructura del Proyecto

```
pabloib/
├── content/
│   ├── posts/          # Artículos del blog (8 posts)
│   └── about.md        # Página About
├── layouts/
│   ├── _default/
│   │   ├── baseof.html      # Template base + navegación
│   │   ├── single.html      # Páginas individuales + relacionados
│   │   ├── list.html        # Listados (tags, categorías)
│   │   └── index.json       # Índice de búsqueda JSON
│   ├── partials/
│   │   ├── head.html        # Head con Tailwind + PWA manifest
│   │   ├── pagination.html  # Sistema de paginación
│   │   └── related.html     # Artículos relacionados
│   └── index.html           # Homepage con paginación
├── assets/
│   ├── css/
│   │   └── input.css        # Tailwind CSS input
│   └── images/              # Imágenes procesables (Hugo Pipes)
├── static/
│   ├── js/
│   │   └── main.js          # Búsqueda, filtros, scroll, prefetch
│   ├── manifest.json        # PWA manifest
│   ├── sw.js                # Service Worker
│   └── images/              # Imágenes estáticas (og-image, etc.)
├── themes/paper/       # Theme base (submodule)
├── hugo.toml           # Configuración Hugo
├── package.json        # NPM config (Tailwind build)
├── tailwind.config.js  # Tailwind configuration
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
hugo server --buildDrafts -D

# Build para producción
hugo --minify
```

### Requisitos

- Hugo v0.145+ (extended)
- Git

## 📝 Contenido

- **8 artículos** sobre Pi Agent, IA y productividad
- Categorías: Pi, Workflow, Desarrollo
- Tags: pi, workflow, productividad, typescript, agentes

## 🏷️ Versiones

| Versión | Estado | Descripción |
|---------|--------|-------------|
| v2.0 | ✅ Completado | Rediseño "Architectural Editor" + Tailwind |
| v2.1 | ✅ Completado | Búsqueda, filtros, copy code, about page |
| v2.2 | ✅ Completado | Paginación, relacionados, scroll progress, back to top |
| v2.5 | ✅ Completado | PWA, Service Worker, prefetch, Tailwind local |
| v2.3 | 📋 Planificado | SEO: OG images, Schema.org ampliado |
| v2.4 | 📋 Planificado | Comentarios, newsletter |
| v3.0 | 💭 Visión | Nuevas secciones: proyectos, /now |

Ver [ROADMAP.md](./ROADMAP.md) para detalles completos.

## 📜 Changelog

Ver [CHANGELOG.md](./CHANGELOG.md) para el historial de cambios.

## 📄 Licencia

MIT © Pablo IB

---

*Hecho con ❤️ y [Hugo](https://gohugo.io)*
