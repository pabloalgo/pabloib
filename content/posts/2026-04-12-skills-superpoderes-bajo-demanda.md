---
title: "Skills — Superpoderes bajo demanda"
date: 2026-04-12
categories: ["Pi"]
tags: ["pi", "skills", "agentskills", "personalización", "intermedio"]
readingTime: 11
draft: false
---


**Publicado:** 2026-04-12 | **Categoría:** Pi | **Lectura:** 11 min

Pi viene con 4 tools y un system prompt de 100 tokens. ¿Cómo haces que haga cosas avanzadas sin inflar el core? La respuesta es **skills**: paquetes de instrucciones que se cargan bajo demanda, solo cuando se necesitan. Y son un estándar abierto: funcionan en Pi, Claude Code, Codex, y más.

---

## 🎯 Lo que aprenderás

- Qué son las skills y cómo funciona el estándar agentskills.io
- Progressive disclosure: por qué las skills no consumen contexto hasta que las necesitas
- Cómo instalar skills de la comunidad
- El formato SKILL.md y sus campos
- Cómo crear tu primera skill custom
- Skills populares que vale la pena tener

---

## ¿Qué es una skill?

Una skill es un directorio con un archivo `SKILL.md` que contiene instrucciones especializadas. Cuando Pi necesita hacer algo específico (auditar tu configuración, automatizar deploys, generar diagramas), **carga la skill relevante al vuelo**.

Ejemplo real: la skill `browser-tools`:

```markdown
---
name: browser-tools
description: Interactive browser automation via Chrome DevTools Protocol.
  Use when you need to interact with web pages, test frontends, or when
  user interaction with a visible browser is required.
---

# Browser Tools

Chrome DevTools Protocol tools for agent-assisted web automation...
```

Cuando le pides a Pi "abre esta web y haz una captura de pantalla", Pi lee la descripción de todas las skills disponibles, detecta que `browser-tools` es la relevante, y carga sus instrucciones completas. **Solo entonces** consume tokens de contexto.

---

## Progressive disclosure: la clave del rendimiento

Las skills usan tres niveles de carga:

```
┌──────────────────────────────────────────┐
│ Nivel 1: Metadatos (~100 tokens)         │  ← Siempre cargado al iniciar
│ name + description de cada skill         │
├──────────────────────────────────────────┤
│ Nivel 2: Instrucciones (< 5000 tokens)   │  ← Solo cuando se activa
│ Contenido completo de SKILL.md           │
├──────────────────────────────────────────┤
│ Nivel 3: Recursos (bajo demanda)         │  ← Solo si se necesitan
│ scripts/, references/, assets/           │
└──────────────────────────────────────────┘
```

**¿Por qué importa?** Si tienes 20 skills instaladas, solo consumes ~2,000 tokens en metadatos (nivel 1). Las instrucciones completas solo se cargan cuando una skill se activa (nivel 2). Y los archivos auxiliares solo si la skill los necesita (nivel 3).

Comparación sin progressive disclosure:

| Enfoque | 20 skills en contexto |
|---|---|
| Todo cargado | ~100,000 tokens 💀 |
| **Progressive disclosure** | **~2,000 tokens ✅** |

---

## El estándar agentskills.io

Pi implementa [agentskills.io](https://agentskills.io), un estándar abierto para paquetes de skills. Esto significa:

- Las skills que escribas para Pi **funcionan en Claude Code, Codex CLI, Amp, Droid** y cualquier agente que implemente el estándar
- Puedes usar skills de otros agentes en Pi
- Hay un ecosistema creciente de skills compartidas

### Estructura de directorio

```
mi-skill/
├── SKILL.md          # Obligatorio: metadatos + instrucciones
├── scripts/          # Opcional: scripts ejecutables
├── references/       # Opcional: documentación adicional
└── assets/           # Opcional: plantillas, recursos
```

### Formato de SKILL.md

```markdown
---
name: mi-skill
description: >
  Descripción de qué hace la skill y cuándo usarla.
  Máximo 1024 caracteres.
license: MIT
compatibility: pi-coding-agent >= 0.60
metadata:
  version: "1.0.0"
  author: "tu-nombre"
allowed-tools: read bash edit write
---

# Mi Skill

Instrucciones detalladas para el agente...

## Pasos
1. Hacer esto
2. Luego aquello

## Ejemplos
...
```

### Campos del frontmatter

| Campo | Requerido | Qué hace |
|---|---|---|
| `name` | ✅ | Nombre de la skill (minúsculas, guiones, 1-64 chars) |
| `description` | ✅ | Qué hace y cuándo usarla (max 1024 chars) |
| `license` | ❌ | Licencia (MIT, Apache, etc.) |
| `compatibility` | ❌ | Requisitos de entorno |
| `metadata` | ❌ | Metadatos adicionales (versión, autor, etc.) |
| `allowed-tools` | ❌ | Tools pre-aprobados para esta skill |

### Reglas para el nombre

```
✅ Válido          ❌ Inválido
browser-tools      Browser-Tools (mayúsculas)
git-workflow       git_workflow (guiones bajos)
react-patterns     react--patterns (doble guión)
api-testing        -api-testing (empieza con guión)
```

---

## Dónde viven las skills

Pi busca skills en varias ubicaciones:

| Ubicación | Alcance | Qué contiene |
|---|---|---|
| `~/.pi/agent/skills/` | Global | Skills para todos los proyectos |
| `.pi/skills/` | Proyecto | Skills específicas del proyecto |
| Paquetes npm/git | Variable | Skills distribuidas como paquetes |

Ejemplo de estructura global:

```
~/.pi/agent/skills/
├── browser-tools/
│   └── SKILL.md
├── conventional-commit/
│   └── SKILL.md
└── capability-steward/
    ├── SKILL.md
    └── references/
        └── patterns.md
```

---

## Cómo instalar skills

### Método 1: skill.sh (recomendado, universal)

[skill.sh](https://github.com/nicobailon/skill.sh) es un instalador universal que funciona con Pi, Claude Code, Goose y Windsurf:

```bash
# Instalar skill.sh (una vez)
curl -fsSL https://skill.sh | bash

# Instalar una skill desde una URL
skill.sh install pi https://raw.githubusercontent.com/user/repo/main/skill.md

# Listar skills instaladas
skill.sh list pi
```

### Método 2: pi install (paquetes npm/git)

```bash
# Instalar un paquete que contiene skills
pi install npm:pi-lens
pi install npm:pi-context
pi install git:https://github.com/user/pi-skills.git

# Listar paquetes instalados
pi list

# Actualizar
pi update
```

Los paquetes pueden incluir skills, extensiones, themes y prompts todo en uno.

### Método 3: Manual (copiar)

Simplemente copia el directorio de la skill:

```bash
# Skill global
cp -r mi-skill/ ~/.pi/agent/skills/mi-skill/

# Skill de proyecto
cp -r mi-skill/ .pi/skills/mi-skill/
```

### Método 4: Desde settings.json

```json
{
  "skills": [
    "~/.pi/agent/skills/my-skill",
    "./.pi/skills/project-skill"
  ]
}
```

---

## Cómo crear tu primera skill

Vamos a crear una skill real: **commit-helper**, que ayuda a Pi a escribir mejores commits siguiendo tus convenciones.

### Paso 1: Crear el directorio

```bash
mkdir -p ~/.pi/agent/skills/commit-helper
```

### Paso 2: Escribir SKILL.md

```markdown
---
name: commit-helper
description: >
  Ayuda a escribir commits consistentes siguiendo Conventional Commits en español.
  Se activa cuando el usuario pide hacer commit, describe cambios, o pregunta
  qué commit poner.
metadata:
  version: "1.0.0"
  author: "pabloib"
allowed-tools: bash read
---

# Commit Helper

Cuando el usuario pida hacer un commit, sigue este proceso:

## Paso 1: Analizar los cambios

Ejecuta:
```bash
git diff --cached --stat
git diff --cached
```

Si no hay cambios staged, ejecuta `git status` y sugiere qué hacer `git add`.

## Paso 2: Generar el mensaje

Formato: `tipo(ámbito): descripción en español`

Tipos válidos:
- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `refactor`: Refactorización sin cambio de comportamiento
- `docs`: Cambios en documentación
- `test`: Añadir o modificar tests
- `chore`: Tareas de mantenimiento
- `perf`: Mejoras de rendimiento
- `style`: Formato, punto y coma, etc.

Reglas:
- Descripción en minúscula, sin punto final
- Máximo 72 caracteres en la primera línea
- Si hay detalles adicionales, añadir cuerpo separado por línea en blanco

## Paso 3: Confirmar y ejecutar

Muestra el mensaje propuesto al usuario y espera confirmación antes de ejecutar `git commit`.

## Ejemplos

```
feat(auth): añadir validación de token JWT en middleware
fix(api): corregir paginación cuando el offset es 0
refactor(db): extraer lógica de conexión a módulo propio
docs(readme): actualizar instrucciones de instalación
```
```

### Paso 3: Probar

Inicia Pi y pide un commit:

```
> Haz commit de los cambios que tengo
```

Pi cargará la skill automáticamente (por la descripción coincide con "commit") y seguirá tus instrucciones.

---

## Skills populares de la comunidad

| Skill | Qué hace | Instalar |
|---|---|---|
| **pi-mcp-adapter** | Conectar servidores MCP a Pi | `pi install npm:pi-mcp-adapter` |
| **pi-cost-dashboard** | Ver costos y uso de tokens en tiempo real | `pi install npm:pi-cost-dashboard` |
| **safe-git** | Protección contra commits accidentales | `pi install npm:safe-git` |
| **pi-notify** | Notificaciones cuando Pi termina una tarea | `pi install npm:pi-notify` |
| **checkpoint** | Crear puntos de restauración automáticos | `pi install npm:checkpoint` |
| **pi-canvas** | Dibujar diagramas y visualizaciones | `pi install npm:pi-canvas` |
| **pi-lens** | AST grep, LSP navigation, code intelligence | `pi install npm:pi-lens` |
| **pi-context** | Context management con tags, squash, checkout | `pi install npm:pi-context` |

### Dónde encontrar más skills

- **[pi.dev/packages](https://shittycodingagent.ai/packages)** — Directorio oficial de paquetes
- **[awesome-pi-agent](https://github.com/qualisero/awesome-pi-agent)** — Lista curada de recursos
- **[GitHub](https://github.com/search?q=SKILL.md+pi-coding-agent&type=code)** — Buscar skills en GitHub
- **npm** — Buscar paquetes con `pi install npm:nombre`

---

## Buenas prácticas para escribir skills

### 1. Descripción precisa = activación correcta

La `description` es lo que Pi lee para decidir si activar la skill. Si es vaga, no se activará cuando debería.

```markdown
# ❌ Vaga
description: Ayuda con varias cosas de Git.

# ✅ Precisa
description: >
  Genera mensajes de commit siguiendo Conventional Commits.
  Se activa cuando el usuario pide hacer commit, pregunta qué
  mensaje poner, o quiere ver el historial de commits formateado.
```

### 2. Mantén SKILL.md bajo 500 líneas

Si la skill es muy larga, mueve detalle a `references/`:

```
mi-skill/
├── SKILL.md              # Instrucciones principales (< 500 líneas)
└── references/
    ├── api-reference.md  # Detalle técnico
    └── examples.md       # Ejemplos extensos
```

En SKILL.md referencia los archivos:

```markdown
Para detalles de la API, consulta [references/api-reference.md](references/api-reference.md).
```

### 3. Incluye ejemplos concretos

Los modelos siguen mejor las instrucciones cuando ven ejemplos:

```markdown
## Ejemplos

Input: "haz commit"
Output:
  1. Ejecuta `git diff --cached`
  2. Analiza los cambios
  3. Genera: `feat(auth): añadir validación de sesión`
  4. Pide confirmación
  5. Ejecuta `git commit -m "..."`
```

### 4. Especifica los tools necesarios

```yaml
allowed-tools: read bash
```

Esto le dice a Pi qué tools necesita la skill. Si tu skill solo necesita leer y ejecutar comandos, no necesita `write` ni `edit`.

---

## Cómo verificar que tus skills están cargadas

Al iniciar Pi, el header muestra las skills detectadas:

```
╭─────────────────────────────────────╮
│  Pi Coding Agent v0.159.x           │
│  Model: claude-sonnet-4-20250514    │
│  Skills: 8 loaded                   │
╰─────────────────────────────────────╯
```

También puedes invocar una skill manualmente:

```
> /skill:commit-helper
```

O si quieres desactivar todas las skills para una sesión:

```bash
pi --no-skills
```

---

## En resumen

1. **Skills = instrucciones especializadas** que se cargan bajo demanda, no siempre
2. **Progressive disclosure** significa que 20 skills solo consumen ~2,000 tokens hasta que se necesiten
3. **agentskills.io** es un estándar abierto — tus skills funcionan en Pi, Claude Code, Codex y más
4. **Instala** con skill.sh, `pi install`, o manualmente copiando directorios
5. **Crea tus skills** con un SKILL.md que tenga frontmatter YAML + instrucciones en Markdown
6. **La descripción es crítica** — es lo que Pi lee para decidir si activar la skill

---

## 🔗 Recursos

- [Tu AGENTS.md — Contexto que el agente entiende](/posts/2026-04-12-tu-agents-md-contexto-que-el-agente-entiende/) — Artículo anterior de esta serie
- [Extensiones — Pi que se programa a sí mismo](/posts/) — Siguiente artículo de esta serie
- [agentskills.io](https://agentskills.io) — Especificación oficial del estándar
- [Pi packages](https://shittycodingagent.ai/packages) — Directorio oficial de paquetes
- [awesome-pi-agent](https://github.com/qualisero/awesome-pi-agent) — Lista curada de recursos

---

**Tags:** `pi`, `skills`, `agentskills`, `personalización`, `intermedio`

---

*Este artículo forma parte de la serie [Pi desde cero hasta intermedio](/categories/pi/) — Artículo 3 de 6*
