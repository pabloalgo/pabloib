---
title: "Extensiones — Pi que se programa a sí mismo"
description: "Las skills dan instrucciones a Pi. Las extensiones le dan código ejecutable: módulos TypeScript que registran tools, interceptan llamadas y crean componentes UI."
date: 2026-04-12
categories: ["Pi"]
tags: ["pi", "extensiones", "typescript", "personalización", "intermedio"]
readingTime: 13
draft: false
---


**Publicado:** 2026-04-12 | **Categoría:** Pi | **Lectura:** 13 min

Las skills le dan instrucciones a Pi. Las extensiones le dan **código ejecutable**. Son módulos TypeScript que pueden registrar tools custom, interceptar llamadas, modificar el contexto, y crear componentes en la UI. Y la parte más alucinante: Pi puede escribir sus propias extensiones, recargarlas, y probarlas. Todo en vivo.

---

## 🎯 Lo que aprenderás

- Qué son las extensiones y cómo se diferencian de las skills
- El sistema jiti: TypeScript sin build step
- Estructura de una extensión y sus estilos
- Escribir tu primera extensión paso a paso
- El paradigma self-extension: Pi escribe extensiones para sí mismo
- Extensiones populares que vale la pena instalar

---

## Skills vs Extensiones: ¿Cuándo usar cuál?

| | Skills | Extensiones |
|---|---|---|
| **Formato** | Markdown (SKILL.md) | TypeScript (.ts) |
| **Qué hace** | Da instrucciones al modelo | Ejecuta código real |
| **Puede** | Guiar comportamiento, definir pasos | Registrar tools, interceptar eventos, crear UI |
| **No puede** | Ejecutar código, interceptar llamadas | — (puede hacer todo) |
| **Complejidad** | Baja | Media-alta |
| **Recarga** | `/reload` | `/reload` (hot-reload) |
| **Cuándo usar** | Flujos de trabajo, convenciones | Automatización, integraciones, tools custom |

**Regla práctica:** Si puedes describirlo en texto, usa una skill. Si necesitas ejecutar código o interceptar eventos, usa una extensión.

---

## jiti: TypeScript sin compilación

Las extensiones de Pi se cargan con [jiti](https://github.com/unjs/jiti), un transpiler runtime que permite escribir TypeScript **sin paso de compilación**.

Esto significa:

1. Creas un archivo `.ts`
2. Lo guardas en `~/.pi/agent/extensions/`
3. Escribes `/reload` en Pi
4. **Tu extensión está viva**

Sin `tsc`. Sin `npm run build`. Sin webpack. El archivo `.ts` se transpila y ejecuta directamente.

> 💡 **Hot-reload:** Edita el archivo `.ts`, escribe `/reload`, y los cambios están activos inmediatamente. Incluso puedes pedirle a Pi que edite sus propias extensiones y las recargue.

---

## Dónde viven las extensiones

| Ubicación | Alcance |
|---|---|
| `~/.pi/agent/extensions/*.ts` | Global (todos los proyectos) |
| `~/.pi/agent/extensions/*/index.ts` | Global (subdirectorio) |
| `.pi/extensions/*.ts` | Proyecto local |
| `.pi/extensions/*/index.ts` | Proyecto local (subdirectorio) |
| Paquetes npm/git | Variable |

### Tres estilos de organización

**Archivo único** — para extensiones pequeñas:

```
~/.pi/agent/extensions/
└── my-extension.ts
```

**Directorio con index.ts** — para extensiones multi-archivo:

```
~/.pi/agent/extensions/
└── my-extension/
    ├── index.ts
    ├── tools.ts
    └── utils.ts
```

**Paquete con dependencias** — cuando necesitas npm packages:

```
~/.pi/agent/extensions/
└── my-extension/
    ├── package.json
    ├── node_modules/
    └── src/
        └── index.ts
```

---

## Tu primera extensión: "Hello Tool"

Creamos una extensión que registra un tool custom que el modelo puede llamar:

```typescript
// ~/.pi/agent/extensions/hello-tool.ts

import { Type } from "@sinclair/typebox";
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.registerTool({
    name: "hello",
    label: "Hello",
    description: "Greet someone by name",
    parameters: Type.Object({
      name: Type.String({ description: "Name to greet" }),
    }),
    async execute(_toolCallId, params, _signal, _onUpdate, _ctx) {
      return {
        content: [{ type: "text", text: `Hello, ${params.name}!` }],
        details: { greeted: params.name },
      };
    },
  });
}
```

### Qué hace cada parte

```typescript
import { Type } from "@sinclair/typebox";
```
TypeBox define schemas de validación. Pi los usa para validar los parámetros del tool **en runtime**, con mensajes de error detallados si algo falla.

```typescript
export default function (pi: ExtensionAPI) {
```
La función default es el entry point. Recibe `ExtensionAPI` — el objeto que te da acceso a todo el sistema de eventos y registro.

```typescript
pi.registerTool({
  name: "hello",           // Nombre interno
  label: "Hello",          // Etiqueta para la UI
  description: "...",      // Descripción para el LLM
  parameters: Type.Object({...}), // Schema de parámetros
  async execute(...) {...},       // Implementación
});
```
`registerTool` añade un tool que el modelo puede llamar, igual que `read`, `write`, `edit` o `bash`.

### Probarlo

```bash
# Guarda el archivo y recarga
# En Pi:
/reload

# Ahora pide:
> Saluda a María
```

Pi verá el tool `hello` disponible, lo llamará con `{ name: "María" }`, y responderá con "Hello, María!".

---

## Interceptar eventos: la guardia de seguridad

Las extensiones pueden escuchar **cualquier evento del ciclo de vida** de Pi. Un caso práctico: bloquear comandos destructivos.

```typescript
// ~/.pi/agent/extensions/block-destructive.ts

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event, ctx) => {
    if (event.toolName === "bash") {
      const command = event.input.command || "";

      // Bloquear comandos peligrosos
      if (command.includes("rm -rf") || command.includes("DROP TABLE")) {
        const ok = await ctx.ui.confirm(
          "⚠️ Comando destructivo",
          `Se intentó ejecutar:\n${command}\n\n¿Permitir?`
        );

        if (!ok) {
          ctx.ui.notify("Comando bloqueado", "warning");
          return { block: true, reason: "Comando destructivo bloqueado" };
        }
      }
    }
  });
}
```

### Ciclo de vida de los eventos

```
Pi inicia
  │
  ├─► session_start
  │
  ├─► Usuario envía prompt
  │     ├─► before_agent_start (puede inyectar contexto)
  │     ├─► agent_start
  │     │     │
  │     │     ┌── turn (se repite por cada respuesta + tools) ──┐
  │     │     │  ├─► turn_start                                  │
  │     │     │  ├─► context (puede modificar mensajes)         │
  │     │     │  │                                               │
  │     │     │  │  LLM responde, puede llamar tools:           │
  │     │     │  │    ├─► tool_call ← PUEDES BLOQUEAR          │
  │     │     │  │    ├─► tool_result (puede modificar)         │
  │     │     │  │                                               │
  │     │     │  └─► turn_end                                    │
  │     │     └──────────────────────────────────────────────────┘
  │     │                                                        │
  │     └─► agent_end
  │
  └─► session_shutdown (al salir)
```

Los eventos más útiles para empezar:

| Evento | Qué hace | Caso de uso |
|---|---|---|
| `tool_call` | Intercepta antes de ejecutar un tool | Bloquear comandos, modificar parámetros |
| `agent_end` | Se ejecuta cuando Pi termina de responder | Notificaciones, limpiar estado |
| `session_start` | Al iniciar una sesión | Inicializar estado, mostrar info |
| `context` | Antes de cada llamada al LLM | Modificar mensajes, podar contexto |
| `before_agent_start` | Antes de que el agente empiece | Inyectar contexto adicional |

---

## Notificaciones: saber cuándo Pi termina

Una extensión práctica que te avisa cuando Pi termina una tarea:

```typescript
// ~/.pi/agent/extensions/notify-done.ts

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

function notify(title: string, body: string) {
  // OSC 777: funciona en Ghostty, iTerm2, WezTerm
  process.stdout.write(`\x1b]777;notify;${title};${body}\x07`);
}

export default function (pi: ExtensionAPI) {
  pi.on("agent_end", async () => {
    notify("Pi", "✅ Listo para input");
  });
}
```

Guarda, `/reload`, y tu terminal te notificará cuando Pi termine de procesar. Útil cuando le pides tareas largas.

---

## El paradigma self-extension

Aquí viene la magia. Armin Ronacher (creador de Flask y Jinja2) lo describió así:

> *"Software que es maleable como arcilla."*

Todas sus extensiones de Pi — `/answer`, `/todos`, `/review`, `/files` — **las escribió Pi mismo**. El flujo:

1. Le describes a Pi qué quieres: "Necesito un comando `/deploy` que ejecute nuestro pipeline de staging"
2. Pi escribe la extensión como archivo `.ts`
3. Ejecutas `/reload`
4. Pi prueba el nuevo comando
5. Si falla, Pi lee el error, corrige el código, recarga, y reintenta

**No estás programando la extensión. Estás describiendo lo que quieres y Pi la implementa.**

### Ejemplo real de sesión

```
> Necesito una extensión que me pida confirmación antes de hacer
  commit si hay tests que fallan. El comando es npm test.

Pi: [Lee la estructura de extensiones, crea el archivo]

  He creado ~/.pi/agent/extensions/test-before-commit.ts
  Ejecuta /reload para activarla.

> /reload

Pi: Extensión cargada. ¿Quieres que la pruebe haciendo un commit
  con tests fallando?

> Sí, prueba

Pi: [Ejecuta commit, la extensión intercepta, ejecuta tests,
  tests fallan, pide confirmación]

  ✅ La extensión funciona correctamente. Bloqueó el commit porque
  los tests fallaron.
```

---

## Extensiones populares

| Extensión | Qué hace | Instalar |
|---|---|---|
| **pi-mcp-adapter** | Conecta servidores MCP a Pi sin inflar el contexto | `pi install npm:pi-mcp-adapter` |
| **safe-git** | Protección contra operaciones git destructivas | `pi install npm:safe-git` |
| **pi-cost-dashboard** | Dashboard de costos y uso de tokens en tiempo real | `pi install npm:pi-cost-dashboard` |
| **pi-notify** | Notificaciones del sistema cuando Pi termina | `pi install npm:pi-notify` |
| **checkpoint** | Checkpoints automáticos antes de cada turno | `pi install npm:checkpoint` |
| **pi-canvas** | Dibujar diagramas y visualizaciones | `pi install npm:pi-canvas` |
| **pi-lens** | AST grep, LSP, navegación de código | `pi install npm:pi-lens` |
| **pi-context** | Context management con tags y squash | `pi install npm:pi-context` |
| **pi-ask-user** | Handshake de decisiones con el usuario | `pi install npm:pi-ask-user` |

### Ejemplos incluidos en Pi

El repo de Pi trae 60+ extensiones de ejemplo en `examples/extensions/`:

| Ejemplo | Demuestra |
|---|---|
| `hello.ts` | Tool custom mínimo |
| `confirm-destructive.ts` | Bloquear acciones con confirmación |
| `notify.ts` | Notificaciones del terminal |
| `git-checkpoint.ts` | Crear stash checkpoints en cada turno |
| `todo.ts` | Lista de tareas persistente |
| `snake.ts` | Juego de Snake en la terminal (sí, en serio) |
| `protected-paths.ts` | Bloquear escritura en ciertos archivos |
| `custom-compaction.ts` | Compaction personalizado |

---

## Registrar comandos custom

Además de tools, puedes registrar comandos tipo `/mi-comando`:

```typescript
import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.registerCommand("deploy", {
    description: "Deploy al staging environment",
    handler: async (args, ctx) => {
      const env = args || "staging";

      ctx.ui.notify(`🚀 Deploying to ${env}...`, "info");

      const result = await pi.exec("bash", [
        "-c", `./scripts/deploy.sh ${env}`
      ]);

      ctx.ui.notify(
        result.code === 0 ? "✅ Deploy exitoso" : "❌ Deploy falló",
        result.code === 0 ? "success" : "error"
      );
    },
  });
}
```

Después de `/reload`, escribe `/deploy` o `/deploy production` en Pi.

---

## Interacción con el usuario

Las extensiones tienen acceso a `ctx.ui` para interactuar:

```typescript
// Confirmar sí/no
const ok = await ctx.ui.confirm("Título", "¿Estás seguro?");

// Seleccionar de una lista
const choice = await ctx.ui.select("Elige opción", [
  "Opción A",
  "Opción B",
  "Opción C",
]);

// Input libre
const answer = await ctx.ui.input("¿Nombre del proyecto?");

// Notificación
ctx.ui.notify("Operación completada", "success");

// Status en el footer
ctx.ui.setStatus("my-ext", "Procesando...");
```

---

## Buenas prácticas

### 1. Empieza simple, itera

```typescript
// Versión 1: Solo loguea
export default function (pi: ExtensionAPI) {
  pi.on("tool_call", async (event) => {
    console.log(`[debug] ${event.toolName}:`, event.input);
  });
}
```

Añade lógica gradualmente. No intentes hacer todo desde el inicio.

### 2. Usa `/reload` constantemente

Edita → `/reload` → prueba → edita → `/reload`. No hay necesidad de reiniciar Pi.

### 3. Pídele a Pi que escriba la extensión

```
> Crea una extensión en ~/.pi/agent/extensions/ que registre
  un tool llamado "db-query" que acepte un parámetro "sql" y
  ejecute el query usando nuestro cliente de base de datos
  en src/db/client.ts
```

Pi conoce la API de extensiones. Déjalo trabajar.

### 4. Ten cuidado con los eventos blocking

Si bloqueas `tool_call` de `bash`, Pi no puede ejecutar **ningún** comando. Sé específico:

```typescript
// ❌ Demasiado amplio
if (event.toolName === "bash") return { block: true };

// ✅ Específico
if (event.toolName === "bash" && event.input.command?.includes("rm -rf")) {
  return { block: true, reason: "Comando destructivo" };
}
```

---

## Imports disponibles

| Package | Para qué |
|---|---|
| `@mariozechner/pi-coding-agent` | Tipos de extensiones (`ExtensionAPI`, `ExtensionContext`, eventos) |
| `@sinclair/typebox` | Schemas de validación para tool parameters |
| `@mariozechner/pi-ai` | Utilidades AI (`StringEnum`, etc.) |
| `@mariozechner/pi-tui` | Componentes TUI para UI custom |
| Node.js built-ins | `node:fs`, `node:path`, `node:child_process`, etc. |

También puedes instalar cualquier paquete npm añadiendo un `package.json` junto a tu extensión.

---

## En resumen

1. **Extensiones = código TypeScript** que Pi ejecuta, no instrucciones textuales como las skills
2. **jiti** permite TypeScript sin build step — escribes `.ts`, haces `/reload`, y funciona
3. **Puedes registrar tools custom**, interceptar eventos, crear comandos, y construir UI
4. **El paradigma self-extension** es revolucionario: describes, Pi implementa, tú verificas
5. **Empieza simple:** un log, un bloqueo, una notificación. Itera desde ahí
6. **60+ ejemplos** en el repo oficial para inspirarte

---

## 🔗 Recursos

- [Skills — Superpoderes bajo demanda](/posts/2026-04-12-skills-superpoderes-bajo-demanda/) — Artículo anterior de esta serie
- [Gestión de contexto y sesiones](/posts/) — Siguiente artículo de esta serie
- [Documentación de extensiones](https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/extensions.md) — Referencia completa
- [Ejemplos de extensiones](https://github.com/badlogic/pi-mono/tree/main/packages/coding-agent/examples/extensions) — 60+ ejemplos funcionales
- [Pi: The Minimal Agent Within OpenClaw](https://lucumr.pocoo.org/2026/1/31/pi/) — Armin Ronacher sobre el self-extension paradigm

---

**Tags:** `pi`, `extensiones`, `typescript`, `personalización`, `intermedio`

---

*Este artículo forma parte de la serie [Pi desde cero hasta intermedio](/categories/pi/) — Artículo 4 de 6*
