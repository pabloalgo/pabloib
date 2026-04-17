---
title: "Debugging TypeScript: rastreo de errores y fixes"
description: "Prompt para diagnosticar y resolver errores de TypeScript de forma sistemática. Incluye análisis de tipos, stack trace y propuesta de fix."
date: 2026-04-17
lastmod: 2026-04-17
categories: ["Prompts"]
tags: ["typescript", "debugging", "prompt", "desarrollo"]
usecase: "debugging"
models: ["claude", "gpt", "pi"]
mode: "template"
variables: ["<error>", "<stack>", "<contexto>", "<código-relacionado>"]
related_posts: []
related_prompts: []
draft: false
prompt: |
  Eres un experto en TypeScript. Analiza el siguiente error y propón una solución.

  **Error:**
  <error>

  **Stack trace:**
  <stack>

  **Contexto del proyecto:**
  <contexto>

  **Código relacionado:**
  <código-relacionado>

  Sigue este proceso:

  1. Diagnóstico: explica en lenguaje claro qué está pasando y por qué TypeScript lanza este error. No parafrasees el mensaje de error, tradúcelo a español simple.

  2. Causa raíz: identifica el archivo y la línea exacta donde se origina el problema. Si hay una cadena de errores, explica la dependencia.

  3. Fix propuesto: muestra el código corregido con los cambios mínimos necesarios. No reescribas todo el archivo, solo lo que cambia.

  4. Prevención: sugiere un patrón o configuración que evite este tipo de error en el futuro.

  Reglas:
  - Si el error es por una dependencia, indica la versión afectada y si hay una versión alternativa.
  - Si hay más de una solución, muestra la más simple primero.
  - Si el fix requiere cambiar configuración (tsconfig, build tool), muestra el cambio concreto.
---

## Cuándo usarlo

Cuando tienes un error de TypeScript que no resuelves rápido: mensajes crípticos del compilador, fallos de inferencia de tipos, o bugs en runtime que podrían estar relacionados con el sistema de tipos. Especialmente útil cuando el error cruza varios archivos o involucra generics complejos.

## Variables

| Variable | Qué poner |
|---|---|
| `<error>` | El mensaje de error completo del compilador o runtime |
| `<stack>` | El stack trace si existe (puede ir vacío si no aplica) |
| `<contexto>` | Versión de TypeScript, framework, tipo de proyecto (Node, Deno, app frontend) |
| `<código-relacionado>` | Los archivos o fragmentos de código involucrados en el error |

## Notas de uso

- Si el error está en un test, incluye el código del test además del código que testea.
- Para errores de tipos genéricos complejos, incluye las definiciones de interfaces o types relevantes.
- Si usas un framework (Next.js, Nest, etc.), menciónalo en el contexto para obtener fixes alineados con sus convenciones.
- El prompt pide el fix mínimo; si necesitas una refactorización más amplia, pídelo explícitamente en un segundo mensaje.

## Ejemplo de uso

```text
Eres un experto en TypeScript. Analiza el siguiente error y propón una solución.

**Error:**
Type 'string | undefined' is not assignable to type 'string'.
  Type 'undefined' is not assignable to type 'string'.

**Stack trace:**
src/utils/format.ts:12:5 - error TS2322

**Contexto del proyecto:**
TypeScript 5.4, Next.js 14 App Router, strict mode habilitado

**Código relacionado:**
function formatUser(user: { name?: string }): string {
  return user.name; // error aquí
}

Sigue este proceso:
[... resto del prompt]
```
