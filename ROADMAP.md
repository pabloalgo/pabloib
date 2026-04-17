# 🗺️ Roadmap - Pablo IB Blog

Plan de desarrollo y mejoras futuras del proyecto.

---

## 🎯 v2.1 - Funcionalidad Core

### 🔴 Alta Prioridad

- [x] **Búsqueda funcional**
  - Implementar Fuse.js para búsqueda client-side
  - Indexar títulos, contenido y tags
  - Mostrar resultados en tiempo real

- [x] **Filtrado por categorías**
  - Hacer clickeables los botones del carrusel
  - Filtrar artículos sin recargar página
  - Actualizar URL con parámetro `?category=`

- [x] **Página About personalizada**
  - Bio completa con foto
  - Enlaces a redes sociales
  - Timeline de experiencia

- [x] **Copy code button**
  - Botón en bloques de código
  - Feedback visual al copiar
  - Compatible con todos los lenguajes

---

## 🚀 v2.2 - UX Enhancements

### 🟡 Media Prioridad

- [x] **Sistema de paginación**
  - 10 artículos por página
  - Navegación con números
  - Indicador de página actual

- [x] **Artículos relacionados**
  - Basado en tags compartidos
  - Mostrar 3 artículos al final de cada post
  - Algoritmo simple de similitud

- [x] **Scroll progress indicator**
  - Barra de progreso en artículos
  - Indicador visual de lectura
  - Posición sticky en header

- [x] **Back to top button**
  - Aparece después de scroll
  - Animación suave
  - Posición: bottom-right

- [x] **Lazy loading imágenes**
  - Loading="lazy" nativo
  - Placeholder blur mientras carga
  - Mejora Lighthouse score

---

## 🌟 v2.3 - Performance

### ⚡ Optimizaciones

- [x] **Tailwind build local**
  - Migrar de CDN a build
  - Reducir CSS de ~200KB a ~28KB
  - PurgeCSS automático
  - Plugins: forms, container-queries

- [x] **Service Worker / PWA**
  - Cache offline
  - Instalable en móvil
  - Actualizaciones automáticas
  - Iconos SVG placeholder

- [x] **Prefetch inteligente**
  - Precargar links en hover
  - Solo en desktop
  - Mejora percepción de velocidad

---

## 🔒 v2.4 - Security Hardening

### 🛡️ Seguridad

- [x] **Security headers**
  - `_headers` para Cloudflare Pages
  - HSTS (1 año + preload)
  - X-Frame-Options, X-Content-Type-Options
  - Referrer-Policy, Permissions-Policy

- [x] **Content Security Policy**
  - CSP endurecido: solo `self` + cdn.jsdelivr.net
  - Tailwind CDN removido de allowlist

- [x] **SRI para recursos externos**
  - Fuse.js con hash sha384
  - Google Fonts con crossorigin

- [x] **Hardening de contenido**
  - `unsafe = false` en Goldmark renderer
  - `baseURL` real de producción
  - SVG placeholders (og-image, iconos PWA)

---

## 📈 v2.5 - Contenido & SEO

### 📊 SEO & Meta

- [x] **Imágenes Open Graph dinámicas**
  - Generar OG images automáticamente
  - Título del artículo en la imagen
  - Marca de agua del blog

- [x] **Sitemap.xml mejorado**
  - Incluir lastmod
  - Prioridades por tipo de página
  - Submit automático a Google

- [x] **Schema.org ampliado**
  - Article schema para posts
  - BreadcrumbList
  - Person schema en About

- [x] **Descripciones en posts**
  - Agregar `description` a todo el front matter
  - Mejorar snippets en buscadores

### 📝 Sección /prompts/

- [x] **MVP de librería de prompts**
  - Sección nativa de Hugo en `content/prompts/`
  - Templates dedicados: `layouts/prompts/list.html` y `single.html`
  - 3 prompts de ejemplo publicados
  - Copy-to-clipboard con `prompts.js` (CSP compliant)
  - Archetype para nuevos prompts
  - Enlace en navegación principal
  - JSON-LD, SEO y sitemap heredados
  - Partials reutilizables: `prompt-metadata`, `tags-footer`, `related-section`

- [ ] **Fase 2 — Prompts comunitarios con OpnForm**
  - Formulario público con [OpnForm](https://opnform.com/) (software libre, self-hostable, cuenta pro vitalicia)
  - Campos replican el front matter del archetype (`title`, `description`, `usecase`, `models`, `prompt`, `variables`, `tags`)
  - CTA "Envía tu prompt" en `/prompts/`
  - Notificación al autor → curación manual → commit si se aprueba
  - Posible automatización: webhook → GitHub Action → issue con contenido formateado
  - Alternativa evaluada y descartada: GitHub Issue template (más barrera técnica), Tally/Formspree (no libre, vendor lock-in)

---

## 💬 v2.6 - Interactividad

### 🗣️ Comunidad

- [ ] **Sistema de comentarios**
  - Opción A: Giscus (GitHub Discussions)
  - Opción B: Utterances (GitHub Issues)
  - Tema consistente con dark mode

- [ ] **Reacciones por artículo**
  - 👍 👀 🎉 etc.
  - Contador visible
  - Sin login requerido (localStorage)

- [ ] **Newsletter signup**
  - Integración con Buttondown/ConvertKit
  - Formulario en footer
  - CTA en artículos populares

---

## 📚 v3.0 - Nuevas Secciones

### 🆕 Contenido Expandido

- [ ] **Página de Proyectos**
  - Portfolio de proyectos personales
  - Filtros por tecnología
  - Links a GitHub/demo

- [ ] **Página /now**
  - Qué estoy haciendo ahora
  - Actualización mensual
  - Inspirado en nownownow.com

- [ ] **Página /uses**
  - Herramientas que uso
  - Setup de desarrollo
  - Recomendaciones

- [ ] **Bookmarks / Links**
  - Artículos recomendados
  - Recursos útiles
  - Sindicación opcional

---

## 📊 Estado del Progreso

| Versión | Estado | Fecha |
|---------|--------|-------|
| v2.0 | ✅ Completado | 2026-03-26 |
| v2.1 | ✅ Completado | 2026-03-26 |
| v2.2 | ✅ Completado | 2026-03-26 |
| v2.3 | ✅ Completado | 2026-03-26 |
| v2.4 | ✅ Completado | 2026-04-06 |
| v2.5 | ✅ Completado | 2026-04-17 |
| v2.6 | 📋 Planificado | TBD |
| v3.0 | 💭 Visión | TBD |

---

## 🤝 Cómo Contribuir

1. Revisa los issues abiertos
2. Comenta en el feature que te interesa
3. Haz fork y pull request
4. Sigue [Conventional Commits](https://www.conventionalcommits.org/)

---

*Última actualización: 2026-04-17*
