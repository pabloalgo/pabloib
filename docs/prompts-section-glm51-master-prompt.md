# Prompt maestro para GLM 5.1 — Implementación sección `/prompts/`

Copia y pega este prompt en GLM 5.1.

---

Quiero que implementes un MVP de una nueva sección pública `/prompts/` dentro de este repo Hugo.

## Contexto obligatorio

Lee y sigue estos documentos antes de tocar nada:

- `docs/prompts-section-pdr.md`
- `docs/prompts-section-implementation-plan.md`
- `AGENTS.md`
- `hugo.toml`
- `layouts/_default/baseof.html`
- `layouts/_default/list.html`
- `layouts/_default/single.html`
- `static/js/main.js`

## Objetivo

Crear una nueva sección pública de prompts reutilizables, inspirada en bibliotecas tipo Antigravity Rules pero adaptada al estilo editorial y técnico de pabloib.com.

La implementación debe ser un **MVP sólido, simple y mantenible**.

## Stack y restricciones

Respeta estrictamente estas reglas del proyecto:

- Es un sitio **Hugo v0.159.2**
- Usa **Tailwind CSS v3.4** con build local
- **No edites `themes/paper/`**
- Haz overrides solo en `layouts/`
- **No uses inline scripts**; cualquier JS debe ir en `static/js/`
- Mantén compatibilidad con la CSP actual
- El contenido es en **español**
- Después de cambios de código, valida con `npm run build`

## Qué debes implementar

### 1. Nueva sección de contenido

Crea una sección nativa de Hugo en:

- `content/prompts/`

Añade:

- `content/prompts/_index.md`

La sección debe quedar publicada en `/prompts/`.

### 2. Archetype para nuevos prompts

Crea:

- `archetypes/prompts.md`

Debe incluir front matter coherente con el PDR, al menos:

- `title`
- `description`
- `date`
- `lastmod`
- `categories`
- `tags`
- `usecase`
- `models`
- `mode`
- `variables`
- `related_posts`
- `related_prompts`
- `draft`

### 3. Contenido real de ejemplo

Crea **al menos 3 prompts publicados** en `content/prompts/`.

Quiero prompts alineados con el posicionamiento actual del blog. Puedes usar estos temas o equivalentes muy cercanos:

1. prompt para debugging en TypeScript
2. prompt para revisar o mejorar un `AGENTS.md`
3. prompt para estructurar un post técnico en español

Cada prompt debe tener:

- título claro
- description SEO útil
- `usecase`
- `models`
- `variables`
- bloque principal de prompt listo para copiar
- notas de uso
- tags consistentes

### 4. Layout de listado

Crea un template dedicado para la sección:

- `layouts/prompts/list.html`

Debe mostrar:

- título de sección
- descripción
- lista de prompts
- tarjeta o bloque por prompt con:
  - título
  - descripción
  - fecha
  - `usecase`
  - `models` o un resumen útil

Importante: el listado debe verse como una sección propia, no como una copia exacta del listado de posts.

### 5. Layout individual de prompt

Crea:

- `layouts/prompts/single.html`

La página individual debe priorizar:

- escaneabilidad
- claridad
- reutilización
- copy-to-clipboard del prompt principal

La jerarquía recomendada es:

1. header con título y descripción
2. metadata compacta: fecha, `usecase`, `models`
3. lista o chips de `variables`
4. bloque principal del prompt visualmente destacado
5. botón de copiar
6. contenido explicativo
7. tags
8. relacionados explícitos si están en front matter
9. enlace de vuelta a `/prompts/`

## Importante sobre el copy button

No quiero una solución frágil ni global.

Implementa el copy-to-clipboard con una de estas opciones:

- preferiblemente en `static/js/prompts.js`
- o en `static/js/main.js` solo si queda muy limpio y bien aislado

Requisitos:

- sin inline JS
- usar selectores explícitos, idealmente con `data-*`
- botón accesible (`button`, `aria-label`, foco visible)
- feedback visual tras copiar
- no romper la funcionalidad actual de copy code en posts

## Navegación

Haz la nueva sección descubrible.

Cambio mínimo obligatorio:

- añade `Prompts` al menú principal en `hugo.toml`

Cambio opcional:

- tocar el bottom nav solo si encaja muy bien y no empeora la navegación actual

Si dudas, **no toques el bottom nav en este MVP**.

## SEO y compatibilidad

Quiero que la nueva sección herede el sistema actual del sitio en la medida de lo posible:

- meta description
- Open Graph
- sitemap
- canonicals
- JSON-LD si ya aplica sin complicaciones

No quiero sobre-ingeniería SEO en esta iteración.

## Criterios de implementación

Prioriza estas decisiones:

1. usa una sección nueva nativa de Hugo
2. usa templates dedicados para prompts
3. evita meter condicionales raros dentro de `layouts/_default/single.html`
4. no añadas dependencias npm salvo necesidad real
5. mantén el diseño consistente con el blog actual
6. si debes elegir entre sofisticación y robustez, elige robustez

## Entregables esperados

Como mínimo espero estos archivos nuevos o equivalentes:

```text
content/prompts/_index.md
content/prompts/2026-04-17-*.md   # al menos 3 prompts
layouts/prompts/list.html
layouts/prompts/single.html
archetypes/prompts.md
static/js/prompts.js              # recomendado
```

Y estos cambios probablemente:

```text
hugo.toml
```

## Verificación obligatoria

Al terminar:

1. ejecuta `npm run build`
2. corrige cualquier error hasta dejar build verde
3. revisa que existan:
   - `/prompts/`
   - las páginas individuales de los prompts
4. confirma que el botón de copiar funciona
5. confirma que no se editó `themes/paper/`

## Formato de tu respuesta final

Cuando termines, responde con:

1. **Resumen breve** de lo implementado
2. **Lista de archivos creados/modificados**
3. **Resultado de `npm run build`**
4. **Notas o decisiones importantes**
5. **Posibles siguientes mejoras** fuera del MVP

## Criterio de éxito

La tarea se considera completada si:

- existe una nueva sección `/prompts/`
- hay al menos 3 prompts reales publicados
- listado y detalle tienen templates propios
- el prompt principal se puede copiar con un clic
- la sección está enlazada en navegación principal
- `npm run build` pasa sin errores
- no hubo cambios en `themes/paper/`

Implementa solo este MVP. No intentes replicar Antigravity al detalle en esta primera iteración.

---

## Versión corta del encargo

Si necesitas una síntesis operativa:

> Implementa en este repo Hugo una nueva sección pública `/prompts/` con contenido propio, templates dedicados, 3 prompts de ejemplo, botón de copiar robusto, enlace en navegación principal y validación final con `npm run build`, respetando CSP, sin inline scripts y sin tocar `themes/paper/`.
