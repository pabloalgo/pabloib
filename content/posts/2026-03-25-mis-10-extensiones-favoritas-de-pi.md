---
title: "Mis 10 extensiones favoritas de Pi"
date: 2026-03-25
categories: ["Pi"]
tags: ["pi", "extensiones", "productividad", "tutorial"]
readingTime: 12
draft: false
---


**Publicado:** 2026-03-25 | **Categoría:** Pi | **Lectura:** 12 min

Después de usar Pi durante 6 meses en proyectos reales, estas son las extensiones que realmente cambian mi desarrollo. No son las más populares ni las más nuevas. Son las que **realmente uso todos los días**.

---

## 🎯 Lo que aprenderás

- Las 10 extensiones que forman mi stack productivo
- Por qué cada una es irremplazable para mí
- Mi orden de instalación para un proyecto nuevo
- Extensiones que descarté y por qué

---

## Mi regla: no instalar extensiones por instalar

La tienda de paquetes de Pi tiene 100+ extensiones. Instalé todas, probé todas, y me di cuenta de algo:

**La mayoría son para el 0.1% de los casos.**

Mi regla hoy:
- Si no lo uso en 50% de las sesiones → lo desinstalo
- Si no me ahorra tiempo medible → lo desinstalo
- Si el costo en tiempo > el beneficio → lo desinstalo

Las 10 extensiones de esta lista cumplen las tres reglas.

---

## 🥇 1. pi-context

**Paquete:** `npm:pi-context`

> Gestión de contexto e historial: tags, checkout, branching

### Por qué es irremplazable

```bash
# Crear un tag antes de cambios grandes
/tag create "pre-refactor"

# Trabajo en refactor masivo...
# Si sale mal:
/tag checkout "pre-refactor"
# → Vuelve al estado exacto antes del refactor
```

**Escenarios donde uso:**
- Antes de refactor grandes
- Después de experimentos fallidos
- Para probar múltiples implementaciones en paralelo
- Para volver a "ayer, antes de que empezara esta sesión"

### Uso típico

```bash
/tag list              # Ver todos los tags
/tag create "nombre"    # Crear tag
/tag checkout "nombre"   # Volver a tag
/tag diff "a" "b"      # Ver diferencia entre tags
```

**ROI:** Ahorro de 2+ horas por proyecto (no refactor desde cero cuando falla).

---

## 🥈 2. pi-ask-user

**Paquete:** `npm:pi-ask-user`

> Decisiones estructuradas: confirmaciones, selects, inputs

### Por qué es irremplazable

```bash
# Sin pi-ask-user
Pi: "¿Borro este archivo? [Tú escribes] sí"
Tú: "sí"
Pi: "¿Borro también los archivos relacionados? [Tú escribes] no"
Tú: "no"

# Con pi-ask-user
Pi: /ask-user confirm "¿Borrar este archivo?" options="sí,no"
Pi: [Aparece UI con botones]
Tú: [Click en "no"]
```

**La diferencia:** Sin escribir. Sin typos. Sin confusión.

### Escenarios donde uso:
- Borrar archivos riesgosos
- Seleccionar entre múltiples opciones
- Confirmar comandos peligrosos (`rm -rf`, `npm uninstall`)
- Recibir input estructurado

### Uso típico

```bash
/ask-user confirm "¿Borrar node_modules?" 
/ask-user select "¿Qué framework?" options="React,Vue,Svelte"
/ask-user input "¿Nombre del proyecto?"
```

**ROI:** 50% menos typos en comandos de usuario.

---

## 🥉 3. pi-rewind

**Paquete:** `npm:pi-rewind`

> Viajar en el tiempo en conversaciones

### Por qué es irremplazable

```bash
# 10 minutos atrás
/rewind

# 30 minutos atrás
/rewind 30m

# 1 hora atrás
/rewind 1h
```

**Escenario real:**
- Estaba trabajando en una feature
- La borré accidentalmente
- No me di cuenta hasta 10 minutos después
- `/rewind` → Vuelvo al estado donde existe

### Uso típico

```bash
/rewind            # 1 paso atrás
/rewind 10m        # 10 minutos atrás
/rewind list        # Ver puntos de viaje disponibles
```

**ROI:** 10 minutos ahorrados cada vez que borro algo sin querer.

---

## 4. pi-subagents

**Paquete:** `npm:pi-subagents` (Nico)

> Multi-agentes con chains, paralelos y 6 agentes builtin

### Por qué es irremplazable

```python
# Chain: scout → planner → worker
/chain scout "analiza el problema" planner "crea plan" worker "ejecuta"
```

**La magia:** No tienes que orquestar. El chain lo hace.

### Escenarios donde uso:
- Features complejas que requieren análisis → planificación → ejecución
- Múltiples subtareas en paralelo
- Workflows repetitivos (repetir misma secuencia 5+ veces)
- Testing con diferentes agentes

### Uso típico

```bash
/chain scout planner worker           # Simple chain
/parallel scout1 scout2 scout3      # 3 scouts en paralelo
/agent-manager                       # Ver/crear agentes
```

**ROI:** 3x más rápido en features complejas (no orquestas manualmente).

---

## 5. pi-serena-tools

**Paquete:** `npm:pi-serena-tools`

> Integración Serena LSP: símbolos, referencias, refactor

### Por qué es irremplazable

```python
# Encontrar dónde se usa algo
find_referencing_symbols(name_path="User.login")

# Renombar en todo el proyecto
rename_symbol(name_path="User.login", new_name="authenticate")
```

**Escenarios donde uso:**
- Refactors masivos (renombrar en 50+ archivos)
- Buscar dónde se usa una función/clase
- Entender estructura de código nuevo
- Ver jerarquía de tipos (TypeScript)

### Uso típico

```python
get_symbols_overview(path="src/")
find_referencing_symbols(name_path="X")
rename_symbol(name_path="X", new_name="Y")
```

**ROI:** Refactors en 30 segundos vs 1+ hora manual.

---

## 6. glimpsui

**Paquete:** `npm:glimpseui`

> UI nativa para scripts y agentes

### Por qué es irremplazable

```javascript
// Ventana WebView nativa
import { open } from 'glimpseui';

open(`
  <html>
    <body style="background: rgba(0,0,0,0.8);">
      <div style="background: white; border-radius: 12px; padding: 16px;">
        Status: Agente corriendo...
      </div>
    </body>
  </html>
`, { transparent: true, frameless: true });
```

**Escenarios donde uso:**
- Monitorear progreso de agentes (status pills)
- Previsualizar cambios de UI
- Crear demos para clientes
- HUDs flotantes durante ejecución larga

### Uso típico

```bash
/companion        # Status pill que sigue cursor
/glimpse file     # Abrir archivo en ventana
/glimpse url      # Abrir URL
```

**ROI:** Visualizar progreso sin salir de la terminal.

---

## 7. onetool-pi

**Paquete:** `npm:onetool-pi`

> OneTool MCP: 100+ tools unificados

### Por qué es irremplazable

```python
# Búsqueda web integrada
>>> br q="typescript error handling"

# Memoria persistente
>>> mem_w "key" value
>>> mem_r "key"

# Skills preconfigurados
>>> ot skill:typescript-analyzer
```

**Escenarios donde uso:**
- Búsqueda web rápida sin salir de Pi
- Guardar snippets en memoria persistente
- Workflows que requieren múltiples tools
- MCP proxying (route otros MCPs por OneTool)

### Uso típico

```bash
>>> br q="query"           # Búsqueda
>>> mem_w "key" value      # Guardar
>>> mem_r "key"             # Recuperar
>>> ot skill:xyz            # Skill
```

**ROI:** 50% menos context switching (no abrir navegador para buscar).

---

## 8. pi-tidy-mcp-adapter

**Paquete:** `npm:pi-tidy-mcp-adapter`

> Adaptador para MCPs no estándar

### Por qué es irremplazable

Permite conectar MCPs que Pi no soporta nativamente con un adaptador estándar.

### Escenarios donde uso:
- Proyectos con MCPs custom
- Integración con herramientas legacy
- MCPs con autenticación compleja

### Uso típico

```json
{
  "mcpServers": {
    "custom-mcp": {
      "command": "pi-tidy-mcp-adapter",
      "args": ["--mcp", "custom-tool"]
    }
  }
}
```

**ROI:** Usar cualquier MCP sin código custom.

---

## 9. custom-footer.ts

**Paquete:** Personal (en `~/.pi/agent/extensions/`)

> Status bar mejorado con tokens, cost, contexto, git branch

### Por qué es irremplazable

Mi footer muestra:
```
◆ glm-4-plus | 12k/5k | 78% | ⏱2m | ⌂ docs | ⎇ main
```

- Modelo actual
- Tokens usados
- Porcentaje de contexto
- Tiempo transcurrido
- Directorio actual
- Git branch

**Escenarios donde uso:**
- Siempre (está activo)
- Monitorear costo en tiempo real
- Ver cuánto contexto queda
- Saber en qué branch estoy

### Uso típico

Nada que configurar. Se activa en cada sesión.

**ROI:** Visibilidad total de sesión sin comandos.

---

## 🥇0 10. pi-studio

**Paquete:** `npm:pi-studio`

> Edición avanzada con 2 paneles + browser

### Por qué es irremplazable

```bash
pi-studio
# → Abre:
#    Panel 1: Código
#    Panel 2: Previsualización
#    Browser: Preview de cambios
```

**Escenarios donde uso:**
- Edición de componentes UI (véalo mientras edita)
- Proyectos frontend (React/Vue)
- Debugging en tiempo real
- Comparar antes/después

### Uso típico

```bash
pi-studio           # Abrir modo 2 paneles
pi-studio --file    # Abrir archivo específico
```

**ROI:** 3x más rápido en UI (véalo mientras edita).

---

## Extensiones que descarté

| Extensión | Por qué la descarté |
|-----------|---------------------|
| pi-plan-mode | Ant Colony lo hace mejor (automático vs manual) |
| pi-skills-sh | Prefiero usar skills directamente con `/skill:` |
| pi-tasks | Ant Colony es más automático (hands-off) |
| @tintinweb/pi-tasks | Lo mismo que pi-subagents pero menos maduro |
| Varios de diseño | Los prefiero como skills integrados |

---

## Mi orden de instalación para proyectos nuevos

```bash
# 1. Setup básico
npm install -g @mariozechner/pi-coding-agent
pi

# 2. Extensiones esenciales (en orden)
pi install npm:pi-context
pi install npm:pi-ask-user
pi install npm:pi-rewind
pi install npm:pi-serena-tools

# 3. Advanced (según el proyecto)
pi install npm:pi-subagents
pi install npm:glimpseui
pi install npm:pi-studio
pi install npm:onetool-pi

# 4. Personal (mi stack)
cp custom-footer.ts ~/.pi/agent/extensions/
```

---

## Comparación de uso diario

| Extensión | Sesiones donde uso | Ahorro estimado |
|-----------|-------------------|-----------------|
| pi-context | 90% | 2h/semana |
| pi-ask-user | 70% | 15 min/día |
| pi-rewind | 40% | 10 min/semana |
| pi-subagents | 30% | 1h/semana |
| pi-serena-tools | 80% | 3h/semana |
| glimpsui | 20% | 20 min/semana |
| onetool-pi | 85% | 1h/día |
| pi-tidy-mcp-adapter | 5% | 30 min/mes |
| pi-studio | 25% | 2h/semana |
| custom-footer.ts | 100% | 10 min/día (visibilidad) |

**Total:** ~8 horas ahorradas por semana.

---

## En resumen

1. **No instales por instalar** → si no lo usas en 50%+ de sesiones, desinstala
2. **Mi stack de producción:** pi-context, pi-ask-user, pi-rewind, pi-subagents, pi-serena-tools, glimpsui, onetool-pi, pi-tidy-mcp-adapter, pi-studio, custom-footer.ts
3. **El costo de todas:** ~$0.05 - $0.10 por sesión
4. **El ahorro:** ~8 horas/semana = ROI 100x
5. **Mi regla de oro:** Si no me ahorra tiempo medible → fuera

---

## 🔗 Recursos

- [Extensions](../03-extensions/README.md) - Todas las extensiones disponibles
- [pi.dev/packages](https://buildwithpi.ai/packages) - Marketplace de Pi
- [Custom Extensions](../11-tutoriales/avanzado/03-custom-extension.md) - Crear tus propias extensiones

---

## 💭 ¿Cuáles son tus extensiones irremplazables?

¿Qué extensiones no puedes vivir sin? ¿Alguna que probé y omití? Déjamelo en los comentarios.

---

**Tags:** `pi`, `extensiones`, `productividad`, `stack`, `workflow`

---

*Este artículo es parte de la serie [Pi Wiki](../README.md)*
