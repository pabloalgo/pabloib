---
title: "Cómo monté un LLM Wiki con Hugo y Pi — la implementación"
description: "Implementación del patrón LLM Wiki de Karpathy en un blog Hugo con Pi como mantenedor. Estructura de directorios, workflows y decisiones de diseño."
date: 2026-04-16
lastmod: 2026-04-16
categories: ["Pi"]
tags: ["pi", "llm-wiki", "hugo", "knowledge-management", "tutorial"]
mode: tutorial
draft: true
isCJKLanguage: false
---

Leí el gist de Karpathy sobre el patrón LLM Wiki y pensé: puedo hacer esto con mi blog. Tengo Hugo, tengo Pi, tengo markdown. ¿Qué más necesito?

La respuesta: nada. Cuatro archivos y media hora después tenía una wiki privada que Pi mantiene y que alimenta los posts del blog. Aquí está cómo.

## Lo que tenía antes

pabloib.com es un blog estático con Hugo. 15 posts en `content/posts/`, cada uno con front matter YAML, Tailwind para estilos, Fuse.js para búsqueda. Pi ya escribe los posts usando un skill de escritura. El sistema funciona bien para publicar, pero no para acumular conocimiento entre posts.

Cada artículo empieza desde cero. Investigo un tema, escribo el post, y el conocimiento se queda encapsulado ahí. Si semanas después quiero escribir sobre algo relacionado, no hay forma de recuperar las notas y fuentes originales. Se perdieron en el historial del chat.

## La decisión de diseño principal

Karpathy describe tres capas: raw sources, wiki, y schema. Mi decisión clave fue dónde poner la wiki.

Opción A: sección pública en Hugo (`content/wiki/`). Los lectores ven las notas.
Opción B: directorio privado dentro del repo (`wiki/`). Hugo no lo toca.
Opción C: híbrido — notas privadas que maduran y se convierten en posts.

Elegí la opción C. La wiki es el taller donde acumulo conocimiento. El blog es la ventana donde publico lo que vale la pena. No todo merece ser un post de 1500 palabras. Pero todo merece ser capturado como nota.

## La estructura de directorios

```
pabloib/
├── content/posts/          # Posts públicos (ya existía)
├── wiki/                   # Wiki privada (nuevo)
│   ├── index.md            # Catálogo de todas las notas
│   ├── log.md              # Log cronológico append-only
│   ├── conventions.md      # Reglas del juego para Pi
│   ├── topics/             # Páginas de síntesis por tema
│   ├── sources/            # Resúmenes de fuentes consumidas
│   └── concepts/           # Definiciones breves
```

`wiki/` está fuera de `content/`. Hugo lo ignora completamente. No aparece en el build, no se publica, no se sirve. Pero está en el repo — se commitea, tiene historial de git, y Pi puede leer y escribir en él.

## Los archivos clave

### conventions.md — las reglas

Este es el archivo más importante. Le dice a Pi cómo mantener la wiki. Define front matter para cada tipo de nota, los cuatro workflows, y criterios para decidir si algo es un topic o un concept.

La distinción es práctica:

- **Topic** = tema amplio con múltiples fuentes y síntesis propia. Crece con el tiempo. Ejemplo: "LLM Wiki", "Prompt Engineering"
- **Concept** = definición breve, 1-2 párrafos. Un diccionario. Ejemplo: "RAG", "Knowledge Management"

Un topic con 3+ fuentes es candidato a post. Un concept es una nota rápida que otros topics referencian.

### index.md — el catálogo

Una tabla markdown con todas las notas. Columnas: nombre, estado, fuentes, fecha. Se actualiza en cada ingest. Pi lo lee primero cuando busca información.

### log.md — el timeline

Append-only. Cada entrada con formato `## [YYYY-MM-DD] tipo | Título`. Parseable con grep. Es la historia de la wiki.

## Los cuatro workflows

### Ingest

```
Usuario: "Ingest esta URL"
Pi:
  1. Fetch y lee la fuente
  2. Crea wiki/sources/YYYY-MM-DD-slug.md con el resumen
  3. Identifica topics (existentes o nuevos)
  4. Actualiza topics afectados
  5. Crea concepts si aparecen nuevos
  6. Actualiza index.md
  7. Agrega entrada a log.md
```

Una fuente toca 5-10 archivos. Eso es correcto — es la wiki acumulando conocimiento.

### Query

```
Usuario: "¿Qué sé sobre RAG?"
Pi:
  1. Lee index.md
  2. Busca páginas relevantes
  3. Lee topics, concepts, sources
  4. Sintetiza respuesta con referencias
```

Las respuestas buenas se archivan como notas nuevas.

### Lint

```
Usuario: "Lint la wiki"
Pi revisa:
  - Contradicciones entre páginas
  - Páginas huérfanas
  - Conceptos sin página
  - Cross-references rotas
  - Stale claims
  - Gaps que podrían llenarse con búsqueda web
```

### Promote

```
Usuario: "Promote el topic X a post"
Pi:
  1. Verifica que el topic está maduro (status: mature)
  2. Usa el skill pabloib-writer
  3. Crea post en content/posts/ con front matter completo
  4. Actualiza topic: status → post
  5. Agrega entrada a log.md
```

Este es el workflow que cierra el ciclo. La wiki alimenta el blog. Las notas se convierten en artículos.

## Cómo se integra con AGENTS.md

Añadí una sección "Wiki" al AGENTS.md del proyecto:

```markdown
## Wiki (LLM Wiki — patrón Karpathy)

- `wiki/` — NO es contenido Hugo, no se publica
- `wiki/conventions.md` — Reglas completas
- 4 workflows: ingest, query, lint, promote
- Estados: seedling → budding → mature → post
```

No repito todo — apunto a `conventions.md`. Pi lee AGENTS.md al inicio de cada sesión, y si necesita los detalles completos, lee conventions.md. Una sola fuente de verdad.

## El front matter de las notas

Topics:
```yaml
---
title: "LLM Wiki"
created: 2026-04-16
updated: 2026-04-16
sources: [karpathy-llm-wiki]
related: [knowledge-management, rag]
status: seedling    # seedling → budding → mature → post
---
```

Sources:
```yaml
---
title: "Karpathy's LLM Wiki: The Idea File"
author: "Andrej Karpathy"
url: "https://gist.github.com/karpathy/..."
type: article       # article | paper | video | podcast | book
date: 2026-04-16
topics: [llm-wiki]
---
```

Concepts:
```yaml
---
title: "RAG"
related: [llm-wiki]
---
```

Simple. Sin campos extra. Sin complejidad.

## Lo que construí vs lo que Karpathy describe

Karpathy trabaja con Obsidian abierto en una ventana y el agente en la otra. Es el ciclo que hace que funcione: el LLM escribe, tú revisas en el graph view, sigues links, corriges, dejas notas. El [Web Clipper de Obsidian](https://obsidian.md/clipper) convierte cualquier artículo en markdown con un click — así cae directo a tus raw sources sin copy-paste ni formato roto. Es la pieza que cierra el ingest.

Configuré Obsidian abriendo `wiki/` directamente como vault. Así Obsidian ve las mismas carpetas que Pi escribe: topics/, sources/, concepts/. No hay duplicación, no hay sincronización — es el mismo directorio. Pi escribe, yo reviso en Obsidian, yo anoto, Pi lee mis notas en la siguiente sesión.

Plugins que uso: **Smart Connections** para encontrar notas relacionadas con embeddings locales, y los core plugins de graph view, backlinks y outgoing links para navegar la wiki visualmente.

Las otras herramientas (qmd para búsqueda, Marp para slides, Dataview para queries) son para cuando la wiki crece. A esta escala, el index.md y Obsidian bastan.

Escribiré un post sobre cómo configurar Obsidian con este patrón — el graph view, el Web Clipper, y cómo entra en el ciclo de review humano. Próximamente.

## Lo que me enseñó hacer esto

Primero: la barrera de entrada es bajísima. Markdown, un directorio, y un agente que lee y escribe. Si tienes un blog Hugo y un agente de código, tienes todo lo que necesitas.

Segundo: el valor no está en la estructura sino en los workflows. Cualquiera puede crear directorios. Lo que hace que funcione es que Pi sabe qué hacer cuando le das una fuente. Las convenciones hacen la diferencia.

Tercero: el workflow promote cambia la relación con el blog. Antes, escribir un post requería investigación desde cero. Ahora la investigación ya está hecha en la wiki. Promover es reescribir con voz de blog, no investigar desde cero.

## El primer ingest

La primera fuente que procesé fue el propio gist de Karpathy. Creó 4 archivos:

```
wiki/sources/2026-04-16-karpathy-llm-wiki.md   # resumen de la fuente
wiki/topics/llm-wiki.md                         # primera síntesis
wiki/concepts/knowledge-management.md            # concepto
wiki/concepts/rag.md                             # concepto
```

Y actualizó index.md y log.md. De una fuente salieron 6 archivos tocados. Así funciona la acumulación.

## Lo que puede salir mal

El campo `topics` en las sources solo debe referenciar topics, no concepts. Me pasó con la primera ingest — puse `knowledge-management` en topics cuando es un concept. Lo corregí, pero es el tipo de cosa que el lint debería cazar.

Los links internos son rutas relativas: `../topics/slug.md`. Si mueves un archivo, se rompen. A esta escala es manejable. A escala grande, necesitarías algo más robusto.

## Siguiente paso

Si quieres montar esto en tu propio blog Hugo, necesitas:

1. Crear el directorio `wiki/` con la subestructura
2. Escribir tu `conventions.md` (o copiar el mío y adaptarlo)
3. Añadir la sección Wiki a tu AGENTS.md
4. Hacer tu primer ingest con tu agente

Si ya tienes un skill de escritura, el workflow promote conecta automáticamente la wiki con tus posts. Si no, Pi puede crear los posts directamente — solo necesitas las convenciones del front matter en tu AGENTS.md.

El gist original de Karpathy está en [GitHub](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) y mi post sobre [el patrón LLM Wiki](/posts/2026-04-16-el-patron-llm-wiki-de-karpathy/) explica la idea de fondo. Para entender cómo Pi maneja contexto, [tu AGENTS.md](/posts/tu-agents-md-contexto-que-el-agente-entiende/) es el punto de partida.
