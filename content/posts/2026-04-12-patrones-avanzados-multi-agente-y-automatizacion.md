---
title: "Patrones avanzados — Multi-agente y automatización"
description: "Los 5 patrones agentic principales de Pi: orquestación multi-agente, subagentes con contexto aislado, automatización y el SDK para integración programática."
date: 2026-04-12
lastmod: 2026-04-12
categories: ["Pi"]
tags: ["pi", "multi-agente", "automatización", "sdk", "avanzado"]
mode: guide
draft: false
---Pi es minimalista en su core, pero poderoso en sus modos de uso. Más allá de la sesión interactiva, puedes orquestar múltiples agentes, automatizar tareas, y embeber Pi en tus propias aplicaciones. Este artículo cubre los 5 patrones agentic principales, subagentes, y el SDK para integración programática.

---

## Los 5 patrones agentic

La investigación en agentes de IA ha identificado patrones recurrentes. Pi los soporta todos, pero no los impone. Tú eliges.

### Patrón 1: ReAct (por defecto)

El modo estándar. El modelo **razona, actúa (usa tools), observa el resultado, y razona de nuevo**. No requiere configuración.

```
Usuario: "Corrige el bug en auth"

Pi: [Razona] Veo que el error está en la validación del token.
    [Actúa]  → tool: read("src/auth/validate.ts")
    [Observa] El archivo muestra que la regex expira con timestamps...
    [Razona] El bug es que no maneja tokens expirados.
    [Actúa]  → tool: edit("src/auth/validate.ts", añadir check de expiración)
    [Actúa]  → tool: bash("npm test")
    [Observa] Tests pasando ✅
    [Razona] Bug corregido y verificado.
```

**Cuándo usarlo:** El 90% de las veces. Tareas normales de desarrollo.

### Patrón 2: Plan-and-Execute

Para tareas complejas y bien definidas. **Primero generas un plan, luego lo ejecutas paso a paso.** Investigación muestra 92% de completitud y 3.6x speedup vs ReAct secuencial.

```
Usuario: "Migra toda la app de JavaScript a TypeScript"

Pi: [Fase 1: Plan]
    1. Instalar TypeScript y configurar tsconfig.json
    2. Migrar types/interfaces primero
    3. Migrar utils/ (sin dependencias internas)
    4. Migrar services/ (dependen de utils)
    5. Migrar routes/ (dependen de services)
    6. Actualizar tests
    7. Verificar con `tsc --noEmit`

    [Fase 2: Ejecutar paso a paso]
    Paso 1... ✅
    Paso 2... ✅
    Paso 3... ✅
    ...
```

**Cómo activarlo:** Simplemente pídelo:

```
> Primero haz un plan detallado para migrar a TypeScript,
  luego ejecútalo paso a paso. Confirma conmigo antes de
  empezar cada paso.
```

### Patrón 3: Multi-agente (Orquestador + Especialistas)

Diferentes agentes con diferente contexto, modelo y capacidades. Cada uno tiene su **propia ventana de contexto aislada**.

```
                    ┌─────────────┐
                    │ Orquestador │  ← Agente principal (tú)
                    └──────┬──────┘
                           │ delega
              ┌────────────┼────────────┐
              ▼            ▼            ▼
        ┌──────────┐ ┌──────────┐ ┌──────────┐
        │  Scout   │ │ Planner  │ │  Worker  │
        │  (Haiku) │ │ (Sonnet) │ │ (Sonnet) │
        │ read only│ │ read only│ │ all tools │
        └──────────┘ └──────────┘ └──────────┘
```

**Cuándo usarlo:** Proyectos grandes, tareas que necesitan diferentes niveles de razonamiento, o cuando quieres paralelizar.

### Patrón 4: Reflexión

Un agente especialista **revisa el trabajo del agente principal** antes de presentarlo.

```
> Implementa rate limiting en la API

Pi Worker: [implementa rate limiting]

> Ahora usa el reviewer para verificar la implementación

Pi Reviewer: [lee el código, encuentra un edge case
  con rate limiting en WebSockets, sugiere fix]

Pi Worker: [corrige el edge case]
```

**Cuándo usarlo:** Código crítico, cambios en producción, o cuando quieres una segunda opinión.

### Patrón 5: Dynamic Tool Loading

Cuando tienes 50+ tools, cargarlos todos degrada la precisión del modelo. La solución: **cargar tools progresivamente** según la tarea.

Pi ya implementa esto con skills (progressive disclosure). Las extensiones pueden añadir tools adicionales que solo se activan cuando la skill correspondiente se carga.

**Cuándo usarlo:** Proyectos con muchas integraciones (MCP servers, APIs externas, herramientas específicas).

---

## Subagentes: contexto aislado

El ejemplo de subagente incluido en Pi demuestra el patrón multi-agente más potente. Cada subagente:

- Corre en un **proceso `pi` separado** con su propio contexto
- Tiene un **modelo dedicado** (ej: Haiku para scout, Sonnet para worker)
- Usa **tools específicos** (ej: solo lectura para scout, todos para worker)
- Se define en un **archivo markdown** simple

### Definir un agente

```markdown
<!-- ~/.pi/agent/agents/scout.md -->
---
name: scout
description: Fast codebase recon that returns compressed context
tools: read, grep, find, ls, bash
model: claude-haiku-4-5
---

You are a scout. Quickly investigate a codebase and return
structured findings for another agent.

Strategy:
1. grep/find to locate relevant code
2. Read key sections (not entire files)
3. Identify types, interfaces, key functions
4. Note dependencies between files

Output format:

## Files Retrieved
1. `path/to/file.ts` (lines 10-50) - Description

## Key Code
Critical types and functions

## Architecture
How the pieces connect

## Start Here
Which file to look at first and why.
```

### Agentes de ejemplo

| Agente | Modelo | Tools | Rol |
|---|---|---|---|
| **Scout** | Haiku (rápido/barato) | Solo lectura | Explorar codebase rápido |
| **Planner** | Sonnet (razonamiento) | Solo lectura | Crear planes de implementación |
| **Worker** | Sonnet (razonamiento) | Todos | Implementar cambios |
| **Reviewer** | Sonnet (razonamiento) | Lectura + bash | Revisar código |

### Modos de ejecución

**Un solo agente:**

```
> Usa scout para encontrar todo el código de autenticación
```

**Paralelo (múltiples agentes simultáneamente):**

```
> Ejecuta 2 scouts en paralelo: uno busca modelos,
  otro busca providers
```

**Encadenado (output de uno → input del siguiente):**

```
> Cadena: scout encuentra el código de auth,
  luego planner sugiere mejoras,
  luego worker las implementa
```

### Prompts de flujo predefinidos

El ejemplo de subagente trae prompts para flujos comunes:

| Comando | Flujo |
|---|---|
| `/implement <tarea>` | scout → planner → worker |
| `/scout-and-plan <tarea>` | scout → planner |
| `/implement-and-review <tarea>` | worker → reviewer → worker |

```
/implement añadir caché Redis al session store
```

Esto ejecuta automáticamente:
1. Scout explora el código del session store
2. Planner diseña la integración con Redis
3. Worker implementa el plan

---

## `pi -p`: Automatización en scripts

El modo print (`-p`) ejecuta un prompt y devuelve la respuesta sin interacción. Ideal para scripts y pipelines.

### Uso básico

```bash
# Un solo prompt
pi -p "¿Qué framework usa este proyecto?"

# Con provider/modelo específico
pi -p --model gpt-4o "Resume los cambios del último commit"

# Pipe de stdin
cat README.md | pi -p "Resume este texto en 3 bullets"
git diff | pi -p "Explica estos cambios"
```

### Scripts de automatización

**Generar changelog:**

```bash
#!/bin/bash
# generate-changelog.sh
git log --oneline $1..HEAD | pi -p "Genera un changelog en markdown a partir de estos commits. Agrupa por tipo (feat, fix, refactor, etc)."
```

**Review automático de PR:**

```bash
#!/bin/bash
# review-pr.sh
git diff main...$1 | pi -p "Revisa estos cambios como un senior developer. Identifica bugs potenciales, problemas de seguridad y mejoras de rendimiento."
```

**Documentar una función:**

```bash
#!/bin/bash
# doc-function.sh
cat "$1" | pi -p "Genera documentación JSDoc para todas las funciones exportadas en este archivo. Incluye @param, @returns y @example."
```

**Pipeline CI/CD:**

```bash
#!/bin/bash
# pre-commit review
STAGED=$(git diff --cached --name-only)
if [ -n "$STAGED" ]; then
  git diff --cached | pi -p "¿Hay algo peligroso en estos cambios staged? Responde solo: SAFE o UNSAFE con una línea de explicación."
fi
```

### Modo JSON

Para integración programática sin SDK:

```bash
pi --mode json -p "Lista los archivos del proyecto"
```

Devuelve eventos como JSON lines — ideal para parsing en scripts Python, Node.js, etc.

---

## El SDK: Pi como librería

Pi no es solo una CLI. Puedes importarlo como librería en cualquier aplicación Node.js.

### Instalación

```bash
npm install @mariozechner/pi-coding-agent
```

### Uso mínimo

```typescript
import { createAgentSession } from "@mariozechner/pi-coding-agent";

const { session } = await createAgentSession();

// Escuchar la respuesta
session.subscribe((event) => {
  if (event.type === "message_update" &&
      event.assistantMessageEvent.type === "text_delta") {
    process.stdout.write(event.assistantMessageEvent.delta);
  }
});

// Enviar un prompt
await session.prompt("What files are in the current directory?");
```

### Configuración custom

```typescript
import {
  createAgentSession,
  SessionManager,
  createCodingTools,
} from "@mariozechner/pi-coding-agent";

const { session } = await createAgentSession({
  cwd: "/path/to/project",
  tools: createCodingTools("/path/to/project"),
  sessionManager: SessionManager.inMemory(),
});
```

### Modo solo lectura

Para sesiones de revisión sin riesgo de modificar nada:

```typescript
import { createAgentSession, readOnlyTools } from "@mariozechner/pi-coding-agent";

const { session } = await createAgentSession({
  tools: readOnlyTools, // Solo read, grep, find, ls — sin write/edit
});
```

### Steering y Follow-up

Durante streaming, puedes redirigir o añadir mensajes:

```typescript
// Redirigir: interrumpe y cambia de dirección
await session.steer("En realidad, enfócate solo en los tests");

// Follow-up: espera a que termine y luego procesa
await session.followUp("Después, actualiza la documentación");
```

### Suscribirse a eventos

```typescript
session.subscribe((event) => {
  switch (event.type) {
    case "tool_execution_start":
      console.log(`Tool: ${event.toolName}`);
      break;
    case "tool_execution_end":
      console.log(`Resultado: ${event.isError ? "error" : "ok"}`);
      break;
    case "agent_end":
      console.log("Agente terminó");
      break;
  }
});
```

### Caso real: OpenClaw

[OpenClaw](https://github.com/openclaw/openclaw) — el asistente personal de IA con 250k+ estrellas en GitHub — usa el SDK de Pi exactamente así:

```typescript
// Simplificado del código real de OpenClaw
import { createAgentSession } from "@mariozechner/pi-coding-agent";

// Cada canal (WhatsApp, Telegram, etc.) tiene su sesión aislada
const { session } = await createAgentSession({
  sessionManager: SessionManager.create(channelId),
});

session.subscribe((event) => {
  if (event.type === "agent_end") {
    // Enviar respuesta al canal de mensajería
    sendToChannel(channelId, event.messages);
  }
});

await session.prompt(userMessage);
```

---

## Comparativa de los 4 modos de Pi

| Modo | Comando | Caso de uso |
|---|---|---|
| **Interactivo** | `pi` | Desarrollo diario |
| **Print** | `pi -p "..."` | Scripts, automatización, CI/CD |
| **JSON** | `pi --mode json` | Integración con otros programas |
| **SDK** | `import { createAgentSession }` | Aplicaciones custom, UIs, bots |

---

## Flujos de trabajo recomendados

### Para desarrollo diario

```
pi                    # Sesión interactiva
pi -c                 # Continuar ayer
/tree                 # Volver a un punto anterior
```

### Para code review

```
pi --readonly         # Sin riesgo de modificar
"Revisa el código de auth y busca vulnerabilidades"
```

### Para tareas grandes

```
/implement refactorizar API a REST v2
# → scout explora, planner diseña, worker implementa
```

### Para automatización

```bash
# Pre-commit hook
git diff --cached | pi -p "¿Es seguro hacer commit de esto?"

# CI pipeline
pi -p "Analiza los cambios de este PR y genera un resumen técnico"
```

### Para integración

```typescript
// Tu app custom
const { session } = await createAgentSession();
await session.prompt("Analiza el log de errores y sugiere fixes");
```

---


1. **ReAct** es el patrón por defecto — funciona para el 90% de tareas
2. **Plan-and-Execute** para tareas complejas — primero plan, luego ejecución paso a paso
3. **Multi-agente** para proyectos grandes — agentes especializados con contexto aislado
4. **`pi -p`** para scripts — automatiza reviews, changelogs, documentación
5. **SDK** para integración — embebe Pi en tu aplicación como una librería
6. **Subagentes** son la forma más potente — scout/planner/worker/reviewer con modelos y tools dedicados
7. Los 4 modos (interactivo, print, JSON, SDK) cubren desde uso casual hasta integración enterprise

---

## 🔗 Recursos

- [Gestión de contexto y sesiones](/posts/2026-04-12-gestion-de-contexto-y-sesiones/) — Artículo anterior de esta serie
- [Documentación del SDK](https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/sdk.md) — Referencia completa
- [Ejemplos del SDK](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent/examples/sdk) — 13 ejemplos de código
- [Ejemplo de subagentes](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent/examples/extensions/subagent) — Implementación de referencia
- [OpenClaw](https://github.com/openclaw/openclaw) — Caso real del SDK en producción
- [Pi desde cero — Instalación y primera sesión](/posts/2026-04-12-pi-desde-cero-instalacion-y-primera-sesion/) — Artículo 1 de esta serie
