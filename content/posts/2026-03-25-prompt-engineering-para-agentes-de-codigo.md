---
title: "Prompt engineering para agentes de código"
date: 2026-03-25
categories: ["AI"]
tags: ["prompt-engineering", "agentes", "pi", "ia", "context-engineering"]
readingTime: 11
draft: false
---


**Publicado:** 2026-03-25 | **Categoría:** AI | **Lectura:** 11 min

2026 trajo un cambio que nadie está hablando: el prompt engineering tradicional está muriendo. Lo que reemplaza no es "mejor prompting", es **context engineering + agentes**. Y tu terminal es el mejor lugar para hacerlo.

---

## 🎯 Lo que aprenderás

- Por qué los prompts gigantes no funcionan en 2026
- Cómo Pi cambia las reglas del juego con herramientas
- Mis patrones de prompting para agentes de código
- Las 3 reglas de oro para prompts efectivos

---

## El problema: "El prompt gigante de 2024"

Si has usado ChatGPT/Claude en 2024, sabes el patrón:

```
Prompt de 500 líneas:
- "Eres un desarrollador senior con 15 años de experiencia..."
- "Siempre usa TypeScript..."
- "Sigue SOLID, Clean Code, DDD..."
- "El proyecto está en /ruta/al/proyecto..."
- "La arquitectura es..."
- "Los archivos son..."
- "La convención es..."
- "Cuando encuentres error, haz X, Y, Z..."
- [otras 450 líneas...]
```

**El problema:**
- El modelo se agota en las primeras 100 líneas
- Los últimos 400 líneas son contexto olvidado
- Terminas con código que ignora la mitad del prompt
- Pasas 45 minutos limpiando el mess

El mercado de prompt engineering llegó a $505M en 2025. La mayoría de ese dinero se gastó en prompts que no funcionaban.

---

## El cambio de 2026: Context Engineering

La nueva verdad es esta:

> **Un prompt gigante no es mejor prompting. Es mal diseño de contexto.**

Lo que funciona en 2026 no es:
- ❌ Prompt más largo
- ❌ Más palabras clave ("expert", "senior", "top-tier")
- ❌ Plantillas más complejas

Lo que funciona es:
- ✅ **Contexto compartido** (agente ve lo mismo tú ves)
- ✅ **Iteración rápida** (ejecuta, prueba, corrige)
- ✅ **Herramientas primero** (usa tools, no solo texto)
- ✅ **Estado incremental** (construye solución paso a paso)

Pi está construido EXACTAMENTE para esto.

---

## Por qué Pi es mejor que ChatGPT para prompting

| Aspecto | ChatGPT | Pi |
|---------|----------|----|
| **Acceso a archivos** | ❌ Manual (copias/pega) | ✅ Directo (read/write) |
| **Ejecución real** | ❌ No (simulada) | ✅ Real (bash, tests) |
| **Iteración** | ⚠️ Lenta (copia/pega) | ✅ Instantánea (edit en el lugar) |
| **Estado compartido** | ❌ No (prompt gigante) | ✅ Sí (agent ve el mismo que tú) |
| **Verificación** | ⚠️ Manual (tú pruebas) | ✅ Automática (ejecuta tests) |

> 💡 **Tip:** La mejor forma de "prompting" en Pi es dejar que el agente explore, lea y entienda por sí mismo.

---

## Mis patrones de prompting en Pi

### Patrón 1: "Explora, luego decide"

```python
# ❌ Mal prompting (vieja escuela)
Pi: "Crea un sistema de usuarios con auth, roles, permisos, con TypeScript, siguiendo SOLID, con tests..."
# → 200 líneas, modelo se pierde, resultado mediocre

# ✅ Buen prompting (context engineering)
Pi: "Explora el proyecto en src/users/ y crea un sistema de usuarios con auth, roles y permisos"
# → Agente explora archivos, entiende estructura, crea solución coherente
```

**La diferencia:** El agente lee tu código primero, entiende tu arquitectura, y luego crea algo que encaja.

---

### Patrón 2: "Iteración rápida"

```python
# ❌ Intentar hacerlo perfecto en el primer intento
Pi: "Crea una API REST completa con 10 endpoints, validación, autenticación, rate limiting, documentación..."
# → Falla en 3 cosas, pasas 45 minutos corrigiendo

# ✅ Iterar en pequeños pasos
Pi: "Crea el endpoint POST /users con validación básica"
# → Funciona
Pi: "Ahora añade autenticación"
# → Funciona
Pi: "Ahora añade rate limiting"
# → Funciona
```

**La diferencia:** 15 minutos de iteración vs 45 minutos de "perfecto a la primera".

---

### Patrón 3: "Herramientas primero, prompting después"

```python
# ❌ Pedir que haga todo con texto
Pi: "Analiza el archivo auth.js y escribe tests que cubran todos los casos edge"

# ✅ Pedir que use herramientas
Pi: "Usa get_symbols_overview() en auth.js y encuentra todas las funciones, luego escribe tests para cada una"
```

**La diferencia:** Con herramientas, el agente ve TODO tu código, no solo lo que pegas en el prompt.

---

### Patrón 4: "Estado incremental"

```python
# ❌ Reiniciar desde cero cada vez
Pi: "Añade feature X"
# [Agregas feature X]
Pi: "Ahora añade feature Y, pero mantén feature X"
# → Agente olvidó detalles de X

# ✅ Mantener estado incremental
# [Crea feature X]
# [Verifica que funciona]
# [Añade feature Y, agente VE feature X en el código]
```

**La diferencia:** La sesión de Pi mantiene TODO el contexto. El agente ve que agregaste X y puede construir Y encima.

---

## Las 3 reglas de oro de prompting en Pi

### Regla #1: Corto > Largo

```
❌ Prompt de 500 líneas
✅ Prompt de 3 líneas con herramienta
```

**Por qué:** Los modelos tienen límites de atención. Más contexto ≠ mejor comprensión. Mejor tener 3 líneas de instrucciones + el código completo del proyecto, que 500 líneas de instrucciones + 0 código.

**Ejemplo:**

```python
# ❌ Mal
Pi: """
  Eres un desarrollador senior de TypeScript con 15 años de experiencia
  especializado en arquitecturas escalables, microservicios, DDD...
  El proyecto está en /src/
  La arquitectura sigue Clean Architecture...
  Siempre usa SOLID...
  Cuando encuentres error, primero loguea, luego lanza...
  [200 líneas más]
"""

# ✅ Bien
Pi: "Analiza el proyecto con get_symbols_overview(src/), entiende la arquitectura, y refactórala siguiendo SOLID"
```

---

### Regla #2: Exploración > Especificación

```
❌ "Crea X que haga Y, con feature A, B, C, D, E..."
✅ "Explora el código para entender X, luego implementa Y con features necesarias"
```

**Por qué:** Tu código ya sabe qué necesita. No necesitas especificar todo en el prompt. Mejor dejar que el agente lea y entienda.

**Ejemplo:**

```python
# ❌ Mal
Pi: "Crea un middleware de autenticación que:
  1. Valide JWT tokens
  2. Chequee rate limiting
  3. Registre todos los intentos
  4. Soporte refresh tokens
  5. Maneje errores específicos
  6. Siga la convención de logs del proyecto
  [más especificaciones...]
"

# ✅ Bien
Pi: "Lee auth-middleware.ts, entiende el patrón actual, y añade rate limiting manteniendo compatibilidad"
```

---

### Regla #3: Verificación automática > Manual

```
❌ "Escribe tests, luego tú ejecutas npm test"
✅ "Escribe tests Y ejecuta npm test para verificar que pasan"
```

**Por qué:** En Pi, el agente puede ejecutar comandos. Úsalo. Deja que el agente se auto-verifique.

**Ejemplo:**

```python
# ❌ Mal
Pi: "Escribe tests para el endpoint /users"

# ✅ Bien
Pi: "Escribe tests para /users, ejecuta npm test, y si falla algún test, corrigelo"
```

**Resultado:** El agente escribe tests, los ejecuta, ve los fallos, los corrige, y tú tienes tests que pasan.

---

## Ejemplo completo: Refactor real

**Objetivo:** Refactorizar un servicio que tiene 200 líneas y hace 5 cosas.

### Prompt vieja escuela (no usar)

```
Pi: """
  Refactoriza el servicio UserService en src/users/service.ts:
  
  - Divide las 5 responsabilidades en 5 clases separadas
  - Usa inyección de dependencias
  - Aplica patrón Repository
  - Añade TypeScript types estrictos
  - Asegura que tests sigan pasando
  - Sigue SOLID
  - [100 líneas más de especificaciones...]
"""
```

**Resultado:**
- 5 minutos de procesamiento
- Refactor que rompe 2 cosas
- Tests fallan
- 30 minutos de corrección manual

### Prompt Pi (usar)

```
Pi: """
  1. Usa get_symbols_overview() para entender UserService
  2. Identifica las 5 responsabilidades
  3. Crea 5 clases separadas, una por responsabilidad
  4. Mueve la lógica apropiada a cada clase
  5. Ejecuta npm test y corrige fallos
"""
```

**Resultado:**
- 8 minutos total
- 5 clases creadas
- Responsabilidades separadas
- Tests pasando

---

## Comparación: Prompt vieja escuela vs Pi

| Métrica | Prompt vieja escuela | Prompt Pi |
|----------|---------------------|-----------|
| Tiempo total | 35 min | 8 min |
| Tokens usados | 12,000 | 4,500 |
| Código resultante | 200 líneas (rompe 2 tests) | 210 líneas (todos tests pasan) |
| Tiempo de corrección | 30 min | 0 min |
| Costo | $0.15 | $0.04 |

**El ROI:** 75% menos tiempo, 73% menos costo, mejor resultado.

---

## Errores comunes de prompting en Pi

### Error #1: Sobrespecificar

```python
❌ Pi: "Crea un endpoint que acepte POST con body X, valida A, B, C, hace D, E, F, retorna Z, con código de estado Y..."
✅ Pi: "Crea un endpoint POST /users basado en el patrón de endpoints existentes en src/api/"
```

### Error #2: No usar herramientas

```python
❌ Pi: "Analiza la estructura del proyecto"
✅ Pi: "Usa find_symbol() para encontrar servicios y get_type_hierarchy() para ver relaciones"
```

### Error #3: Pedir en lugar de dejar explorar

```python
❌ Pi: "Los archivos son X, Y, Z. Basándote en eso, crea..."
✅ Pi: "Explora el proyecto con get_symbols_overview(), entiende la arquitectura, y crea..."
```

### Error #4: Reiniciar en lugar de iterar

```python
❌ Pi: "Haz X. [Esperas] Ok ahora haz Y, pero mantén X..."
✅ Pi: "Haz X. [Esperas, X funciona] Ahora haz Y encima de X."
```

---

## Tendencias de prompt engineering para 2026

Según IBM, PromptBestie, Cursor y Dev.to:

1. **Context Engineering** reemplaza al prompting tradicional → Compartir estado, no reiniciar
2. **Agentic Systems** → Agents que planifican y ejecutan autónomamente
3. **Tool-First Approach** → Usa herramientas antes de texto
4. **Iterative Verification** → Ejecuta, prueba, corrige, repite
5. **Minimal Prompts** → Menos es más. Deja que el agente explore.

Pi está diseñado exactamente para estas tendencias.

---

## En resumen

1. **El prompt gigante murió en 2024** → Lo que funciona es context engineering
2. **Corto > Largo** → 3 líneas de instrucciones + herramientas > 500 líneas de especificaciones
3. **Exploración > Especificación** → Deja que el agente lea tu código, no que le digas
4. **Herramientas > Texto** → Usa read, write, get_symbols, no solo prompting
5. **Iteración > Perfección** → Construye paso a paso, no a la primera
6. **Verificación automática > Manual** → Deja que el agente ejecute tests

---

## 🔗 Recursos

- [Por qué Pi cambió mi workflow de desarrollo](/posts/2026-03-23-pi-cambio-mi-workflow/) - El flujo base que describe este artículo
- [Del caos al orden: gestionando contexto con Pi](/posts/2026-03-25-del-caos-al-orden-gestionando-contexto-con-pi/) - Cómo sostener sesiones largas
- [Debugging con Pi: del stack trace al fix](/posts/2026-04-04-debugging-con-pi-del-stack-trace-al-fix/) - Verificación y feedback rápido

---

## 💭 ¿Qué prompting patterns usas tú?

¿Tienes algún truco que funcionó mejor que los míos? ¿Algún error que repetís? Déjamelo en los comentarios.

---

**Tags:** `prompt-engineering`, `agentes`, `pi`, `ia`, `context-engineering`

---

*Este artículo forma parte de la categoría [Pi](/categories/pi/)*
