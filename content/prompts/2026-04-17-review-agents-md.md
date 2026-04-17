---
title: "Auditar y mejorar un AGENTS.md"
description: "Prompt para revisar, auditar y mejorar archivos AGENTS.md de proyectos que usan agentes de IA. Detecta gaps, inconsistencias y mejoras de estructura."
date: 2026-04-17
lastmod: 2026-04-17
categories: ["Prompts"]
tags: ["agentes", "prompt", "revisión", "productividad"]
usecase: "review"
models: ["claude", "gpt", "pi"]
mode: "template"
variables: ["<agents-md>", "<contexto-proyecto>", "<herramienta-agente>"]
related_posts: []
related_prompts: []
draft: false
prompt: |
  Eres un experto en configuración de agentes de IA para proyectos de software. Analiza el siguiente archivo de instrucciones de agente y propón mejoras concretas.

  **Archivo a auditar:**
  <agents-md>

  **Contexto del proyecto:**
  <contexto-proyecto>

  **Herramienta/agente utilizado:**
  <herramienta-agente>

  Realiza una auditoría completa:

  1. **Completitud:** Verifica si cubre los puntos esenciales:
     - Stack tecnológico con versiones
     - Comandos de desarrollo, build, test, deploy
     - Estructura de archivos relevante
     - Convenciones de código (naming, estilo, patrones)
     - Restricciones y reglas de seguridad
     - Flujo de trabajo con git (branching, commits, PRs)

  2. **Claridad:** Identifica instrucciones ambiguas que un agente podría interpretar de formas distintas. Sugiere reformulaciones precisas.

  3. **Conflictos:** Detecta instrucciones contradictorias o que se pisan entre sí.

  4. **Ruido:** Señala instrucciones obsoletas, redundantes o que no aportan valor al agente.

  5. **Jerarquía:** Evalúa si el orden de las secciones ayuda al agente a priorizar o si las más importantes están enterradas.

  6. **Formato:** Sugiere mejoras de formato para que el agente parseé mejor las instrucciones (markdown limpio, listas numeradas, bloques de código para ejemplos).

  Entrega:
  - Lista de problemas encontrados con severidad (crítico, importante, menor)
  - Versión mejorada del archivo completo
  - Resumen de los cambios principales
---

## Cuándo usarlo

Cuando tienes un archivo `AGENTS.md` (o `CLAUDE.md`, `.cursorrules`, etc.) que quieres auditar. Útil antes de onboarding de nuevos agentes, tras cambios de arquitectura, o cuando notas que el agente ignora instrucciones que creías haber documentado.

## Variables

| Variable | Qué poner |
|---|---|
| `<agents-md>` | El contenido completo del archivo AGENTS.md |
| `<contexto-proyecto>` | Lenguaje, framework, tipo de proyecto, tamaño del equipo |
| `<herramienta-agente>` | Pi, Claude Code, Cursor, Copilot, u otro agente |

## Notas de uso

- Si el archivo es muy largo, puedes pedir que el análisis se centre en secciones específicas.
- Este prompt está optimizado para Claude y GPT-4; con modelos más pequeños, puede ser necesario simplificar las secciones de análisis.
- La "versión mejorada" que genera es un punto de partida, no un reemplazo directo. Revísala antes de aplicar.
- Si usas un sistema con múltiples archivos de instrucciones (como Pi con `.pi/`), incluye la ruta relativa de cada archivo para que el agente entienda la jerarquía.

## Ejemplo de uso

```text
Eres un experto en configuración de agentes de IA para proyectos de software. Analiza el siguiente archivo de instrucciones de agente y propón mejoras concretas.

**Archivo a auditar:**
# AGENTS.md
## Stack
Hugo v0.159.2, Tailwind CSS v3.4
## Comandos
npm run dev, npm run build
## Reglas
No editar themes/paper/
[... resto del archivo]

**Contexto del proyecto:**
Blog estático Hugo desplegado en Cloudflare Pages. Un solo mantenedor. Usa Pi como agente.

**Herramienta/agente utilizado:**
Pi (pi-coding-agent)

[... resto del prompt]
```
