---
title: "Debugging con Pi: del stack trace al fix"
date: 2026-04-04
categories: ["Pi"]
tags: ["pi", "debugging", "productividad", "tutorial"]
readingTime: 10
draft: false
---


**Publicado:** 2026-04-04 | **Categoría:** Pi | **Lectura:** 10 min

Lo que nadie te dice: Pi es mejor para debugging que tu IDE. Veo el stack trace, leo el código, encuentro el root cause y propongo el fix — todo en el mismo contexto, sin cambiar de ventana.

---

## 🎯 Lo que aprenderás

- Por qué Pi transforma debugging de tedioso a rápido
- Cómo usar Serena para navegar stack traces
- Comandos específicos para debugging
- Mi workflow de producción para bugs complejos

---

## El problema: debugging sin Pi

Debugging típico en VS Code:

```
1. Error en runtime
2. Copy stack trace
3. Paste en Google (o stackoverflow)
4. Abrir 10+ tabs de SO
5. Leer respuestas (muchas obsoletas)
6. Encontrar una prometedora
7. Abrir archivo en VS Code
8. Buscar función/variable
9. Analizar contexto
10. Proponer fix
11. Probar fix
12. Volver a 1 si falló
```

**El problema:**
- 30+ minutos para un bug simple
- Context switching constante (IDE ↔ navegador ↔ terminal)
- SO answers obsoletas (Python 2.7 cuando usas 3.11)
- Stack traces largos que no entiendes
- Perder el hilo del por qué llegaste ahí

Con Pi, todo esto cambia.

---

## Por qué Pi es mejor para debugging

### 1. Stack trace → código fuente (instantáneo)

```
Tú: [Pegas stack trace]

Pi: [Lee el stack trace]
    [Encuentra el archivo en tu repo]
    [Lee la función que causó el error]
    [Analiza el contexto]
    → "El error está en src/auth/service.ts:45"
```

Sin salir de Pi. Sin abrir archivos manualmente. Sin Google.

### 2. Root cause analysis (automático)

```
Tú: "¿Por qué falla esto?"

Pi: [Analiza todo el call stack]
    [Ve dependencias entre funciones]
    [Identifica el patrón de error]
    → "La función validate() retorna undefined cuando el input está vacío,
       pero la función login() asume que siempre retorna un string.
       Esto causa el TypeError en el siguiente paso."
```

No solo te dice QUÉ falló. Te dice POR QUÉ.

### 3. Fix propuesto + explicación

```
Tú: "Propón un fix"

Pi: [Genera patch]
    [Añade tests que cubren el bug]
    [Explica por qué funciona]

Patch:
    + const result = validate(input);
    + if (!result) return null; // Handle empty input
```

No es solo código. Es un fix completo con tests.

---

## Workflow completo de debugging con Pi

### Paso 1: Capturar el error

```bash
# Correr el comando que falla
npm test

# Output:
TypeError: Cannot read properties of undefined (reading 'token')
    at AuthService.login (src/auth/service.ts:45)
    at UserController.postLogin (src/controllers/user.ts:12)
    at Router.handle (src/router/index.ts:89)
```

### Paso 2: Pegar el stack trace en Pi

```bash
pi

# Tú: [Pegas el stack trace completo]
```

### Paso 3: Análisis automático

Pi hace:

1. **Parse stack trace** → extrae archivo, línea, función
2. **Lee el código** → usa Serena para navegar al archivo
3. **Analiza contexto** → entiende el flujo de ejecución
4. **Encuentra root cause** → identifica el patrón del error
5. **Propone solución** → genera patch + tests

### Paso 4: Aplicar el fix

```bash
# Pi genera el patch
# Tú revisas:
- ¿Es correcto?
- ¿Afecta otras partes del código?
- ¿Los tests cubren el caso?

# Si estás de acuerdo:
pi
# Tú: "Aplica el fix"

# [Pi aplica el patch]
# [Pi corre tests]
# [Pi verifica que pasan]
```

---

## Comandos específicos para debugging

### 1. get_symbol_at_path

Ver qué hay en el punto del error:

```python
# Pi usa esto internamente cuando ve un stack trace
get_symbol_at_path(
    file_path="src/auth/service.ts",
    line=45,
    column=0
)

# → Ve: async function login(credentials: LoginDTO): Promise<AuthResponse>
```

### 2. get_references

Dónde se usa la función con error:

```python
get_references(
    symbol_name="login",
    file_path="src/auth/service.ts"
)

# → Lista todos los lugares donde se llama a login()
```

### 3. search_code

Buscar patrones de error en todo el repo:

```python
search_code(
    pattern="Cannot read properties of undefined",
    case_sensitive=False
)

# → Encuentra todos los lugares donde este error podría ocurrir
```

### 4. /skill:debugger

Skill especializado de debugging:

```bash
/skill:debugger src/auth/service.ts:45
# → Analiza línea 45, propone debugging steps
```

---

## Ejemplo real: Bug en autenticación

### El error

```
Error: jwt.verify is not a function
    at AuthService.verifyToken (src/auth/service.ts:67)
    at Middleware.authenticate (src/middleware/auth.ts:23)
```

### Con VS Code (antes)

```
1. Abrir src/auth/service.ts:67
2. Buscar jwt.verify
3. Ver que jwt viene de 'jsonwebtoken'
4. Abrir package.json
5. Ver versión: "jsonwebtoken": "^8.5.0"
6. Googlear "jwt.verify is not a function jsonwebtoken 8.5.0"
7. Leer que la API cambió en v9
8. Cambiar import
9. Probar
10. Otro error en otro archivo
11. Repetir en 5+ archivos
```

**Tiempo:** 45 minutos

### Con Pi (ahora)

```bash
pi

# Tú: [Pegas el error]

Pi: Analizando...
    → Root cause: el objeto `jwt` llegó con un import incorrecto y no exponía `verify` como se esperaba
    → Afectados: 12 archivos
    → Patch: Actualizar imports en todos los archivos afectados

# Tú: "Aplica el fix y añade tests"

Pi: [Aplica patch en 12 archivos]
    [Añade test para verifyToken()]
    [Corre tests]
    → 24/24 tests pasan ✓
```

**Tiempo:** 3 minutos

---

## Patrones de errores comunes y cómo Pi los resuelve

### Error #1: "undefined is not a function"

**Causa típica:** Llamas a algo que no existe

**Con Pi:**
```python
# Pi busca dónde se define la función
get_definition(
    name_path="AuthService.verifyToken",
    file_path="src/auth/service.ts"
)

# → Si no existe: "verifyToken no está definido en AuthService"
# → Si existe pero tiene otro nombre: "¿Quisiste decir verifyTokenAsync?"
```

### Error #2: "Cannot read properties of undefined (reading X)"

**Causa típica:** Algo que esperabas que existiera es undefined

**Con Pi:**
```python
# Pi rastrea el valor hacia atrás
get_call_hierarchy(
    name_path="AuthService.login",
    direction="incoming"
)

# → Ve quién llama a login()
# → Ve qué parámetros pasa
# → Identifica dónde se rompe la cadena
```

### Error #3: "Module not found"

**Causa típica:** Import incorrecto o paquete no instalado

**Con Pi:**
```python
# Pi verifica:
search_code(
    pattern="from '@company/package-name'",
    glob="**/*.ts"
)

# → Si existe en otro archivo: "El path es '@company/package-name/index'"
# → Si no existe: "Instala el paquete: npm install @company/package-name"
```

### Error #4: "Type 'X' is not assignable to type 'Y'"

**Causa típica:** Error de tipos (TypeScript)

**Con Pi:**
```python
# Pi usa type hierarchy
get_type_hierarchy(
    name_path="UserDTO",
    file_path="src/types/users.ts"
)

# → Ve qué interfaces implementa UserDTO
# → Ve qué espera la función
# → Propone el tipo correcto o un type assertion seguro
```

---

## Debugging avanzado con múltiples archivos

### Escenario: Bug que cruza 5 archivos

```python
# Pi rastrea el bug a través del call stack completo

# 1. Punto de entrada (error)
src/controllers/user.ts:12
    ↓ llama a
# 2. Servicio
src/auth/service.ts:45
    ↓ llama a
# 3. Validador
src/utils/validator.ts:89
    ↓ llama a
# 4. Schema
src/schemas/auth.ts:23
    ↓ BUG AQUÍ
# 5. Schema tiene propiedad opcional que debería ser requerida
```

Pi puede:
- Ver todo el flujo de ejecución
- Identificar dónde está el bug (no solo dónde se manifiesta)
- Proponer fix en el lugar correcto
- Añadir tests que cubren el flujo completo

---

## Debugging en producción (logs sin stack traces)

### Escenario: Solo tienes logs de producción

```
[2026-04-04 10:23:45] ERROR: Payment failed for user 12345
[2026-04-04 10:23:46] ERROR: Transaction rollback
[2026-04-04 10:23:47] ERROR: User notified
```

Sin stack trace. ¿Qué haces?

### Con Pi

```bash
pi

# Tú: [Pegas los logs]

Pi: Analizando logs de producción...
    → El error está en el flujo de pagos
    → Buscando código relacionado con "Payment failed"...

# [Pi busca en el código]
search_code(
    pattern="Payment failed",
    context_lines=5
)

# [Encuentra el lugar]
# → src/payments/service.ts:156

Pi: Viendo el código del error...
    → El error ocurre cuando payment_gateway retorna null
    → Pero el código asume que siempre retorna un objeto

# Tú: "Propón fix"

Pi: [Genera patch con null check]
    [Añade logs para debugging futuro]
```

**Sin Pi:** 2+ horas de grep + grep + grep
**Con Pi:** 5 minutos

---

## Debugging con Serena vs sin Serena

| Tarea | Sin Serena | Con Serena |
|-------|-----------|------------|
| Encontrar función en stack trace | grep + abrir archivo | `get_definition()` en 1s |
| Ver dónde se usa | grep + abrir 10+ archivos | `get_references()` lista todo |
| Renombrar función con error | Buscar + reemplazar en N archivos | `rename_symbol()` en 1s |
| Ver tipo de variable | Hover en IDE (lento) | `get_type_hierarchy()` instantáneo |
| Navegar call stack | Abrir archivos manualmente | `get_call_hierarchy()` automático |

**La diferencia:** Serena entiende tu código. No es grep. Es LSP.

---

## Mi checklist de debugging

### Antes de empezar

```bash
# 1. Tener el error completo (stack trace, logs, screenshots)
# 2. Tener el estado del repo (git branch, último commit)
# 3. Tener contexto (qué estabas haciendo cuando falló)
```

### Durante debugging

```bash
# 4. Pi: Analizar error
# 5. Pi: Entender root cause
# 6. Revisar el fix propuesto
# 7. Aplicar solo si estás de acuerdo
# 8. Correr tests
# 9. Verificar que el bug se fue
```

### Después del fix

```bash
# 10. Añadir test que cubre el bug (prevenir regresión)
# 11. Verificar que no rompió nada más
# 12. Commit con mensaje claro
# 13. Documentar si es un patrón recurrente
```

---

## Comandos de debugging (cheatsheet)

| Comando | Qué hace | Ejemplo |
|---------|-----------|---------|
| `get_definition()` | Ir a definición | `get_definition(name_path="User.login")` |
| `get_references()` | Ver dónde se usa | `get_references(name_path="User.login")` |
| `get_type_hierarchy()` | Ver tipos | `get_type_hierarchy(name_path="AuthResponse")` |
| `get_call_hierarchy()` | Ver flujo de llamadas | `get_call_hierarchy(direction="incoming")` |
| `rename_symbol()` | Renombrar símbolo | `rename_symbol(name_path="login", new_name="authenticate")` |
| `/skill:debugger` | Analizar archivo/función | `/skill:debugger src/auth/service.ts:45` |
| `search_code()` | Buscar patrón | `search_code(pattern="jwt.verify")` |

---

## En resumen

1. **Pi es mejor que tu IDE para debugging** → stack trace → código → fix en segundos
2. **Serena es clave** → navega código como un IDE, pero en terminal
3. **No necesitas Google** → Pi entiende tu código, no busca en SO
4. **Root cause automático** → no solo te dice QUÉ falló, te dice POR QUÉ
5. **Fix completo** → código + tests + explicación
6. **El ROI:** 45 minutos → 3 minutos = 15x más rápido

---

## 🔗 Recursos

- [Serena vs OneTool: ¿cuándo usar cada uno?](/posts/2026-03-25-serena-vs-onetool-cuando-usar-cada-uno/) - Para navegar y refactorizar con LSP
- [Cómo configurar Pi para proyectos TypeScript](/posts/2026-03-25-como-configurar-pi-para-proyectos-typescript/) - Ajustes útiles cuando el bug está en TS
- [Por qué Pi cambió mi workflow de desarrollo](/posts/2026-03-23-pi-cambio-mi-workflow/) - El flujo de trabajo base

---

## 💭 ¿Qué debugging workflow usas?

¿Prefieres VS Code, Pi, o una mezcla? ¿Algún tip para debugging que quieras compartir? Déjamelo en los comentarios.

---

**Tags:** `pi`, `debugging`, `serena`, `productividad`, `workflow`

---

*Este artículo forma parte de la categoría [Pi](/categories/pi/)*
