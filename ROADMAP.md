# 🗺️ Roadmap - Pablo IB Blog

Plan de desarrollo y mejoras futuras del proyecto.

---

## 🎯 v2.1 - Funcionalidad Core (Próxima)

### 🔴 Alta Prioridad

- [x] **Búsqueda funcional**
  - Implementar Fuse.js para búsqueda client-side
  - Indexar títulos, contenido y tags
  - Mostrar resultados en tiempo real

- [x] **Filtrado por categorías**
  - Hacer clickeables los botones del carrusel
  - Filtrar artículos sin recargar página
  - Actualizar URL con parámetro `?category=`

- [ ] **Página About personalizada**
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

## 🌟 v2.3 - Contenido & SEO

### 📈 SEO & Meta

- [ ] **Imágenes Open Graph dinámicas**
  - Generar OG images automáticamente
  - Título del artículo en la imagen
  - Marca de agua del blog

- [ ] **Sitemap.xml mejorado**
  - Incluir lastmod
  - Prioridades por tipo de página
  - Submit automático a Google

- [ ] **Schema.org ampliado**
  - Article schema para posts
  - BreadcrumbList
  - Person schema en About

---

## 💬 v2.4 - Interactividad

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

## 🔧 v2.5 - Performance

### ⚡ Optimizaciones

- [x] **Tailwind build local**
  - Migrar de CDN a build
  - Reducir CSS de ~200KB a ~15KB
  - PurgeCSS automático

- [x] **Service Worker / PWA**
  - Cache offline
  - Instalable en móvil
  - Actualizaciones automáticas

- [x] **Prefetch inteligente**
  - Precargar links en hover
  - Solo en desktop
  - Mejora percepción de velocidad

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

| Versión | Estado | Fecha Estimada |
|---------|--------|----------------|
| v2.0 | ✅ Completado | 2026-03-26 |
| v2.1 | ✅ Completado | 2026-03-26 |
| v2.2 | ✅ Completado | 2026-03-26 |
| v2.3 | 📋 Planificado | TBD |
| v2.4 | 💡 Idea | TBD |
| v2.5 | ✅ Completado | 2026-03-26 |
| v3.0 | 💭 Visión | TBD |

---

## 🤝 Cómo Contribuir

1. Revisa los issues abiertos
2. Comenta en el feature que te interesa
3. Haz fork y pull request
4. Sigue [Conventional Commits](https://www.conventionalcommits.org/)

---

*Última actualización: 2026-03-26*
