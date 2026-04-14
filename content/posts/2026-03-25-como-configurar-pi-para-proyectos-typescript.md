---
title: "Cómo configurar Pi para proyectos TypeScript"
description: "Pi está construido en TypeScript. Configurarlo para proyectos TS no es una configuración especial — es su modo nativo. Guía completa de setup paso a paso."
date: 2026-03-25
lastmod: 2026-03-25
categories: ["Pi"]
tags: ["typescript", "pi", "configuracion", "tutorial"]
mode: tutorial
draft: false
---Lo que nadie te dice: Pi está **construido en TypeScript**. Configurarlo para proyectos TypeScript no es una configuración especial — es su modo NATIVO.

---

## El mito: "Pi es para JavaScript"

He escuchado esto muchas veces:

> "Pi es para proyectos JavaScript/Node.js. Para TypeScript, necesitas otra cosa."

**Esto es falso.** Pi está construido en TypeScript desde el inicio.

```
pi-ai              → LLM communication (TypeScript)
pi-agent-core       → Agent loop (TypeScript)
pi-coding-agent     → Full CLI (TypeScript)
```

No es que Pi "soporta" TypeScript. Es que **Pi está hecho de TypeScript**.

---

## Configuración básica de Pi para TypeScript

### 1. Instalación (igual que siempre)

```bash
npm install -g @mariozechner/pi-coding-agent
pi
```

### 2. Configurar models.json para TypeScript

```json
{
  "defaultProvider": "anthropic",
  "defaultModel": "claude-sonnet-4",
  "defaultThinkingLevel": "high",
  "providers": {
    "anthropic": {
      "apiKey": "sk-ant-...",
      "defaultModel": "claude-sonnet-4",
      "models": [
        {
          "id": "claude-sonnet-4",
          "name": "Claude Sonnet 4",
          "contextWindow": 200000,
          "supportsTools": true,
          "typeScriptOptimized": true
        }
      ]
    }
  }
}
```

> 💡 **Tip:** La mayoría de modelos modernos (Claude, GPT-4, GLM) son nativamente TypeScript-optimizados.

### 3. Configurar tsconfig.json para Pi

En tu proyecto TypeScript:

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "allowSyntheticDefaultImports": true,
    "plugins": [
      {
        "name": "@mariozechner/pi-typecheck-plugin"
      }
    ]
  }
}
```

---

## Extensiones esenciales para TypeScript

### 1. pi-typescript (no oficial, pero útil)

Esta extensión no existe oficialmente, pero los desarrolladores de Pi recomiendan este setup:

```bash
# Extensiones que mejoran la experiencia TS
pi install npm:pi-context
pi install npm:pi-ask-user
pi install npm:pi-serena-tools  # ← IMPORTANTE para TS
```

### 2. pi-serena-tools para TypeScript

Serena **entiende TypeScript**. Es como tener tsc en el agente:

```python
# Ver tipos de una función
get_type_hierarchy(name_path="AuthService.login", relative_path="src/auth/service.ts")
# → Ve: (token: string) => Promise<User | null>

# Renombrar respetando tipos
rename_symbol(
  name_path="AuthService.login",
  relative_path="src/auth/service.ts",
  new_name="authenticate"
)
# → Renombra Y actualiza tipos
```

### 3. Skills de TypeScript

Pi incluye skills pre-instalados para TS:

```bash
/skill:typescript-analyzer    # Analiza código TS
/skill:typescript-linter      # Sugiere mejoras
/skill:typescript-refactor   # Refactors comunes
```

---

## Mi setup de producción

Este es mi archivo `~/.pi/agent/settings.json` para proyectos TypeScript:

```json
{
  "defaultProvider": "anthropic",
  "defaultModel": "claude-sonnet-4",
  "defaultThinkingLevel": "high",
  "theme": "nord",
  "compaction": {
    "enabled": true,
    "reserveTokens": 19200,
    "keepRecentTokens": 19200
  },
  "retry": {
    "enabled": true,
    "maxRetries": 3
  },
  "onetool": {
    "command": "/home/pablo/.local/bin/onetool",
    "args": [
      "--config",
      "/home/pablo/.onetool/onetool.yaml",
      "--secrets",
      "/home/pablo/.onetool/secrets.yaml"
    ]
  },
  "packages": [
    "npm:oh-pi",
    "npm:onetool-pi",
    "npm:pi-context",
    "npm:pi-ask-user",
    "npm:pi-rewind",
    "npm:pi-serena-tools",
    "npm:glimpseui"
  ],
  "mcpServers": {
    "serena": {
      "command": "/home/pablo/.npm-global/bin/serena-mcp",
      "env": {}
    },
    "chrome-devtools": {
      "command": "/home/pablo/.npm-global/bin/chrome-devtools-mcp",
      "args": ["--autoConnect"],
      "env": {
        "CHROME_PATH": "/usr/bin/google-chrome"
      }
    }
  }
}
```

**Por qué esto funciona para TS:**
- **pi-serena-tools** → LSP nativo para TS
- **pi-context** → Gestión de contexto para sesiones TS largas
- **pi-rewind** → Back-in-time si TS se rompe algo
- **glimpseui** → UI para previews de TS en tiempo real

---

## Flujos de trabajo comunes con TypeScript

### 1. Crear nuevo archivo TypeScript

```bash
pi
# Tú: "Crea un nuevo servicio de usuarios en TypeScript con tipos"
```

Pi genera:

```typescript
// src/users/service.ts
export interface User {
  id: string;
  email: string;
  createdAt: Date;
}

export class UserService {
  async create(data: CreateUserDTO): Promise<User> {
    // implementation
  }

  async findById(id: string): Promise<User | null> {
    // implementation
  }
}
```

### 2. Agregar tipos a función existente

```bash
pi
# Tú: "Agrega tipos TypeScript a la función validateToken en src/auth/"
```

Pi usa Serena para inferir tipos y luego los añade:

```typescript
// Antes
function validateToken(token) {
  // sin tipos
}

// Después
function validateToken(token: string): Promise<User | null> {
  // con tipos + JSDoc
}
```

### 3. Refactorizar interface

```python
# Usar Serena para refactor
rename_symbol(
  name_path="IUser",
  relative_path="src/types/users.ts",
  new_name="UserDTO"
)
```

Resulta: renombrado en TODOS los archivos que usan `IUser`.

---

## Comandos específicos para TypeScript

| Comando | Qué hace | Ejemplo |
|----------|-----------|---------|
| `get_type_hierarchy()` | Ver tipos de función/variable | `get_type_hierarchy(name_path="User.login")` |
| `find_referencing_symbols()` | Encontrar dónde se usa un tipo | `find_referencing_symbols(name_path="UserDTO")` |
| `/skill:typescript-analyzer` | Analizar código TS | `/skill:typescript-analyzer src/service.ts` |
| `/skill:typescript-linter` | Sugerir mejoras TS | `/skill:typescript-linter src/service.ts` |
| `/skill:typescript-refactor` | Refactors comunes | `/skill:typescript-refactor --pattern="any-to-unknown"` |

---

## ¿Y los proyectos frontend (React/Vue/Next.js)?

Pi funciona **exactamente igual**. La diferencia es solo en qué archivos tocas.

| Framework | Pi entiende |
|----------|--------------|
| **React** | ✅ JSX + TSX + tipos de React |
| **Vue** | ✅ VUE + tipos de Vue |
| **Next.js** | ✅ React + routing + API routes |
| **Svelte** | ✅ Svelte + tipos de Svelte |

Ejemplo con Next.js + TS:

```bash
pi
# Tú: "Añade una nueva página /dashboard con TypeScript"
```

Pi genera:

```typescript
// app/dashboard/page.tsx
export default function DashboardPage() {
  return (
    <div>
      <h1>Dashboard</h1>
      {/* TSX con tipos automáticos */}
    </div>
  )
}

export const metadata = {
  title: 'Dashboard',
  description: 'Your personal dashboard'
}
```

---

## Problemas comunes y soluciones

### Problema: "Pi no entiende mis tipos"

**Causa:** tsconfig.json no está en el directorio actual

**Solución:**

```bash
# Asegúrate que Pi encuentra el tsconfig
pi --cwd /ruta/a/tu/proyecto
# O
cd /ruta/a/tu/proyecto && pi
```

### Problema: "Refactor rompe tipos"

**Causa:** Usar `edit` en lugar de Serena para refactors

**Solución:**

```python
# ❌ No hagas esto
edit(path="src/types.ts", oldText="interface User", newText="interface UserDTO")

# ✅ Haz esto
rename_symbol(name_path="User", relative_path="src/types.ts", new_name="UserDTO")
```

### Problema: "Pi no encuentra tipos de node_modules"

**Causa:** Pi no tiene acceso a `node_modules/@types`

**Solución:**

```json
// tsconfig.json
{
  "compilerOptions": {
    "typeRoots": ["./node_modules/@types", "./types"]
  }
}
```

---

## Comparación: Pi con TS vs sin Pi

| Tarea | Sin Pi | Con Pi + TS |
|-------|---------|-------------|
| Crear archivo nuevo | Manual + pensar tipos | Pi genera con tipos |
| Agregar tipos | Manual, tedioso | Pi infiere y añade |
| Refactorizar | Manual, riesgoso | Serena renombra con tipos |
| Buscar tipo | grep + abrir archivos | Serena encuentra instantáneo |
| Error de tipos | VS Code lento | Pi + Serena en terminal |

---


1. **Pi está construido en TypeScript** → no es una configuración especial, es nativo
2. **Configuración básica:** models.json + tsconfig.json
3. **Extensiones esenciales:** pi-serena-tools, pi-context, glimpseui
4. **Serena entiende TS** → LSP nativo para inferencia de tipos
5. **Funciona para todos los frameworks:** React, Vue, Next.js, Svelte
6. **El setup es el mismo** → Pi es Pi, TS es JS con tipos

---

## 🔗 Recursos

- [Serena vs OneTool: ¿cuándo usar cada uno?](/posts/2026-03-25-serena-vs-onetool-cuando-usar-cada-uno/) - Cuándo conviene usar Serena
- [Debugging con Pi: del stack trace al fix](/posts/2026-04-04-debugging-con-pi-del-stack-trace-al-fix/) - Flujo de troubleshooting en Pi
- [Prompt engineering para agentes de código](/posts/2026-03-25-prompt-engineering-para-agentes-de-codigo/) - Cómo dar mejores instrucciones al agente

---

## 💬 ¿Qué framework TS usas con Pi?

React, Vue, Next.js, Angular? ¿Algo diferente? ¿Tienes algún tip específico? Déjamelo en los comentarios.
