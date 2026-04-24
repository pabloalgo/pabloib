---
title: "Gestión de contexto y sesiones"
description: "El contexto es el recurso más valioso con agentes de IA. Pi tiene compaction automática, sesiones en árbol y navegación temporal para mantener la productividad."
date: 2026-04-12
lastmod: 2026-04-16
categories: ["Pi"]
tags: ["pi", "contexto", "sesiones", "compaction", "intermedio"]
mode: guide
draft: false
---

El contexto es el recurso más valioso cuando trabajas con agentes de IA. Pi tiene mecanismos sofisticados para gestionarlo: compaction automática, sesiones con estructura de árbol, y navegación temporal. Entender cómo funciona te permite mantener sesiones productivas durante horas sin degradación.

---

## El problema del contexto finito

Los modelos de lenguaje tienen una ventana de contexto fija. Pi usa esa ventana para:

```
┌──────────────────────────────────────┐
│ System prompt (~100 tokens)          │
│ Tool definitions (~900 tokens)       │
│ AGENTS.md (variable)                 │
│ Skills metadata (~100 tokens c/u)    │
│                                      │
│ ┌── Conversation history ──────────┐ │
│ │ Tu primer mensaje                │ │
│ │ Respuesta de Pi                  │ │
│ │ Tool: bash → resultado           │ │
│ │ Tool: read → 2000 líneas...      │ │
│ │ Respuesta de Pi                  │ │
│ │ Tu segundo mensaje               │ │
│ │ Tool: edit → resultado           │ │
│ │ ... y sigue creciendo ...        │ │
│ └──────────────────────────────────┘ │
└──────────────────────────────────────┘
    ↑
    Total: 200k tokens (típico)
```

**Cada tool call y su resultado consume tokens.** Un `read` de un archivo largo puede consumir miles de tokens. Una sesión de 2 horas puede llegar a 150k+ tokens.

Cuando te acercas al límite, la calidad del modelo decae. Empieza a "olvidar" cosas dichas antes. Es como una persona cansada: sigue funcionando, pero pierde detalles.

---

## Compaction: resumir para seguir

Pi resuelve esto con **compaction**: resume automáticamente los mensajes antiguos y conserva los recientes.

### Cómo funciona

```
Antes de compaction:

  entry:  0     1     2     3      4     5     6      7      8     9
        ┌─────┬─────┬─────┬─────┬──────┬─────┬─────┬──────┬──────┬─────┐
        │ hdr │ usr │ ass │ tool │ usr │ ass │ tool │ tool │ ass │ tool│
        └─────┴─────┴─────┴──────┴─────┴─────┴──────┴──────┴─────┴─────┘
                └────────┬───────┘ └──────────────┬──────────────┘
               a resumir                mensajes recientes (se conservan)
                                   ↑
                          firstKeptEntryId

Después de compaction:

  entry:  0     1     2     3      4     5     6      7      8     9     10
        ┌─────┬─────┬─────┬─────┬──────┬─────┬─────┬──────┬──────┬─────┬─────┐
        │ hdr │ usr │ ass │ tool │ usr │ ass │ tool │ tool │ ass │ tool│ cmp │
        └─────┴─────┴─────┴──────┴─────┴─────┴──────┴──────┴─────┴─────┴─────┘
               └──────────┬──────┘ └──────────────────────┬───────────────────┘
                 no se envía al LLM                se envía al LLM

Lo que el LLM ve:

  ┌────────┬─────────┬─────┬─────┬──────┬──────┬─────┬──────┐
  │ system │ summary │ usr │ ass │ tool │ tool │ ass │ tool │
  └────────┴─────────┴─────┴─────┴──────┴──────┴─────┴──────┘
       ↑         ↑      └─────────────────┬────────────────┘
    prompt   resumen               mensajes conservados
```

El proceso:
1. **Encontrar punto de corte** — camina hacia atrás desde el último mensaje hasta consumir `keepRecentTokens` (default: 20k)
2. **Extraer mensajes** — recolecta todo lo anterior al punto de corte
3. **Generar resumen** — llama a un LLM para crear un resumen estructurado
4. **Recargar sesión** — ahora el LLM ve: system prompt + resumen + mensajes recientes

### Formato del resumen

Pi genera resúmenes estructurados, no texto libre:

```markdown
## Goal
Refactorizar el módulo de autenticación a TypeScript

## Constraints & Preferences
- TypeScript strict mode
- Tests con Vitest
- No cambiar la API pública

## Progress
### Done
- [x] Migrar types/interfaces a TypeScript
- [x] Crear middleware de autenticación tipado

### In Progress
- [ ] Migrar service layer

### Blocked
- Dependencia circular con el módulo de usuarios

## Key Decisions
- **Usar Zod para validación**: Mejor integración con TypeScript

## Next Steps
1. Resolver dependencia circular
2. Migrar service layer
3. Añadir tests

## Critical Context
- Archivo principal: src/auth/service.ts
- Dependencia: src/users/service.ts (importar tipo User)
```

### Compaction automática vs manual

| Tipo | Trigger | Cuándo |
|---|---|---|
| **Automática** | `contextTokens > contextWindow - reserveTokens` | Proactivo (antes de llenarse) o recovery (después de overflow) |
| **Manual** | `/compact` o `/compact instrucciones custom` | Cuando tú decides |

**Compaction manual con foco:**

```
/compact Enfócate solo en los cambios del módulo de auth,
  descarta las exploraciones de logging que no usamos
```

Las instrucciones custom dirigen el resumen hacia lo que te importa.

### Configurar compaction

En `settings.json`:

```json
{
  "compaction": {
    "enabled": true,
    "reserveTokens": 16384,
    "keepRecentTokens": 20000
  }
}
```

| Parámetro | Default | Qué hace |
|---|---|---|
| `enabled` | `true` | Activar/desactivar compaction automática |
| `reserveTokens` | `16384` | Tokens reservados para la respuesta del LLM |
| `keepRecentTokens` | `20000` | Tokens recientes que NO se resumen |

**¿Cuándo ajustar?**

- Si Pi compacta demasiado pronto → aumenta `reserveTokens` o `keepRecentTokens`
- Si la sesión crece sin control → disminuye `keepRecentTokens`
- Si prefieres control total → `enabled: false` y usa `/compact` manualmente

> 💡 **Tip:** La compaction es **con pérdida**. El resumen es una síntesis, no una copia. Pero la historia completa sigue en el archivo JSONL — puedes acceder a ella con `/tree`.

---

## Sesiones: árboles, no listas

Las sesiones de Pi no son una lista plana de mensajes. Son **árboles JSONL** donde cada entrada tiene un `id` y un `parentId`:

```
         ┌─ B ─ C ─ D (rama: intento con Express)
    A ───┤
         └─ E ─ F (rama: intento con Fastify) ── G (solución final)
```

Esto permite **branching sin crear archivos nuevos**. Todo coexiste en un solo archivo de sesión.

### Comandos de sesión

| Comando | Qué hace |
|---|---|
| `pi` | Nueva sesión interactiva |
| `pi -c` | Continuar la sesión más reciente |
| `pi -r` | Buscar y seleccionar sesiones pasadas |
| `pi --no-session` | Sesión efímera (no se guarda) |
| `/new` | Nueva sesión desde cero |
| `/resume` | Cambiar a otra sesión |
| `/session` | Info de la sesión actual (tokens, costo) |
| `/name nombre` | Nombre para la sesión |

### `/tree` — Navegación temporal

`/tree` abre una vista del árbol de la sesión. Puedes:

- **Navegar** a cualquier punto anterior y continuar desde ahí
- **Buscar** escribiendo texto
- **Cambiar entre ramas** con `Ctrl+←/→`
- **Filtrar** con `Ctrl+O` (ocultar tools, solo usuario, etc.)
- **Etiquetar** con `Shift+L` para marcar puntos importantes

```
> /tree

  ● A  "Necesito refactorizar auth"
  ├─● B  "Usando Express..."
  │ └─● C  "No me gusta, probemos otra cosa"
  └─● D  "Usando Fastify..."
    └─● E  "Perfecto" ← current
```

Si navegas al nodo D y escribes un mensaje, se crea una nueva rama. **A y D se preservan**.

### `/fork` — Crear un archivo nuevo

A diferencia de `/tree` (que ramifica en el mismo archivo), `/fork` crea un archivo de sesión completamente nuevo:

```
> /fork
```

Abre un selector. Eliges hasta dónde copiar. El mensaje elegido se coloca en el editor para modificarlo antes de enviar.

### Branch summarization

Cuando navegas con `/tree` de una rama a otra, Pi te ofrece **generar un resumen** de la rama que abandonas:

```
         ┌─ B ─ C ─ D ─ [resumen de B,C,D]
    A ───┤
         └─ E ─ F (nueva posición)
```

Esto inyecta contexto de la rama anterior en la nueva, para que Pi "recuerde" qué se intentó antes.

Configurable:

```json
{
  "branchSummary": {
    "reserveTokens": 16384,
    "skipPrompt": false
  }
}
```

---

## Patrones para sesiones largas

### Patrón 1: Investigación + Implementación

```
Sesión 1: "Analiza esta codebase y diseña la solución"
  → Investiga, lee archivos, genera plan
  → /compact Enfócate en el plan de implementación

Sesión 2 (pi -c): "Implementa el plan"
  → Pi tiene el resumen del plan, implementa
  → Más limpio que una sola sesión larguísima
```

### Patrón 2: Branching para experimentar

```
> Refactoriza auth a use cases

Pi: [implementa con patrón A]

> /tree    ← volver al punto antes de implementar

> Refactoriza auth usando servicios en vez de use cases

Pi: [implementa con patrón B]

> Compara los dos enfoques
```

Cada intento vive en su propia rama. No pierdes nada.

### Patrón 3: Compaction estratégica

```
> Analiza los logs de producción y encuentra el bug
  [Pi lee 10 archivos de logs, tools results enormes]

/compact Enfócate en el root cause y los archivos relevantes.
  Descarta los logs que no tienen errores.

> Ahora corrige el bug
  [Pi tiene el resumen conciso, no los 10 archivos de logs]
```

### Patrón 4: Fork para sesiones paralelas

```bash
# Sesión de feature
pi --name "feat-payments"

# Fork para investigar un bug sin perder contexto
# Desde Pi: /fork → elegir punto → nueva sesión

# Volver a la sesión original
pi -r  # seleccionar "feat-payments"
```

---

## La economía del contexto

Cada token de contexto tiene costo: **dinero** (facturación por token) y **calidad** (más contexto ≠ mejor respuesta, después de cierto punto).

### Qué consume más tokens

| Acción | Tokens típicos |
|---|---|
| Mensaje del usuario | 50-500 |
| Respuesta de Pi (sin tools) | 200-2,000 |
| `bash` con output largo | 500-5,000 |
| `read` de archivo grande | 1,000-10,000 |
| `edit` de un archivo | 100-500 |
| Resumen de compaction | 300-800 |

### Estrategias de ahorro

1. **Sé específico desde el inicio** — menos iteraciones = menos tokens
2. **No pidas leer todo** — "Lee solo las funciones exportadas de auth.ts"
3. **Compacta después de investigar** — `/compact` tras leer muchos archivos
4. **Usa ramas** — `/tree` para explorar sin contaminar la línea principal
5. **Divide en sesiones** — no hagas todo en una sesión de 4 horas

---

## Recuperar información después de compaction

La compaction resume, pero **no borra**. El archivo JSONL mantiene toda la historia:

```bash
# Las sesiones se guardan en:
ls ~/.pi/agent/sessions/

# Exportar una sesión completa a HTML
# Desde Pi:
/export mi-sesion.html

# O compartir como gist:
/share
```

Con `/tree` puedes navegar a cualquier punto de la historia, incluyendo mensajes que fueron compactados.

---

## Comandos esenciales de contexto

| Comando | Qué hace | Cuándo usarlo |
|---|---|---|
| `/compact` | Compactar contexto ahora | Después de investigación, antes de implementar |
| `/compact enfócate en X` | Compactar con instrucciones | Para dirigir qué se conserva |
| `/tree` | Navegar el árbol de sesión | Volver a un punto anterior, explorar ramas |
| `/fork` | Crear nueva sesión desde la actual | Dividir trabajo, experimentar |
| `/session` | Ver info (tokens, costo) | Monitorear consumo |
| `/new` | Sesión nueva | Empezar de cero |
| `/resume` | Cambiar a otra sesión | Alternar entre tareas |
| `/export` | Exportar a HTML | Documentar, revisar |
| `pi -c` | Continuar última sesión | Retomar trabajo |

---


1. **El contexto es finito** — Pi lo gestiona con compaction automática
2. **Compaction resume lo antiguo** y conserva los últimos ~20k tokens
3. **Es configurable** — `reserveTokens` y `keepRecentTokens` en settings.json
4. **Las sesiones son árboles** — no listas, permitiendo branches sin perder historia
5. **`/tree` para navegar**, `/fork` para dividir, `/compact` para optimizar
6. **La historia completa sobrevive** en el JSONL, incluso después de compaction
7. **Sé estratégico** — compacta después de investigar, usa branches para experimentar

---

## 🔗 Recursos

- [Extensiones — Pi que se programa a sí mismo](/posts/2026-04-12-extensiones-pi-que-se-programa-a-si-mismo/) — Artículo anterior de esta serie
- [Patrones avanzados — Multi-agente y automatización](/posts/2026-04-12-patrones-avanzados-multi-agente-y-automatizacion/) — Siguiente artículo de esta serie
- [Documentación de compaction](https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/compaction.md) — Detalles internos
- [Documentación de sesiones](https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/session.md) — Formato JSONL
