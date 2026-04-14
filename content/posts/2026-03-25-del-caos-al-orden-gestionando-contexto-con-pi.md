---
title: "Del caos al orden: gestionando contexto con Pi"
description: "Las sesiones de IA son como una pila de platos: pones uno encima de otro y se caen. Pi tiene 3 sistemas para transformar ese caos en orden predecible."
date: 2026-03-25
lastmod: 2026-03-25
categories: ["Pi"]
tags: ["pi", "context", "productividad"]
mode: guide
draft: false
---Las sesiones de IA son como una pila de platos: pones uno, otro, otro... eventualmente la pila se cae. Pi tiene 3 sistemas para manejar esto, y juntos transformaron el caos de mis sesiones en orden predecible.

---

## El problema: sesiones gigantes que se pierden

Imagina esta sesión típica:

```
09:00 - Empiezas a trabajar en una feature
10:30 - Agregas funcionalidad A
11:00 - Bug report, lo arreglas
12:00 - Meeting, pausas
13:00 - Vuelves, arreglas otro bug
14:30 - Alguien pregunta sobre el proyecto
15:00 - Respondes, sigues con la feature
16:00 - Refactorizas algo relacionado
17:00 - Feature casi terminada
17:30 - Terminas, pruebas, commit
```

**El problema:**
- 8.5 horas de contexto en una sola sesión
- El modelo "olvida" lo que hiciste a las 09:00
- No puedes volver a "cómo estaba esto antes de las 12:00"
- Cuando la sesión se rompe, pierdes TODO el contexto

En ChatGPT/Claude, esto es insuperable. Pi lo soluciona con **3 sistemas**.

---

## Sistema #1: Pi Context (gestión de sesiones)

Pi tiene un sistema de contexto inteligente que mantiene tu historial.

### Tags: save points

```bash
# Crear un tag
/tag create "feature-iniciada"

# Trabajas por horas...
# [Agregas funcionalidad A]

# Crear otro tag
/tag create "funcionalidad-a-completada"

# [Arreglas bug]

# Crear otro tag
/tag create "bug-arreglado"
```

**La magia:**

```bash
# Si sales mal, vuelve al estado exacto
/tag checkout "funcionalidad-a-completada"
# → Vuelves a las 10:30 exactamente
```

### Branching: explorar en paralelo

```bash
# Crear un branch
/tag branch "experimento-a"
# [Experimentas con solución A]

# Crear otro branch
/tag branch "experimento-b"
# [Experimentas con solución B]

# Comparar
/tag diff "experimento-a" "experimento-b"

# Mergear
/tag merge "experimento-a"
```

**Escenario real:**

Tengo que refactorizar una función crítica. En lugar de romperla y arreglarla:

```bash
/tag branch "refactor-opcion-1"
# [Refactor con patrón A]

/tag checkout "main"
/tag branch "refactor-opcion-2"
# [Refactor con patrón B]

# Pruebas de performance para ambas
>>> npm run benchmark opcion-1
>>> npm run benchmark opcion-2

/tag checkout "refactor-opcion-2"  # Mejor opción
```

**Resultado:** 2 refactorizaciones probadas, 0 riesgo de romper algo.

---

## Sistema #2: Sessions branching de Pi

Pi tiene branching nativo de sesiones, no solo de tags.

### Crear branches de sesión

```bash
# Crear un nuevo branch desde el actual
/branch create "experimento-nuevo"

# Trabajas en el nuevo branch
# [Pruebas, cambios, etc.]

# Volver al branch principal
/branch checkout "main"
```

### Merge de sesiones

```bash
# Merge un branch
/branch merge "experimento-nuevo"
# → Trae TODO el contexto del branch
```

**Escenario real:**

Trabajo en una feature compleja con 3 sub-features:

```bash
/branch create "feature-auth"
# [Trabajas en autenticación completa]

/tag create "auth-login"
# [Login completado]

/tag create "auth-register"
# [Register completado]

/tag create "auth-password-reset"
# [Password reset completado]

/branch checkout "main"
/branch merge "feature-auth"
# → Merge TODA la feature de una vez
```

---

## Sistema #3: Compaction (gestión automática)

Pi tiene compaction automática que comprime contexto viejo.

```json
{
  "compaction": {
    "enabled": true,
    "reserveTokens": 19200,
    "keepRecentTokens": 19200
  }
}
```

**Cómo funciona:**

1. Sesión crece → 50,000 tokens
2. Compaction se activa → comprime a 19,200 tokens recientes
3. Contexto viejo → resumen en background
4. Modelo ve contexto completo (reciente + resumen)

**La diferencia:**
- Sin compaction → modelo ve 50,000 tokens, se ahoga
- Con compaction → modelo ve 19,200 recientes + resumen, funciona perfecto

---

## Mi workflow completo de contexto

### Setup inicial

```bash
# 1. Crear tag de inicio
/tag create "sesion-iniciada"

# 2. Activar compaction
/settings
# → Habilitar compaction con reserveTokens: 19200
```

### Durante el día

```
09:00 /tag create "feature-login"
# [Trabajas en login]

11:00 /tag create "login-completado"
# [Pruebas, integración]

13:00 /tag create "bug-arreglado"
# [Reporte de bug, arreglado]

15:00 /tag create "refactor-completado"
# [Refactor de login]

17:00 /tag create "dia-terminado"
```

### Si algo sale mal

```bash
# Bug introducido en refactor
/tag checkout "login-completado"
# → Vuelves a las 11:00 antes del refactor
```

---

## Comparación: Pi vs ChatGPT para contexto

| Aspecto | ChatGPT | Pi |
|---------|----------|----|
| **Historial persistente** | ❌ No (se pierde al cerrar sesión) | ✅ Sí (tags, branches) |
| **Save points** | ❌ No | ✅ Sí (`/tag create`) |
| **Branching** | ❌ No (solo un hilo) | ✅ Sí (`/branch create`) |
| **Compaction** | ❌ Manual (borrar mensajes) | ✅ Automática |
| **Volver atrás** | ❌ No | ✅ Sí (`/tag checkout`) |
| **Mergear contextos** | ❌ No | ✅ Sí (`/branch merge`) |

> 💡 **Tip:** Pi tiene la extensión pi-context, que añade aún más funciones de gestión de contexto.

---

## Ejemplo completo: Refactor riesgoso

**Objetivo:** Refactorizar el servicio de pagos (crítico, no puedo romperlo).

### Sin Pi (antes)

```
1. Hago copia del servicio
2. Refactorizo (riesgoso)
3. Tests pasan
4. Deploy
5. BUG: producción rompida
6. No puedo volver atrás (borré la copia por error)
7. 4 horas de debugging
8. Rollback manual
```

### Con Pi (ahora)

```bash
# 1. Save point
/tag create "pre-refactor-pagos"

# 2. Branch para el refactor
/tag branch "refactor-pagos-v1"

# 3. Refactorizo
# [Trabajo en PaymentService]

# 4. Tests pasan → Commit

# 5. Deploy
# [A producción]

# 6. BUG en producción

# 7. Instant rollback
/tag checkout "pre-refactor-pagos"
# → Vuelvo al estado antes del refactor en 1 segundo

# 8. Root cause con el contexto del refactor
/tag checkout "refactor-pagos-v1"
# [Analizo qué rompí]

# 9. Fix con el contexto
# [Corrección segura]

# 10. Deploy del fix
# [A producción, funciona]

# 11. Merge del fix
/tag merge "refactor-pagos-v1"
```

**Resultado:**
- Sin Pi: 4 horas perdidas
- Con Pi: 15 minutos (instant rollback, fix seguro, redeploy)

---

## Patrones de uso de contexto

### Patrón #1: Save points antes de cambios riesgosos

```bash
/tag create "pre-refactor"
# [Refactor]
/tag create "post-refactor"
```

### Patrón #2: Branches para experimentos

```bash
/tag branch "opcion-a"
# [Prueba A]
/tag checkout "main"

/tag branch "opcion-b"
# [Prueba B]

/tag checkout "main"
# Comparar y elegir mejor
```

### Patrón #3: Tags por feature

```bash
/tag create "feature-login-start"
# [Login]
/tag create "feature-login-end"
# [Login completado]

/tag create "feature-payment-start"
# [Pagos]
/tag create "feature-payment-end"
# [Pagos completados]
```

### Patrón #4: Daily checkpoints

```bash
/tag create "dia-1"
# [Trabajas]

/tag create "dia-2"
# [Trabajas]

/tag create "dia-3"
# [Trabajas]
# Si algo sale mal en día 3:
/tag checkout "dia-2"
# → Vuelves al estado del día anterior
```

---

## Comandos esenciales

### Tags

| Comando | Descripción |
|----------|-------------|
| `/tag list` | Ver todos los tags |
| `/tag create "nombre"` | Crear un tag |
| `/tag checkout "nombre"` | Volver a un tag |
| `/tag diff "a" "b"` | Ver diferencia entre tags |
| `/tag delete "nombre"` | Borrar un tag |

### Branches

| Comando | Descripción |
|----------|-------------|
| `/branch list` | Ver todos los branches |
| `/branch create "nombre"` | Crear un nuevo branch |
| `/branch checkout "nombre"` | Cambiar a un branch |
| `/branch merge "nombre"` | Merge un branch |
| `/branch delete "nombre"` | Borrar un branch |

### Compaction

| Comando | Descripción |
|----------|-------------|
| `/settings` | Abrir settings UI |
| Habilitar compaction | `compaction: { enabled: true }` |

---


1. **El problema:** Sesiones gigantes que se pierden, no hay save points, no hay branching
2. **Sistema #1: Tags** → Save points, volver atrás, diffs
3. **Sistema #2: Branches** → Explorar en paralelo, merge contextos
4. **Sistema #3: Compaction** → Compresión automática de contexto viejo
5. **Mi workflow:** Tags por feature + branches para experimentos + compaction automática
6. **El resultado:** Del caos de sesiones infinitas al orden predecible

---

## 🔗 Recursos

- [Por qué Pi cambió mi workflow de desarrollo](/posts/2026-03-23-pi-cambio-mi-workflow/) - Contexto general sobre Pi
- [Ant Colony: cuando un agente no es suficiente](/posts/2026-03-25-ant-colony-cuando-un-agente-no-es-suficiente/) - Trabajo masivo con múltiples agentes
- [Debugging con Pi: del stack trace al fix](/posts/2026-04-04-debugging-con-pi-del-stack-trace-al-fix/) - Flujo de troubleshooting y verificación

---

## 💭 ¿Cómo manejas tus sesiones?

¿Usas alguna otra técnica? ¿Algún patrón que funcione mejor que estos? Déjamelo en los comentarios.
