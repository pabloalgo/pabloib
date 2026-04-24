# Plan de implementación — Sección `/prompts/`

> Basado en `docs/prompts-section-pdr.md`
> Fecha: 2026-04-17
> Implementación objetivo: GLM 5.1
> Estrategia: MVP primero

## 1. Objetivo del plan

Implementar una nueva sección pública de prompts dentro de pabloib.com con el menor cambio estructural posible y máxima compatibilidad con la arquitectura actual de Hugo.

## 2. Enfoque recomendado

### Estrategia

Construir el MVP como una **nueva sección de contenido nativa de Hugo**, no como una variación de `posts`.

Esto implica:

- nuevo árbol `content/prompts/`
- templates dedicados para list y single
- contenido de ejemplo real
- una pequeña mejora de navegación
- una interacción mínima de copiar prompt

### Motivos

- separa contenido utilitario de artículos
- reduce condicionales raros en templates globales
- facilita escalar la sección después
- hace el trabajo más directo para GLM 5.1

## 3. Alcance del MVP

### Incluido

- `/prompts/` como nueva sección
- listado de prompts
- detalle de prompt
- copy-to-clipboard
- archetype para nuevos prompts
- 3 prompts de ejemplo
- enlace en navegación principal
- build verde con `npm run build`

### Excluido

- filtros avanzados
- buscador exclusivo de prompts
- landing con widgets complejos
- taxonomías nuevas específicas
- lógica de recomendación automática avanzada

## 4. Orden de trabajo recomendado

### Fase 0 — Preparación y lectura

#### Objetivo
Entender los puntos de integración existentes y minimizar regresiones.

#### Tareas

1. Leer y respetar:
   - `AGENTS.md`
   - `hugo.toml`
   - `layouts/_default/baseof.html`
   - `layouts/_default/list.html`
   - `layouts/_default/single.html`
   - `static/js/main.js`

2. Confirmar convenciones ya presentes:
   - estilos Tailwind usados por el blog
   - patrones de metadata en listados y singles
   - restricciones CSP

#### Entregable
Ningún cambio visible todavía. Solo comprensión del sistema.

---

### Fase 1 — Scaffolding de contenido

#### Objetivo
Crear la nueva sección de contenido y su plantilla editorial.

#### Archivos a crear

1. `content/prompts/_index.md`
2. `archetypes/prompts.md`

#### Contenido recomendado

##### `content/prompts/_index.md`
Debe incluir:

- `title: "Prompts"`
- `description` explicando el propósito de la sección
- estado público, no draft

##### `archetypes/prompts.md`
Debe incluir el front matter estándar del PDR:

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

#### Criterio de salida

- Hugo reconoce la sección `prompts`
- existe una forma consistente de crear nuevos prompts

---

### Fase 2 — Crear contenido real de ejemplo

#### Objetivo
Poblar la sección con suficientes ejemplos para probar UX y navegación.

#### Archivos a crear

Crear al menos 3 prompts en `content/prompts/`.

Sugerencias alineadas con el blog actual:

1. `content/prompts/2026-04-17-prompt-debugging-typescript.md`
2. `content/prompts/2026-04-17-prompt-review-agents-md.md`
3. `content/prompts/2026-04-17-prompt-estructurar-post-tecnico.md`

#### Requisitos de estos prompts

Cada uno debe incluir:

- descripción SEO útil
- caso de uso claro
- modelos compatibles
- variables explícitas
- bloque de prompt copiable
- notas de uso
- tags consistentes

#### Criterio de salida

- la sección ya tiene contenido real para diseñar list y single
- hay variedad suficiente para validar el modelo

---

### Fase 3 — Layout de listado

#### Objetivo
Dar identidad propia a `/prompts/`.

#### Archivo a crear

- `layouts/prompts/list.html`

#### Requisitos funcionales

1. Mostrar encabezado de sección:
   - título
   - descripción

2. Renderizar lista de prompts:
   - título
   - descripción
   - fecha
   - `usecase`
   - `models` o contador simple

3. Mantener estilo coherente con cards/listados actuales.

4. Orden recomendado:
   - más reciente primero

#### Requisitos de implementación

- no duplicar más lógica de la necesaria
- reutilizar clases y patrones visuales existentes cuando tenga sentido
- no depender de JS para renderizar el contenido principal

#### Criterio de salida

- `/prompts/` se ve como una sección propia
- los prompts se pueden descubrir fácilmente

---

### Fase 4 — Layout individual de prompt

#### Objetivo
Construir una página optimizada para leer, entender y copiar el prompt.

#### Archivo a crear

- `layouts/prompts/single.html`

#### Estructura recomendada

1. **Header**
   - título
   - descripción
   - fecha
   - badge de `usecase`
   - lista de `models`

2. **Resumen de variables**
   - si `variables` existe, mostrar chips o lista compacta

3. **Bloque principal del prompt**
   - visualmente destacado
   - idealmente dentro de `pre`/`code` o contenedor equivalente claro
   - con selector fiable para copy-to-clipboard

4. **Contenido explicativo**
   - cuándo usarlo
   - límites
   - ejemplo

5. **Tags**

6. **Relacionados explícitos**
   - prompts
   - posts

7. **Navegación**
   - volver a `/prompts/`

#### Requisitos clave

- el prompt debe ser el centro de gravedad visual
- el contenido debe seguir siendo usable sin JS
- el copy button es mejora progresiva

#### Criterio de salida

- cada prompt individual tiene una UX claramente distinta de un post
- el bloque principal del prompt destaca y se entiende rápido

---

### Fase 5 — Copy to clipboard

#### Objetivo
Añadir la interacción mínima más importante del MVP.

#### Opción recomendada

Usar un archivo JS específico nuevo:

- `static/js/prompts.js`

Esto es preferible a seguir creciendo `static/js/main.js`, porque:

- reduce acoplamiento
- hace el comportamiento más fácil de localizar
- evita efectos laterales sobre posts

#### Integración sugerida

Cargar `prompts.js` desde el layout de prompts o desde `baseof` con una condición por sección.

#### Requisitos del comportamiento

1. detectar botones con `data-copy-target`
2. copiar el texto del bloque objetivo
3. mostrar feedback de éxito temporal
4. mantener accesibilidad básica:
   - botón real `button`
   - `aria-label`
   - foco visible

#### Evitar

- selectores frágiles dependientes de clases decorativas
- mutar todos los bloques de código del sitio
- romper la funcionalidad actual de copy code para posts

#### Criterio de salida

- el prompt principal se copia con un clic
- no hay regresión en los bloques de código existentes

---

### Fase 6 — Navegación y descubrimiento

#### Objetivo
Hacer accesible la nueva sección sin tocar demasiado la navegación global.

#### Archivos a editar

1. `hugo.toml`
2. opcionalmente `layouts/_default/baseof.html`

#### Cambio mínimo obligatorio

Añadir un item al menú principal:

- `identifier = 'prompts'`
- `name = 'Prompts'`
- `url = '/prompts/'`

#### Cambio opcional

Si el diseño lo permite, añadir acceso a prompts en el bottom nav. Solo hacerlo si no degrada la claridad actual.

#### Recomendación

Para el MVP, **añadir al menú principal y no tocar todavía el bottom nav**, salvo que GLM 5.1 vea una integración obvia y limpia.

#### Criterio de salida

- la sección es descubrible desde navegación global

---

### Fase 7 — SEO y metadatos

#### Objetivo
Confirmar que la sección se integra bien con el sistema SEO existente.

#### Archivos a revisar

1. `layouts/partials/head.html`
2. `layouts/partials/jsonld.html`
3. `layouts/partials/og-image.html`

#### Qué verificar

- que `description` se expone correctamente en prompts
- que títulos y canonicals funcionan
- que la OG image no rompe para la nueva sección
- que sitemap incluya `/prompts/` y sus páginas individuales

#### Regla

No sobre-ingenierizar JSON-LD específico para prompts en el MVP. Reusar lo existente si ya produce salida válida y consistente.

#### Criterio de salida

- prompts con metadatos básicos correctos
- build sin errores de templates

---

### Fase 8 — Verificación final

#### Objetivo
Asegurar que la entrega está lista para merge.

#### Verificaciones obligatorias

1. Ejecutar:

```bash
npm run build
```

2. Revisar que:

- no hay errores de Hugo
- no hay errores de Tailwind
- `/prompts/` se genera
- cada prompt individual se genera
- los enlaces funcionan
- el copy button funciona en navegador
- no se editó `themes/paper/`

3. Verificación visual manual:

- mobile
- desktop
- dark mode

#### Criterio de salida

Build verde + UX correcta + sin regresiones obvias.

## 5. Plan de archivos

### Nuevos archivos mínimos

```text
content/prompts/_index.md
content/prompts/2026-04-17-prompt-debugging-typescript.md
content/prompts/2026-04-17-prompt-review-agents-md.md
content/prompts/2026-04-17-prompt-estructurar-post-tecnico.md
layouts/prompts/list.html
layouts/prompts/single.html
archetypes/prompts.md
static/js/prompts.js            # recomendado
```

### Archivos a modificar probablemente

```text
hugo.toml
layouts/_default/baseof.html    # solo si se decide exponer Prompts en navegación visible
layouts/partials/head.html      # solo si hace falta ajuste SEO
```

## 6. Checklist operativo para GLM 5.1

### Antes de editar

- [ ] leer el PDR completo
- [ ] leer los templates actuales
- [ ] confirmar restricciones del proyecto

### Durante implementación

- [ ] no editar `themes/paper/`
- [ ] mantener scripts externos
- [ ] mantener consistencia visual con Tailwind existente
- [ ] usar contenido de ejemplo realista

### Antes de cerrar

- [ ] `npm run build`
- [ ] revisar `/prompts/`
- [ ] revisar 3 prompts individuales
- [ ] probar copy button
- [ ] revisar dark mode
- [ ] revisar navegación

## 7. Riesgos de implementación para GLM 5.1

### Riesgo 1 — Reutilizar demasiado `single.html`

Si GLM 5.1 mete demasiadas condiciones dentro de `layouts/_default/single.html`, la solución se vuelve más frágil.

**Preferencia**: usar `layouts/prompts/single.html` dedicado.

### Riesgo 2 — Botón copy demasiado global

Si el script toca todos los `pre code` del sitio, puede interferir con la lógica existente.

**Preferencia**: usar un selector explícito solo para prompts.

### Riesgo 3 — Mezclar prompts con posts

Si la sección hereda demasiadas convenciones de post, el valor de producto se diluye.

**Preferencia**: distinguir claramente cards, metadata y CTA principal.

### Riesgo 4 — Saturar navegación móvil

Cambiar el bottom nav en el MVP puede meter ruido.

**Preferencia**: empezar por menú principal.

## 8. Definición de Done

La tarea estará terminada cuando:

- exista una nueva sección `/prompts/`
- haya 3 prompts reales publicados
- el listado y el detalle tengan templates propios
- el prompt principal tenga copy button funcional
- la navegación principal permita llegar a la sección
- `npm run build` pase sin errores
- no se hayan introducido regresiones visibles

## 9. Siguientes iteraciones recomendadas

Una vez entregado el MVP, el siguiente backlog natural sería:

1. filtros por `usecase`
2. filtros por `models`
3. componente de relacionados más rico
4. CTA bidireccional entre prompts y posts
5. homepage teaser de prompts destacados
6. posible promoción futura a una sección hermana tipo `playbooks`

## 10. Instrucción final para GLM 5.1

Implementar **solo el MVP descrito aquí**. No intentar replicar Antigravity por completo en la primera iteración. La prioridad es introducir un tipo de contenido nuevo, sólido, útil y compatible con el stack actual del blog.
