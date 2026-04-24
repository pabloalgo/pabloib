# PDR — Sección pública de Prompts para pabloib.com

> Estado: propuesta aprobable
> Fecha: 2026-04-17
> Autor: Pi
> Implementación objetivo: GLM 5.1

## 1. Resumen

Crear una nueva sección pública `/prompts/` dentro de pabloib.com para publicar prompts curados, reutilizables y bien presentados, inspirada en patrones tipo Antigravity Rules, pero adaptada al estilo editorial y técnico de Pablo IB.

La sección debe permitir:

- descubrir prompts por caso de uso
- abrir una página individual clara y escaneable
- copiar el prompt fácilmente
- entender cuándo usarlo, cómo parametrizarlo y qué límites tiene
- relacionar prompts entre sí y con artículos del blog cuando aporte contexto

La implementación debe respetar la arquitectura actual del blog:

- Hugo v0.159.2
- tema `paper` sin editar el submódulo
- overrides en `layouts/`
- JavaScript externo en `static/js/`
- CSP estricta, sin inline scripts

## 2. Problema

Hoy el blog tiene dos espacios principales:

- `content/posts/` para artículos largos
- `wiki/` para conocimiento interno no publicado

Falta un formato intermedio para artefactos prácticos, cortos y reutilizables como prompts, playbooks o reglas operativas. Publicarlos como posts genera fricción porque:

- un post obliga a una narrativa más larga
- dificulta el escaneo rápido y la reutilización inmediata
- mezcla contenido editorial con contenido utilitario
- no favorece la navegación por tipo de tarea, modelo o formato

## 3. Oportunidad

Una librería de prompts puede:

- ampliar la superficie SEO del sitio con páginas muy específicas
- convertir conocimiento práctico en activos reutilizables
- complementar los posts existentes sobre Pi, prompting, debugging y agentes
- servir como puente entre la wiki privada y el contenido público
- abrir una nueva línea editorial sin romper la estructura actual del blog

## 4. Objetivos

### Objetivos de producto

1. Añadir una sección pública `/prompts/` visible en la navegación del sitio.
2. Permitir publicar prompts como contenido de primer nivel, no como posts.
3. Diseñar una plantilla de detalle con foco en legibilidad, reutilización y copia.
4. Crear una plantilla de índice que facilite exploración y descubrimiento.
5. Mantener consistencia visual con el blog actual.

### Objetivos editoriales

1. Separar claramente prompts utilitarios de artículos narrativos.
2. Estandarizar la estructura de cada prompt.
3. Hacer evidente el contexto de uso, variables y variantes.
4. Permitir enlazar desde prompts hacia posts de contexto y viceversa.

### Objetivos técnicos

1. No editar `themes/paper/`.
2. No usar scripts inline.
3. Integrar la sección con SEO, sitemap y taxonomías existentes.
4. Mantener complejidad baja en el MVP para que GLM 5.1 pueda implementarlo sin ambigüedad.

## 5. No objetivos

Fuera de alcance para el MVP:

- autenticación de usuarios
- favoritos, ratings o comentarios en prompts
- editor interactivo de variables
- almacenamiento de prompts privados en el frontend
- buscador exclusivo para prompts con índice separado
- filtros avanzados multi-select en cliente
- internacionalización de prompts
- analytics custom nuevas
- sistema de versionado complejo por prompt

## 6. Usuario objetivo

### Primario

- desarrolladores y makers que quieren prompts listos para usar
- lectores de Pablo IB interesados en Pi, agentes, debugging, TypeScript y workflows

### Secundario

- usuarios que llegan por SEO buscando una tarea concreta
- lectores que quieren copiar una plantilla sin leer un post largo

## 7. Casos de uso principales

1. **Descubrir**: un usuario entra en `/prompts/` y encuentra prompts por tema o caso de uso.
2. **Evaluar**: abre un prompt y entiende en menos de 20 segundos si le sirve.
3. **Copiar**: pulsa un botón y copia el prompt completo.
4. **Adaptar**: sustituye variables marcadas como placeholders.
5. **Profundizar**: si quiere contexto, navega a un post relacionado.

## 8. Principios del diseño

1. **Escaneable primero**: la página debe funcionar bien incluso sin leerla completa.
2. **Copiable primero**: el activo principal es el prompt, no la prosa.
3. **Contexto mínimo suficiente**: explicar lo justo para usarlo bien.
4. **Consistencia editorial**: mismo lenguaje visual y tono del blog.
5. **Evolución incremental**: MVP simple, mejoras después.

## 9. Arquitectura de información propuesta

### Nueva sección pública

- `/prompts/` — landing/listado de prompts
- `/prompts/<slug>/` — detalle de prompt

### Tipos de contenido

- `content/prompts/_index.md` — portada de sección
- `content/prompts/YYYY-MM-DD-slug.md` o `content/prompts/slug.md` — prompts individuales

### Relación con otras áreas

- `content/posts/` sigue siendo para artículos largos
- `wiki/` sigue siendo privada y puede actuar como incubadora
- flujo sugerido: `wiki/` → curación → `content/prompts/`

## 10. Modelo de contenido del prompt

Cada prompt debe tener un front matter estándar.

### Front matter mínimo recomendado

```yaml
---
title: "Título del prompt"
description: "Descripción SEO breve y útil"
date: 2026-04-17
lastmod: 2026-04-17
categories: ["Prompts"]
tags: ["prompt", "pi", "debugging"]
usecase: "debugging"
models: ["claude", "gpt", "pi"]
mode: "template"
variables: ["<error>", "<stack>", "<contexto>"]
difficulty: "intermediate"
related_posts: []
related_prompts: []
draft: false
---
```

### Cuerpo recomendado

Orden sugerido para consistencia:

1. **Cuándo usarlo**
2. **Qué resuelve**
3. **Prompt**
4. **Variables**
5. **Ejemplo de uso**
6. **Notas / límites**
7. **Prompts o posts relacionados**

### Campos del MVP

Campos que el template debe soportar desde el inicio:

- `title`
- `description`
- `date`
- `lastmod`
- `categories`
- `tags`
- `usecase`
- `models`
- `variables`
- `related_posts`
- `related_prompts`
- `draft`

Campos opcionales que pueden quedar solo documentados:

- `difficulty`
- `mode`
- `author_notes`
- `status`

## 11. Requisitos funcionales

### RF-1 — Índice de prompts

El sitio debe exponer una página `/prompts/` con:

- título de sección
- descripción corta
- lista de prompts ordenados por fecha descendente
- tarjeta por prompt con título, descripción y metadatos esenciales

### RF-2 — Página individual de prompt

Cada prompt debe tener una página propia con:

- título
- descripción
- metadatos visibles: caso de uso, modelos, variables, fecha
- bloque principal del prompt bien destacado
- botón de copiar
- tags
- navegación hacia otros prompts o a la lista

### RF-3 — Copiar prompt

El usuario debe poder copiar el texto del prompt con un clic.

Requisitos:

- sin inline scripts
- feedback visual de éxito o error
- accesible con teclado

### RF-4 — Navegación

La sección debe aparecer en al menos una de estas superficies:

- menú principal de `hugo.toml`
- navegación inferior o header existente, si el espacio lo permite

MVP mínimo aceptable: al menos en el menú principal configurable y accesible mediante URL directa.

### RF-5 — SEO

Los prompts deben heredar el sistema de SEO existente:

- `head.html`
- Open Graph
- Twitter cards
- JSON-LD existente si aplica
- sitemap de Hugo

### RF-6 — Relacionados

La página individual debe permitir mostrar relacionados en uno de estos niveles:

1. por `related_prompts` explícitos
2. por `related_posts` explícitos
3. como fallback, por tags compartidos

Para el MVP, basta con soportar relacionados explícitos desde front matter.

## 12. Requisitos no funcionales

### RNF-1 — Compatibilidad con arquitectura actual

La solución debe usar:

- `layouts/prompts/list.html` para el listado
- `layouts/prompts/single.html` para el detalle, o fallback equivalente con condicionales bien acotados
- `static/js/` para cualquier interacción nueva

### RNF-2 — Seguridad

- No usar scripts inline
- No debilitar CSP
- No introducir dependencias externas innecesarias

### RNF-3 — Mantenibilidad

- El modelo de contenido debe ser simple de editar a mano
- Debe existir un archetype o plantilla editorial para nuevos prompts
- La implementación debe evitar lógica compleja en JavaScript

### RNF-4 — Rendimiento

- Las páginas deben ser estáticas, sin backend
- El JS adicional debe ser mínimo
- El botón de copiar no debe bloquear la carga principal

## 13. UX esperada en el MVP

### Listado `/prompts/`

La landing debe comunicar rápido que esta sección es una librería utilitaria, no un feed de posts.

Elementos sugeridos:

- hero corto con título y descripción
- grid o stack de cards
- badge de caso de uso o modelo
- recuento opcional de variables/modelos

### Página individual

Jerarquía sugerida:

1. encabezado con título y descripción
2. metadatos compactos
3. bloque destacado con el prompt
4. botón de copiar
5. guía breve de uso
6. relacionados

## 14. Decisiones de contenido para el MVP

### Naming de la sección

Nombre público recomendado: **Prompts**

Razonamiento:

- es claro
- coincide con la intención del usuario
- evita ambigüedad de “rules” o “playbooks”
- facilita SEO

### Tono editorial

- español
- técnico
- directo
- práctico
- sin exceso de marketing

## 15. Dependencias e impactos

### Archivos seguramente impactados

- `hugo.toml`
- `layouts/_default/baseof.html` o templates de navegación relacionados
- `layouts/partials/head.html` si se requiere afinado SEO por sección
- `static/js/main.js` o un nuevo JS específico si se separa la lógica
- `content/prompts/`
- `archetypes/`

### Posibles archivos nuevos

- `content/prompts/_index.md`
- `content/prompts/<slug>.md`
- `layouts/prompts/list.html`
- `layouts/prompts/single.html`
- `archetypes/prompts.md`
- opcional: `static/js/prompts.js`

## 16. Riesgos

1. **Confusión con posts**
   - Mitigación: diferenciar visualmente el layout y la IA de sección.

2. **Sobrediseñar el MVP**
   - Mitigación: priorizar contenido, plantilla simple y copy-to-clipboard.

3. **JS acoplado a selectores frágiles**
   - Mitigación: usar `data-*` attributes para el botón de copiar, no selectores accidentales.

4. **Contenido inconsistente entre prompts**
   - Mitigación: archetype + checklist editorial.

5. **Navegación saturada**
   - Mitigación: añadir “Prompts” primero en menú principal; evaluar luego si merece espacio en bottom nav.

## 17. Criterios de aceptación del MVP

Se considerará completo cuando:

1. exista `/prompts/` accesible y enlazada
2. existan al menos 3 prompts de ejemplo publicados
3. cada prompt tenga página individual funcional
4. el bloque de prompt se pueda copiar con un clic
5. el sitio compile con `npm run build` sin errores
6. no se hayan editado archivos dentro de `themes/paper/`
7. no haya scripts inline nuevos
8. el resultado mantenga coherencia visual con el resto del blog

## 18. Fuera del MVP pero recomendadas para fase 2

- filtros client-side por `usecase` y `models`
- bloques visuales tipo “Variables” y “Notas” más ricos
- sección “Prompt relacionado” automática por tags
- CTA hacia posts largos relacionados
- badges por dificultad
- landing más parecida a una librería de recursos
- índice JSON específico si el volumen crece

## 19. Guía para GLM 5.1

Para reducir ambigüedad en implementación:

1. priorizar una solución estática, simple y predecible
2. no introducir nuevas dependencias npm salvo necesidad real
3. no tocar el tema base
4. separar claramente layout de listado y layout de detalle
5. si hay duda entre elegante y robusto, elegir robusto
6. mantener el JS nuevo aislado y con selectores explícitos
7. validar siempre con `npm run build`

## 20. Recomendación final

Implementar primero una **librería de prompts simple pero sólida**. El éxito del MVP no depende de replicar Antigravity al detalle, sino de introducir un nuevo tipo de contenido útil, claro y publicable dentro del stack actual de Hugo.
