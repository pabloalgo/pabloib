---
title: "Ant Colony: cuando un agente no es suficiente"
description: "Cuando un solo agente se ahoga en tu código, no necesitas un mejor modelo. Necesitas más agentes. Así funciona Ant Colony y el patrón multi-agente en Pi."
date: 2026-03-25
categories: ["Pi"]
tags: ["ant-colony", "pi", "agentes", "productividad"]
readingTime: 10
draft: false
---


**Publicado:** 2026-03-25 | **Categoría:** Pi | **Lectura:** 10 min

Después de usar agentes de IA durante meses, me di cuenta de algo obvio que nadie te dice: cuando un solo agente se ahoga en tu código, no necesitas un mejor modelo. Necesitas más agentes.

---

## 🎯 Lo que aprenderás

- Por qué un solo agente tiene límites reales en tareas grandes
- Cómo Ant Colony divide, paraleliza y verifica automáticamente
- Mi experiencia real migrando 50 archivos con Ant Colony vs ChatGPT

---

## El problema del agente único

Imagina que le pides a un solo desarrollador:

> "Migra todo el proyecto de CommonJS a ESM, actualiza imports, exports, tests, y documentación"

Ese desarrollador va a:
1. Abrir 50 archivos uno por uno
2. Mantener en la cabeza el estado de cada archivo
3. Olvidar qué cambió en el archivo #3 cuando está en el #27
4. No poder verificar todos los cambios sin ejecutar todo el proyecto
5. Tomar semanas, cansarse, cometer errores

Los agentes de IA tienen el mismo problema. Son excelentes para **tareas unitarias**:
- ✅ "Arregla este bug en auth.js"
- ✅ "Añade un test para UserService.login"
- ✅ "Refactoriza esta función de 50 líneas"

Pero se ahogan en **tareas masivas**:
- ❌ "Migra todo el proyecto"
- ❌ "Añade tests a toda la codebase"
- ❌ "Refactoriza 20 servicios a la nueva arquitectura"

El problema no es el modelo. Es la **carga cognitiva**. Nadie puede mantener 50 archivos en la cabeza, ni siquiera una IA.

---

## El momento de descubrimiento

Hace unos meses, tenía una tarea: migrar un proyecto real de backend (microservicios) de CommonJS a ESM. La estructura era:

```
backend/
├── auth/ (8 archivos)
├── users/ (12 archivos)
├── payments/ (15 archivos)
├── notifications/ (6 archivos)
├── shared/ (9 archivos)
└── tests/ (innumerables tests.spec.js)
```

**50 archivos** para migrar. Mi primer instinto fue ChatGPT.

```
Yo: "Migra todos los archivos .js de CommonJS a ESM"
ChatGPT: [Dame ejemplos de cómo migrar uno por uno]
Yo: "Ok, pero hazlo por mí"
ChatGPT: "No puedo acceder a tus archivos. Dame el código..."
```

3 horas después. Había migrado 3 archivos. Estaba cansado. Frustrado.

Entonces recordé: **Ant Colony está built-in en Pi**.

---

## Ant Colony: un enjambre, no un agente

Ant Colony no es "otro agente". Es un **sistema multi-agente** que divide tu tarea masiva en subtareas y las ejecuta en paralelo.

### Los roles

| Hormiga | Qué hace | Cuándo |
|---------|-----------|--------|
| **Scout** 🔍 | Explora, descubre, entiende el problema | Al principio |
| **Worker** ⚒️ | Ejecuta tareas: lee, escribe, edita | Durante el trabajo |
| **Soldier** 🛡️ | Revisa calidad, verifica, corrige | Después de cada worker |
| **Drone** 🤖 | Ejecuta comandos bash simples | Cuando se necesita la terminal |

La magia: **no los orquestas tú**. El enjambre se auto-organiza.

### Cómo funciona

```
1. Tu tarea masiva
   ↓
2. Scout explora → descubre 50 archivos JS
   ↓
3. Divide en subtareas → 50 workers en paralelo
   ↓
4. Workers migran cada archivo → 50 subtareas ejecutadas
   ↓
5. Soldiers verifican → tests pasan, imports correctos
   ↓
6. Reintenta automáticamente si falla (hasta 3x)
   ↓
7. Te entrega el resultado
```

**La diferencia:** No copias. No pegas. No explicas 50 veces qué hace cada archivo. Lanzas, y el enjambre lo resuelve.

---

## Mi migración con Ant Colony

```python
# En Pi
ant_colony(goal="Migra todos los archivos .js de CommonJS a ESM, actualizando imports, exports y ejecutando tests")
```

**30 minutos después:**
- ✅ 50 archivos migrados
- ✅ Imports actualizados
- ✅ Exports corregidos
- ✅ Tests pasando
- ✅ Nada roto

El enjambre había:
- Scout: Descubierto los 50 archivos
- Workers: Migrado cada uno en paralelo
- Soldiers: Verificado que tests pasaran
- Drones: Ejecutado `npm test` al final

**Resultado:** 3 horas de ChatGPT vs 30 minutos de Ant Colony.

---

## ¿Cuándo NO usar Ant Colony?

Ant Colony es poderoso pero no es un martillo para todo clavo.

| Situación | Usa | No uses |
|-----------|------|---------|
| Bug en un archivo | Pi directo | Ant Colony |
| Añadir una función | Pi directo | Ant Colony |
| Refactor de 1 módulo | Pi directo | Ant Colony |
| Migración masiva | Ant Colony | Pi directo |
| 50 tests que escribir | Ant Colony | Pi directo |
| Análisis profundo de la base de código | Ant Colony | Pi directo (o Serena) |

**Regla de oro:**
- Tarea unitaria → Pi directo
- Tarea masiva → Ant Colony

---

## Comparación: Ant Colony vs ChatGPT/Claude

| Aspecto | Ant Colony | ChatGPT/Claude |
|---------|-------------|-----------------|
| **Acceso a archivos** | Directo (lee/escribe) | Manual (copia/pega) |
| **Paralelismo** | 50 subtareas a la vez | 1 tarea a la vez |
| **Verificación** | Automática (soldiers) | Manual (tú) |
| **Reintentos** | Automáticos (hasta 3x) | Ninguno |
| **Estado compartido** | Enjambre ve todo | Ninguno (prompt gigante) |
| **Costo real** | $0.10 - $0.50 | $0.05 - $0.20 |
| **Tiempo real** | 10-30 min | 2-4 horas |

> 💡 **Tip:** El costo de Ant Colony es más alto porque usa MÁS tokens, pero el tiempo ahorrado es infinito.

---

## El secreto: comunicación por feromonas

Ant Colony está inspirado en colonias de hormigas reales. Las hormigas dejan feromonas para que otras hormigas sepan qué encontraron.

En Pi, esto funciona así:

1. Scout explora y deja "feromonas": "Este archivo es ESM-ready"
2. Worker recoge la feromona: "Ok, este archivo no lo toco"
3. Otro worker encuentra un archivo JS: "Este CommonJS, lo migro"
4. Soldier verifica y deja feromona: "Este test pasa"

Nadie repite trabajo. El enjambre **comparte estado automáticamente**.

---

## Cómo usar Ant Colony hoy

### Instalación (ya built-in en Pi)

Ant Colony viene **pre-instalado** en Pi. No necesitas instalar nada.

Pero también existe como extensión con features adicionales:

```bash
# Si quieres la extensión con feromonas avanzadas
npm install @ifiokjr/oh-pi-ant-colony
pi install npm:@ifiokjr/oh-pi-ant-colony
```

### Comandos básicos

```python
# Tarea masiva simple
ant_colony(goal="Migra todos los .js a ESM")

# Con límite de costo
ant_colony(
  goal="Tu tarea masiva",
  maxCost=5.00
)

# Con límite de hormigas (para no saturar)
ant_colony(
  goal="Tu tarea",
  maxAnts=3
)

# Con modelos específicos (baratos vs caros)
ant_colony(
  goal="Tu tarea",
  scoutModel="glm/glm-4",           # Barato para explorar
  workerModel="glm/glm-4-plus",      # Medio para ejecutar
  soldierModel="claude-sonnet-4"     # Caro para verificar
)
```

### Panel de control

```bash
/colony-status      # Ver qué están haciendo las hormigas
/colony-stop        # Detener enjambre si se va de las manos
/colony-resume      # Reanudar desde donde lo dejaste
Ctrl+Shift+A        # Panel detallado con métricas
```

---

## Ejemplos reales de uso

### 1. Migración masiva

```python
ant_colony(goal="Migra todos los archivos de CommonJS a ESM")
```

**Resultado:** 50 archivos migrados en 30 min.

### 2. Tests en masa

```python
ant_colony(goal="Escribe tests para todos los endpoints de la API")
```

**Resultado:** 30 tests escritos, cobertura 80%.

### 3. Refactor de arquitectura

```python
ant_colony(
  goal="Refactoriza todos los servicios para usar el nuevo patrón de inyección de dependencias"
)
```

**Resultado:** 12 servicios refactorizados, tests actualizados.

### 4. Documentación automática

```python
ant_colony(
  goal="Añade JSDoc a todas las funciones sin documentar"
)
```

**Resultado:** 200 funciones documentadas.

---

## ¿Diferencia con pi-subagents?

Pi tiene otro sistema multi-agente: `pi-subagents` (de Nico).

| Sistema | Diferencia principal |
|---------|---------------------|
| **Ant Colony** | Lanza y olvida (hands-off, automatización) |
| **pi-subagents** | Orquestación manual (control fino, chains, paralelos) |

**Mi regla:**
- Quieres que se haga solo → Ant Colony
- Quieres controlar cada paso → pi-subagents

> 💡 **Tip:** Juntos son lo mejor de ambos mundos. Ant Colony para la masiva, pi-subagents para la estructurada.

---

## En resumen

1. **Un solo agente se ahoga en tareas masivas** → no es el modelo, es la carga cognitiva
2. **Ant Colony divide, paraleliza, verifica automáticamente** → un enjambre que se auto-organiza
3. **Tareas unitarias → Pi directo, tareas masivas → Ant Colony**
4. **El costo es mayor, pero el tiempo ahorrado es infinito** → 3 horas vs 30 minutos
5. **No necesitas instalar nada** → viene built-in en Pi

---

## 🔗 Recursos

- [Por qué Pi cambió mi workflow de desarrollo](/posts/2026-03-23-pi-cambio-mi-workflow/) - Contexto general sobre Pi
- [Prompt engineering para agentes de código](/posts/2026-03-25-prompt-engineering-para-agentes-de-codigo/) - Cómo escribir mejores tareas
- [Debugging con Pi: del stack trace al fix](/posts/2026-04-04-debugging-con-pi-del-stack-trace-al-fix/) - Verificación y corrección

---

## 💬 ¿Has usado Ant Colony?

¿Qué tareas masivas has resuelto con Ant Colony? ¿Cuál ha sido tu experiencia? Déjamelo en los comentarios.

---

**Tags:** `ant-colony`, `multi-agente`, `pi`, `productividad`, `automatización`

---

*Este artículo forma parte de la categoría [Pi](/categories/pi/)*
