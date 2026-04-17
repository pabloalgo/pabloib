---
title: "Estructurar un post técnico en español"
description: "Prompt para planificar y estructurar artículos técnicos en español con buena narrativa, SEO y escaneabilidad. Desde el outline hasta el borrador completo."
date: 2026-04-17
lastmod: 2026-04-17
categories: ["Prompts"]
tags: ["escritura", "prompt", "blog", "seo"]
usecase: "writing"
models: ["claude", "gpt", "pi"]
mode: "template"
variables: ["<tema>", "<audiencia>", "<objetivo>", "<referencias>"]
related_posts: []
related_prompts: []
draft: false
prompt: |
  Eres un editor técnico experto en contenido en español. Ayúdame a estructurar un post técnico completo.

  **Tema:**
  <tema>

  **Audiencia:**
  <audiencia>

  **Objetivo del artículo:**
  <objetivo>

  **Referencias o contexto adicional:**
  <referencias>

  Sigue este proceso:

  1. **Propuesta de título:** Sugiere 3 opciones de título. Uno directo, uno con gancho, y uno optimizado para SEO. Máximo 60 caracteres cada uno.

  2. **Descripción SEO:** Escribe una descripción de máximo 160 caracteres que sirva para meta description y claramente indique qué va a aprender el lector.

  3. **Outline detallado:** Crea un índice con:
     - Introducción que plantee el problema o necesidad
     - Secciones lógicas progresivas (de lo general a lo específico)
     - Ejemplos de código donde aplique (indica lenguaje)
     - Subsecciones dentro de cada sección principal
     - Conclusión con próximos pasos o reflexión práctica

  4. **Notas de tono y estilo:**
     - Español neutro, técnico pero accesible
     - Segunda persona del plural (vosotros) o directa (tú), consistente
     - Párrafos cortos (máximo 4 líneas)
     - Ejemplos concretos antes de explicaciones abstractas
     - Evitar anglicismos innecesarios (usar "archivo" no "fichero" cuando proceda, pero mantener términos técnicos estándar como "deploy", "build" si están consolidados)

  5. **Estimación:** Número estimado de palabras y tiempo de lectura.

  Entrega primero el outline para que lo valide. Después generarás el borrador completo sección por sección cuando te lo pida.
---

## Cuándo usarlo

Cuando quieres escribir un artículo técnico en español y necesitas una estructura sólida antes de empezar a redactar. Especialmente útil para posts de blog, guías o tutoriales donde el contenido técnico necesita estar bien organizado sin sacrificar la narrativa.

## Variables

| Variable | Qué poner |
|---|---|
| `<tema>` | El tema concreto del artículo |
| `<audiencia>` | Nivel técnico de los lectores (junior, mid, senior, generalista) |
| `<objetivo>` | Qué debe poder hacer el lector tras leer el artículo |
| `<referencias>` | Links, docs, o contexto adicional relevante |

## Notas de uso

- El prompt genera primero el outline y espera tu validación. Esto es intencional: te da control antes de generar el contenido completo.
- Para artículos de opinión, quita la sección de "Ejemplos de código" y añade "Argumentos a favor y en contra".
- Para tutoriales paso a paso, especifica "formato tutorial" en el objetivo para que el outline tenga numeración clara.
- Si tu blog tiene convenciones específicas (front matter, longitud de párrafos, uso de imágenes), añádelas en "referencias".
- El prompt pide estimación de longitud: útil para planificar si el post encaja en tu calendario editorial.

## Ejemplo de uso

```text
Eres un editor técnico experto en contenido en español. Ayúdame a estructurar un post técnico completo.

**Tema:**
Cómo configurar un agente de código con Pi para un proyecto Hugo existente

**Audiencia:**
Desarrolladores que ya usan Hugo y quieren integrar Pi como asistente de código. Nivel mid-senior.

**Objetivo del artículo:**
Que el lector pueda configurar Pi en su proyecto Hugo en menos de 30 minutos, entendiendo cada archivo de configuración.

**Referencias:**
- Blog personal en Hugo v0.159.2 con tema Paper
- Deploy en Cloudflare Pages
- CSP estricta, sin inline scripts

[... resto del prompt]
```
