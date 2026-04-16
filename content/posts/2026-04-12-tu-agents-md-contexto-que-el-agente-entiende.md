---
title: "Tu AGENTS.md — Contexto que el agente entiende"
description: "Sin AGENTS.md, Pi adivina. Con él, Pi sabe. Cómo escribir el archivo más importante de tu proyecto para que el agente entienda tu código y convenciones."
date: 2026-04-12
lastmod: 2026-04-12
categories: ["Pi"]
tags: ["pi", "agents-md", "contexto", "configuración", "principiante"]
mode: guide
draft: false
---La diferencia entre un agente que te entiende y uno que no está en un archivo: `AGENTS.md`. Es donde le dices a Pi cómo funciona tu proyecto, qué convenciones sigues y qué esperar de él. Sin él, Pi adivina. Con él, Pi sabe.

---

## El problema del contexto

Cuando abres ChatGPT y preguntas "corrige este bug", necesitas:
1. Copiar el código
2. Explicar la estructura del proyecto
3. Mencionar las convenciones
4. Aclarar qué framework usas
5. Especificar la versión de Node

**Cada vez.** En cada mensaje. En cada sesión.

Pi resuelve esto con `AGENTS.md`: un archivo markdown con instrucciones que **se carga automáticamente al iniciar**. El agente lee estas instrucciones en cada sesión, sin que tú hagas nada.

---

## Cómo funciona la jerarquía

Pi busca archivos de contexto en tres niveles, de más general a más específico:

```
~/.pi/agent/AGENTS.md         ← Global (todas las sesiones)
       ↓
/projects/web/AGENTS.md       ← Directorio padre
       ↓
/projects/web/app/AGENTS.md   ← Directorio actual (cwd)
```

Pi busca `AGENTS.md` o `CLAUDE.md` directamente en cada directorio, caminando desde el cwd hacia arriba. **No busca dentro de subdirectorios** como `.pi/` — solo en la raíz de cada nivel.

**Todos los archivos que encuentre se concatenan.** No se sobreescriben, se acumulan.

Esto significa que puedes tener:

- **Global:** "Siempre escribe commits en español. Prefiere TypeScript sobre JavaScript."
- **Padre (monorepo):** "Los tests se ejecutan con `pnpm test` desde la raíz."
- **Proyecto:** "Este es un API REST con Express. Usamos Prisma como ORM."

Pi recibe las tres capas de instrucciones automáticamente.

### Alias: CLAUDE.md

Pi también reconoce `CLAUDE.md` como alias de `AGENTS.md`. Si vienes de Claude Code, tus archivos existentes funcionan sin cambios.

---

## Cómo escribir un buen AGENTS.md

### Regla 1: Sé específico, no genérico

```markdown
# ❌ Mal
Escribe código limpio.

# ✅ Bien
Usa camelCase para variables y funciones.
Máximo 20 líneas por función.
Si una función supera 20 líneas, divídela en helpers.
```

### Regla 2: Incluye comandos concretos

```markdown
# ❌ Mal
Ejecuta los tests.

# ✅ Bien
## Comandos del proyecto
- Tests: `pnpm test`
- Lint: `pnpm lint`
- Build: `pnpm build`
- Tests de un archivo: `pnpm test src/auth.test.ts`
```

### Regla 3: Describe la arquitectura

```markdown
## Estructura
- `src/api/` — Endpoints REST (Express)
- `src/models/` — Esquemas Prisma
- `src/services/` — Lógica de negocio
- `src/utils/` — Helpers compartidos
- `tests/` — Tests con Vitest

## Patrones
- Los endpoints llaman a services, nunca a la DB directamente
- Los services son clases con métodos async
- Los errores se lanzan con clases custom en `src/utils/errors.ts`
```

### Regla 4: Declara preferencias de estilo

```markdown
## Estilo de código
- TypeScript strict mode
- Preferir `interface` sobre `type` para objetos
- Imports absolutos con alias `@/` (configurado en tsconfig)
- Siempre tipar parámetros y retornos
- Usar `async/await`, nunca `.then()`
```

### Regla 5: Di qué NO hacer

```markdown
## Restricciones
- NO instalar paquetes nuevos sin preguntar
- NO modificar archivos de configuración (tsconfig, docker-compose) sin confirmación
- NO usar `any` — si no hay tipo, usar `unknown`
- NO crear archivos fuera de `src/`
```

---

## Ejemplo completo: proyecto real

```markdown
# API de Reservas

## Stack
- Node.js 20 + TypeScript 5.3
- Express 4 para el API REST
- Prisma 5 como ORM (PostgreSQL 15)
- Vitest para tests
- Redis para caché

## Comandos
- `pnpm dev` — Servidor de desarrollo (puerto 3000)
- `pnpm test` — Todos los tests
- `pnpm test:watch` — Tests en modo watch
- `pnpm db:migrate` — Ejecutar migraciones
- `pnpm db:seed` — Cargar datos de prueba
- `pnpm lint` — ESLint

## Estructura
- `src/routes/` — Definición de endpoints (Express Router)
- `src/services/` — Lógica de negocio
- `src/repositories/` — Queries a la base de datos (Prisma)
- `src/middleware/` — Auth, validación, error handling
- `src/utils/` — Helpers y constantes
- `tests/` — Tests organizados por módulo

## Patrones
- Routes → Middleware → Service → Repository → DB
- Un service por entidad (BookingService, UserService, etc.)
- Repositories encapsulan todas las queries Prisma
- Errores custom: lanzar `AppError` de `src/utils/errors.ts`
- Respuestas: usar `ApiResponse.success()` y `ApiResponse.error()`

## Convenciones
- Commits en español, formato: `tipo(ámbito): descripción`
- Tipos: feat, fix, refactor, test, docs, chore
- Siempre escribir tests para endpoints nuevos
- Usar UUID para IDs públicos, auto-increment solo interno

## Lo que NO debes hacer
- No usar Prisma directamente en routes o services — siempre via repository
- No crear endpoints sin middleware de validación (usar Zod schemas en `src/middleware/validators/`)
- No hardcodear configuración — usar variables de entorno con `src/config.ts`
- No modificar migraciones ya ejecutadas — crear nuevas
```

Con este archivo, cuando digas "añade un endpoint para cancelar reservas", Pi ya sabe:
- Dónde poner el route, el service y el repository
- Qué patrones seguir
- Que necesita validación con Zod
- Que necesita escribir tests

**Sin explicarle nada.**

---

## SYSTEM.md — Controlando el system prompt

Mientras `AGENTS.md` son instrucciones para el agente sobre tu proyecto, `SYSTEM.md` controla el prompt del sistema que recibe el modelo.

### Reemplazar el system prompt

Crea `.pi/SYSTEM.md` (proyecto) o `~/.pi/agent/SYSTEM.md` (global):

```markdown
Eres un experto en TypeScript y Node.js.
Responde siempre en español.
Usa ejemplos de código en cada explicación.
```

**⚠️ Esto reemplaza el prompt por defecto de Pi** (~100 tokens). Úsalo solo si sabes lo que haces.

### Añadir sin reemplazar

Crea `APPEND_SYSTEM.md` en lugar de `SYSTEM.md`:

```markdown
Cuando escribas tests, sigue el patrón Arrange-Act-Assert.
Prioriza la legibilidad sobre la brevedad.
```

Esto **se añade** al prompt por defecto sin reemplazarlo. Más seguro.

### ¿Cuándo usar cada uno?

| Archivo | Efecto | Cuándo usarlo |
|---|---|---|
| `SYSTEM.md` | Reemplaza el system prompt | Quieres control total del comportamiento |
| `APPEND_SYSTEM.md` | Añade instrucciones al prompt por defecto | Quieres ajustar sin romper los defaults |

---

## settings.json — Configuración estructurada

Además de los archivos markdown, Pi usa JSON para configuración técnica:

| Archivo | Alcance |
|---|---|
| `~/.pi/agent/settings.json` | Global (todos los proyectos) |
| `.pi/settings.json` | Proyecto (sobreescribe al global) |

### Configuración básica

```json
{
  "defaultProvider": "anthropic",
  "defaultModel": "claude-sonnet-4-20250514",
  "defaultThinkingLevel": "medium",
  "theme": "dark"
}
```

### Configuración por proyecto

En `.pi/settings.json`:

```json
{
  "defaultModel": "gpt-4o",
  "packages": [
    "npm:pi-mcp-adapter"
  ]
}
```

Esto hace que ese proyecto use GPT-4o y tenga el adapter MCP disponible, sin afectar tus otros proyectos.

### Configuraciones útiles para empezar

```json
{
  "defaultProvider": "anthropic",
  "defaultModel": "claude-sonnet-4-20250514",
  "defaultThinkingLevel": "medium",
  "compaction": {
    "enabled": true,
    "keepRecentTokens": 20000
  },
  "retry": {
    "maxRetries": 3
  }
}
```

| Setting | Qué hace |
|---|---|
| `defaultProvider` | Provider por defecto (anthropic, openai, google, etc.) |
| `defaultModel` | Modelo por defecto |
| `defaultThinkingLevel` | Nivel de razonamiento (off, minimal, low, medium, high) |
| `compaction.keepRecentTokens` | Tokens recientes a conservar al compactar |
| `compaction.reserveTokens` | Tokens reservados para la respuesta |
| `theme` | Tema visual (dark, light, o custom) |
| `packages` | Paquetes npm/git a cargar |

Para ver todas las opciones: [docs/settings.md](https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/settings.md)

---

## El flujo de contexto completo

Cuando escribes un prompt en Pi, esto es lo que el modelo recibe:

```
┌─────────────────────────────────────┐
│ System prompt (~100 tokens)         │  ← SYSTEM.md (o el default)
├─────────────────────────────────────┤
│ Tool definitions (~900 tokens)      │  ← Los 4 tools + los que añadas
├─────────────────────────────────────┤
│ AGENTS.md (tamaño variable)         │  ← Jerarquía: global + padres + proyecto
├─────────────────────────────────────┤
│ Skills (progressive disclosure)     │  ← Solo si se activan
├─────────────────────────────────────┤
│ Conversation history                │  ← El grueso del contexto
│ (se compacta automáticamente)       │
└─────────────────────────────────────┘
```

**Tú controlas la mayoría del presupuesto.** Pi usa ~1,000 tokens para system + tools. El resto es tuyo: AGENTS.md, conversación, y skills.

Comparación con otros agentes:

| Agente | Tokens del sistema | Control del usuario |
|---|---|---|
| Claude Code | ~10,000 | Limitado |
| Cursor | ~8,000 | Moderado |
| **Pi** | **~1,000** | **Total** |

---

## Errores comunes con AGENTS.md

### 1. Escribir instrucciones vagas

```markdown
# ❌ Vago
Haz código de calidad.
```

Pi ya sabe escribir código de calidad. Las instrucciones deben ser cosas que Pi **no puede adivinar**: tu stack, tus convenciones, tus comandos.

### 2. Hacer el archivo demasiado largo

Si tu AGENTS.md tiene 500 líneas, consumes tokens que podrían usarse para la conversación.

**Solución:** Sé conciso. Pi no necesita que le expliques qué es TypeScript. Solo necesita saber que lo usas.

### 3. No actualizar el archivo

Si cambias de Vitest a Jest y no actualizas AGENTS.md, Pi seguirá ejecutando `vitest`.

**Solución:** Trata AGENTS.md como documentación viva. Cuando cambie algo del proyecto, actualízalo.

### 4. Olvidar los comandos

Pi puede ejecutar `bash`, pero si no sabe cuál es el comando correcto, puede ejecutar el equivocado.

```markdown
# ✅ Siempre incluye esto
## Comandos
- Tests: `npm test`
- Build: `npm run build`
- Dev: `npm run dev`
```

---

## Checklist: Tu contexto está listo

- [ ] Tienes `AGENTS.md` en tu proyecto (o `CLAUDE.md`)
- [ ] Incluye tu stack tecnológico
- [ ] Incluye comandos clave (test, build, dev)
- [ ] Incluye convenciones de código
- [ ] Incluye restricciones (qué NO hacer)
- [ ] Verificaste que Pi lo carga (aparece en el header al iniciar)
- [ ] Si necesitas ajustar el system prompt, usaste `APPEND_SYSTEM.md`
- [ ] `settings.json` tiene tu provider y modelo por defecto

---


1. **AGENTS.md** es el archivo más importante de tu setup — le da a Pi el contexto de tu proyecto
2. Se **concatena** desde 3 niveles: global → padres → proyecto actual
3. **Sé específico**: stack, comandos, convenciones, restricciones
4. **SYSTEM.md** reemplaza el system prompt; **APPEND_SYSTEM.md** lo extiende
5. **settings.json** para configuración técnica (provider, modelo, compaction)
6. El objetivo: que Pi sepa todo lo necesario **sin que se lo expliques en cada sesión**

---

## 🔗 Recursos

- [Pi desde cero — Instalación y primera sesión](/posts/2026-04-12-pi-desde-cero-instalacion-y-primera-sesion/) — Artículo anterior de esta serie
- [Skills — Superpoderes bajo demanda](/posts/) — Siguiente artículo de esta serie
- [Documentación de settings](https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/docs/settings.md) — Todas las opciones de configuración
- [Por qué Pi cambió mi workflow de desarrollo](/posts/2026-03-23-pi-cambio-mi-workflow/) — Mi experiencia personal
