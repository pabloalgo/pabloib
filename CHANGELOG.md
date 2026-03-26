# Changelog

Todos los cambios notables de este proyecto serán documentados en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/),
y este proyecto adhiere a [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [2.2.0] - 2026-03-26

### ✨ Added
- **Sistema de paginación** - Navegación entre páginas de artículos (10 por página)
- **Artículos relacionados** - 3 posts relacionados basados en tags al final de cada artículo
- **Scroll progress indicator** - Barra de progreso de lectura en el header
- **Back to top button** - Botón flotante para volver arriba (aparece después de scroll)
- **Service Worker / PWA** - Cache offline y modo instalable
- **Prefetch inteligente** - Precarga de páginas en hover (solo desktop)
- **Tailwind build local** - Configuración para build local de CSS
- **Manifest.json** - PWA manifest para instalación

### 🔧 Changed
- index.html ahora usa .Paginator de Hugo
- single.html incluye artículos relacionados
- baseof.html incluye scroll progress y back to top
- main.js incluye scroll tracking, back to top y prefetch
- hugo.toml configurado con paginate = 10
- head.html incluye manifest y theme-color dinámico

---

## [2.1.0] - 2026-03-26

### ✨ Added
- **Búsqueda funcional** - Fuse.js para búsqueda client-side de artículos
- **Filtrado por categorías** - Botones clickeables en el carrusel de categorías
- **Copy code button** - Botón para copiar bloques de código con feedback visual
- **Lazy loading imágenes** - Carga diferida de imágenes para mejor rendimiento
- **Página About rediseñada** - Layout completo con bio, stack, filosofía y stats
- **JSON search index** - `/index.json` para búsqueda de artículos

### 🔧 Changed
- Añadido `loading="lazy"` a todas las imágenes
- Mejorado el script de dark mode
- Añadido `/js/main.js` con funcionalidades interactivas

---

## [2.0.0] - 2026-03-26

### ✨ Added
- **Nuevo diseño "Architectural Editor"** - Estilo editorial moderno inspirado en revistas técnicas
- **Tailwind CSS v3.4** - Sistema de diseño via CDN con configuración personalizada
- **Dark Mode completo** - Toggle en header con persistencia en localStorage
- **Material Symbols** - Iconografía de Google Material Design
- **Bottom Navigation** - Navegación móvil optimizada (Feed, Archivos, Tags, About)
- **Categorías visuales** - Carrusel horizontal de categorías
- **Artículo destacado** - Primer post con estilo featured en homepage
- **Efecto grayscale hover** - Transición de B/N a color en imágenes

### 🎨 Design System
- **Tipografía:**
  - Headlines: Plus Jakarta Sans (700, 800)
  - Body: Inter (400, 500, 600)
  - Labels: Space Grotesk (500, 700)
- **Colores:**
  - Primary: Cyan `#00647c`
  - Background: Blanco cálido `#faf8ff`
  - Dark: Slate `#0f172a`
- **Border radius:** Minimal (2px - 8px)

### 🗑️ Removed
- Glassmorphism anterior (reemplazado por diseño editorial limpio)
- Blobs animados de fondo (reemplazado por fondos sólidos)
- CSS custom anterior (~15KB → ahora con Tailwind)

### 🔧 Changed
- Layouts completamente reescritos
- `baseof.html` ahora incluye navegación fija
- `head.html` con configuración Tailwind inline
- Soporte completo para modo oscuro en todos los componentes

---

## [1.2.0] - 2026-03-25

### ✨ Added
- Configuración de dominio personalizado: `pabloib.com`
- Adopción oficial de la especificación Conventional Commits
- Integración de reglas de `hugo-template-dev` para robustez de layouts
- Registro de estándares oficiales de Hugo en la configuración del agente

---

## [1.1.0] - 2026-03-25

### ✨ Added
- Rediseño moderno con SEO optimizado (Meta, OG, JSON-LD)
- Hero section personalizada en la Home
- Dark mode nativo con persistencia
- 7 artículos migrados de Obsidian

---

## [1.0.0] - 2026-03-25

### ✨ Added
- Proyecto inicializado
- Hugo + Paper theme (Git Submodule)
- Estructura base del blog

---

[2.0.0]: https://github.com/pabloalgo/pabloib/compare/v1.2.0...v2.0.0
[1.2.0]: https://github.com/pabloalgo/pabloib/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/pabloalgo/pabloib/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/pabloalgo/pabloib/releases/tag/v1.0.0
