---
title: "Serena vs OneTool: ¿cuándo usar cada uno?"
description: "Dos herramientas poderosas en mi stack. Usar ambas a la vez es como llevar un cuchillo de chef y un martillo a la misma cocina. Cuándo usar cada una y por qué."
date: 2026-03-25
lastmod: 2026-03-25
categories: ["Pi"]
tags: ["serena", "onetool", "pi", "integraciones"]
mode: review
draft: false
---Dos de las herramientas más poderosas en mi stack. Pero usar ambas al mismo tiempo es como llevar un cuchillo de chef y un martillo a la misma cocina. Aquí cuándo usar cada una.

---

## El problema: dos herramientas, ¿cuál usar?

Durante un tiempo tenía este flujo:

```
Necesito buscar una función en mi código
↓
"¿Uso Serena o OneTool?"
↓
Pruebo con Serena → funciona pero es lento
↓
Pruebo con OneTool → es más rápido pero no encuentra símbolos
↓
Termino usando grep en bash
```

El problema: **no sabía cuál era la herramienta correcta para cada tarea**.

¿Te suena conocido?

---

## Serena: el arquitecto de código

Serena está basada en **LSP (Language Server Protocol)**. Es como tener VS Code pero en tu terminal.

### Lo que hace mejor que nadie

| Cosa | Serena | OneTool | Bash |
|-------|---------|----------|------|
| Entender estructura de código | ✅ Perfecto | ❌ No | ❌ No |
| Encontrar dónde se usa una función | ✅ Instantáneo | ⚠️ Grep básico | ⚠️ Grep básico |
| Renombrar símbolos en todo el proyecto | ✅ Con referencias | ❌ No | ❌ No |
| Ver jerarquías de clases | ✅ Visual | ❌ No | ❌ No |
| Refactorizar con LSP | ✅ Inteligente | ❌ No | ❌ No |

### Ejemplos reales de uso

```python
# Ver estructura de un archivo
get_symbols_overview(relative_path="src/auth/service.js")
# → Ve: 8 funciones, 3 clases, 12 imports

# Encontrar dónde se usa una función
find_referencing_symbols(
  name_path="AuthService.login",
  relative_path="src/auth/service.js"
)
# → Encontrado en 4 archivos:
#    - src/api/login.js
#    - src/tests/auth.test.js
#    - src/middleware/auth.js
#    - src/controllers/login.js

# Renombrar una función
rename_symbol(
  name_path="AuthService.login",
  relative_path="src/auth/service.js",
  new_name="authenticate"
)
# → Renombra en 5 archivos automáticamente
```

> 💡 **Tip:** Usa Serena cuando necesitas **entender** tu código, no cuando necesitas **modificarlo** rápido.

---

## OneTool: el orquestador de workflows

OneTool es un **MCP server unificado** con 100+ herramientas. Es una navaja suiza.

### Lo que hace mejor que nadie

| Cosa | OneTool | Serena | Bash |
|-------|----------|---------|------|
| Web search integrada | ✅ Instantáneo | ❌ No | ⚠️ Manual (curl) |
| Memoria persistente | ✅ Built-in | ❌ No | ❌ No |
| Inter-tool calling | ✅ Tools llaman tools | ❌ No | ⚠️ Manual |
| Snippet templates | ✅ 30+ preconfigurados | ❌ No | ❌ No |
| MCP proxying | ✅ Route otros MCPs | ❌ No | ⚠️ Manual |
| Costo por llamada | ✅ Bajo (carga on-demand) | ⚠️ Medio | ❌ N/A |

### Ejemplos reales de uso

```python
# Búsqueda web + guardar en memoria
>>> br q="python async patterns"
>>> mem_w "async_patterns" results
# → Guardado en memoria persistente

# Recuperar de memoria y usar
>>> mem_r "async_patterns"
# → Obtiene: resultados de búsqueda anteriores

# Workflow completo: buscar → leer → procesar → guardar
>>> br q="typescript error handling best practices"
>>> re path="src/errors/"
>>> ot skill:typescript-analyzer
>>> mem_w "error_handling" last_result
```

> 💡 **Tip:** Usa OneTool cuando necesitas **integrar** múltiples herramientas, no cuando necesitas **analizar** código profundamente.

---

## Mi matriz de decisión (la que uso hoy)

Después de meses de prueba y error, creé esta matriz:

| Necesitas | Usa | Por qué |
|-----------|------|---------|
| **Entender estructura** de archivo | **Serena** | `get_symbols_overview()` te da el árbol completo |
| **Encontrar dónde** se usa X | **Serena** | `find_referencing_symbols()` sigue referencias con LSP |
| **Renombrar** función/clase | **Serena** | Refactor con referencias automáticas |
| **Ver jerarquía** de clases | **Serena** | Type hierarchy instantánea |
| **Búsqueda web** | **OneTool** | Integrada, sin salir de Pi |
| **Memoria** persistente | **OneTool** | `mem_w()`, `mem_r()`, búsqueda fuzzy |
| **Workflow** con múltiples tools | **OneTool** | Inter-tool calling automatizado |
| **Snippet** preconfigurado | **OneTool** | 30+ snippets para tareas comunes |
| **MCP proxy** (route otros MCPs) | **OneTool** | `ot.server(proxy='chrome-devtools')` |
| **Analizar código** profundo | **Serena** | LSP entiende semántica, no solo texto |
| **Integración** con múltiples servicios | **OneTool** | Búsqueda + memoria + files en uno |

> 💡 **Regla de oro:** ¿Necesitas entender el código? Serena. ¿Necesitas orquestar acciones? OneTool.

---

## Casos de uso reales

### Caso 1: Bug en función que se usa en 10 archivos

**Usar Serena:**

```python
# Encuentra dónde se usa
find_referencing_symbols(
  name_path="UserService.validate",
  relative_path="src/users/service.js"
)

# Ve los 10 archivos

# Renombra la función en todos
rename_symbol(
  name_path="UserService.validate",
  relative_path="src/users/service.js",
  new_name="validateUser"
)
```

**Resultado:** Renombrado en 10 archivos, referencias actualizadas, 30 segundos.

### Caso 2: Investigar + recordar + implementar

**Usar OneTool:**

```python
# Investigar error
>>> br q="typescript 'this is possibly undefined' fix"
>>> mem_w "undefined_fix" results

# Más tarde, recuperar solución
>>> mem_r "undefined_fix"

# Implementar
>>> re path="src/errors/"
>>> ed path="src/errors/handler.js" search="undefined" replace="fix"
```

**Resultado:** Investigación guardada, solución recordada, implementada, 2 minutos.

### Caso 3: Refactor de arquitectura

**Usar AMBOS:**

```python
# 1. Analizar con Serena
get_symbols_overview(relative_path="src/api/")
find_referencing_symbols(name_path="BaseAPI", relative_path="src/api/")

# 2. Usar OneTool para el refactor masivo
>>> ot skill:typescript-analyzer
>>> mem_w "api_structure" last_result
>>> re path="src/api/" pattern="class.*API"
```

**Resultado:** Análisis LSP + workflow integrado, 5 minutos.

---

## Comparación de costo

| Herramienta | Costo típico | Por qué |
|-------------|----------------|---------|
| **Serena** | $0.01 - $0.03 | LSP es barato, pero requiere server inicial |
| **OneTool** | $0.01 - $0.05 | Carga on-demand de tools, pero más features |
| **Ambos juntos** | $0.02 - $0.08 | Combinas lo mejor de ambos |

> 💡 **Tip:** El costo es menor que el tiempo ahorrado. $0.05 en tools vs 15 minutos de búsqueda manual = ROI 10x.

---

## ¿Puedo usar ambos en el mismo proyecto?

**Sí, y así lo hago.**

Mi setup actual:

```json
{
  "mcpServers": {
    "chrome-devtools": { ... },
    "serena": { ... },
    "google-jules": { ... }
  }
}
```

Y tengo OneTool configurado como MCP proxy:

```python
# OneTool puede routear otros MCPs
ot.server(enable='chrome-devtools')  # OneTool → Chrome DevTools
ot.server(proxy='serena')          # OneTool → Serena
```

**¿Cuándo uno, cuándo el otro?**
- Necesito análisis LSP → Serena directo
- Necesito workflow con memoria → OneTool + Serena vía proxy
- Necesito búsqueda web rápida → OneTool (brave pack)
- Necesito snippet preconfigurado → OneTool (skill:typescript-analyzer)

---

## Mis comandos más usados

### Serena

| Comando | Uso |
|----------|------|
| `get_symbols_overview()` | Ver estructura de archivo rápido |
| `find_referencing_symbols()` | Encontrar dónde se usa algo |
| `rename_symbol()` | Refactor inteligente |
| `get_type_hierarchy()` | Ver herencia de clases |

### OneTool

| Comando | Uso |
|----------|------|
| `>>> br q="query"` | Búsqueda web instantánea |
| `>>> mem_w "key" value` | Guardar en memoria |
| `>>> mem_r "key"` | Recuperar de memoria |
| `>>> ot skill:xyz` | Ejecutar skill preconfigurado |
| `ot.server(proxy='xyz')` | Routear otro MCP |

---


1. **Serena** = Arquitecto de código (LSP, análisis profundo, refactor)
2. **OneTool** = Orquestador de workflows (100+ tools, memoria, integración)
3. **Matriz de decisión:**
   - ¿Entender código? → Serena
   - ¿Orquestar acciones? → OneTool
4. **Úsalos juntos** → OneTool como proxy para Serena = lo mejor de ambos
5. **El costo es bajo** → $0.02 - $0.08 vs 15 minutos manuales

---

## 🔗 Recursos

- [Cómo configurar Pi para proyectos TypeScript](/posts/2026-03-25-como-configurar-pi-para-proyectos-typescript/) - Ejemplos de Serena en TypeScript
- [Debugging con Pi: del stack trace al fix](/posts/2026-04-04-debugging-con-pi-del-stack-trace-al-fix/) - Flujo de depuración con Serena
- [Prompt engineering para agentes de código](/posts/2026-03-25-prompt-engineering-para-agentes-de-codigo/) - Cómo combinar tools y prompts

---

## 💭 ¿Tú qué herramienta usas más?

¿Serena o OneTool? ¿O ambos? ¿Qué casos de uso tienes que no cubrí? Déjamelo en los comentarios.
