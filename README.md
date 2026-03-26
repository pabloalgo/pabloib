# 🚀 Pablo IB - Blog Personal

> Mi segunda memoria refinada. Blog sobre tecnología, IA y productividad.

![Hugo](https://img.shields.io/badge/Hugo-v0.145-ff4081?logo=hugo&logoColor=white)
![TailwindCSS](https://img.shields.io/badge/TailwindCSS-v3.4-38bdf8?logo=tailwindcss&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Características

- 🎨 **Diseño Editorial** - Inspirado en revistas técnicas modernas
- 🌓 **Dark Mode** - Toggle con persistencia en localStorage
- 📱 **Mobile First** - Bottom navigation optimizada para móvil
- 🔍 **SEO Optimizado** - Meta tags, Open Graph, JSON-LD
- ⚡ **Rendimiento** - Tailwind CDN + lazy loading preparado
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
│   ├── posts/          # Artículos del blog (7 posts)
│   └── about.md        # Página About
├── layouts/
│   ├── _default/
│   │   ├── baseof.html # Template base + navegación
│   │   ├── single.html # Páginas individuales
│   │   └── list.html   # Listados (tags, categorías)
│   ├── partials/
│   │   └── head.html   # Head con Tailwind config
│   └── index.html      # Homepage
├── assets/
│   └── images/         # Imágenes procesables (Hugo Pipes)
├── static/
│   └── images/         # Imágenes estáticas (og-image, etc.)
├── themes/paper/       # Theme base (submodule)
├── hugo.toml           # Configuración Hugo
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

- **7 artículos** sobre Pi Agent, IA y productividad
- Categorías: Pi, Workflow, Desarrollo
- Tags: pi, workflow, productividad, typescript, agentes

## 🗺️ Roadmap

Ver [ROADMAP.md](./ROADMAP.md) para ver las mejoras planificadas.

## 📜 Changelog

Ver [CHANGELOG.md](./CHANGELOG.md) para el historial de cambios.

## 📄 Licencia

MIT © Pablo IB

---

*Hecho con ❤️ y [Hugo](https://gohugo.io)*
