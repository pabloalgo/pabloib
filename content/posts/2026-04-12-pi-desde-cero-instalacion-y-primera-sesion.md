---
title: "Pi desde cero — Instalación y primera sesión"
description: "Guía paso a paso para instalar Pi, configurarlo y tener una sesión funcional en menos de 10 minutos. Sin jerga, sin prerrequisitos imposibles."
date: 2026-04-12
categories: ["Pi"]
tags: ["pi", "instalación", "principiante", "guía", "agentes-ia"]
readingTime: 10
draft: false
---


**Publicado:** 2026-04-12 | **Categoría:** Pi | **Lectura:** 10 min

Si nunca usaste un agente de código en la terminal, este artículo es para ti. Vamos a instalar Pi, configurarlo y tener una sesión funcional en menos de 10 minutos. Sin jerga, sin prerequisites imposibles.

---

## 🎯 Lo que aprenderás

- Qué es Pi y por qué su filosofía minimal funciona
- Cómo instalar Pi (npm y Ollama)
- Configurar tu primer provider de LLM
- Ejecutar tu primera sesión interactiva
- Entender los 4 tools básicos en acción

---

## ¿Qué es Pi y por qué debería importarte?

Pi es un agente de código que vive en tu terminal. No es un chatbot. No es un IDE con IA integrada. Es un asistente que **lee, escribe, edita y ejecuta código directamente en tu proyecto**.

Lo creó Mario Zechner (el de libGDX) por frustración con Claude Code:

> *"Una nave espacial con el 80% de funcionalidad que no uso."*

Su tesis: si reduces un agente de código a lo mínimo — un system prompt de ~100 tokens, 4 tools y transparencia total — los modelos frontier rinden **mejor**, no peor.

Los números le dan la razón: Pi con Claude Opus compite con Codex, Cursor y Windsurf en Terminal-Bench 2.0, con una fracción de la complejidad.

### La diferencia clave

| ChatGPT / Claude web | Cursor / Copilot | **Pi** |
|---|---|---|
| Copias y pegas código | IA integrada en el editor | IA en la terminal con acceso directo |
| Sin acceso a archivos | Acceso limitado al proyecto | **Acceso total: lee, escribe, edita, ejecuta** |
| Contexto manual | Contexto parcial | **Contexto completo del proyecto** |

---

## Paso 1: Instalar Pi

Tienes dos opciones. Elige la que prefieras.

### Opción A: npm (recomendada)

```bash
npm install -g @mariozechner/pi-coding-agent
```

Verifica que se instaló:

```bash
pi --version
```

### Opción B: Ollama (modelo local, sin API key)

Si ya tienes [Ollama](https://ollama.ai) instalado:

```bash
ollama launch pi
```

Esto lanza Pi con un modelo local. Ideal para probar sin gastar dinero.

> 💡 **¿Cuál elegir?** npm + Claude/GPT para calidad máxima. Ollama para privacidad o si no tienes API key. Puedes cambiar en cualquier momento.

---

## Paso 2: Configurar el provider

Pi necesita acceso a un modelo de lenguaje. Funciona con 15+ providers: OpenAI, Anthropic, Google, Groq, Ollama, y más.

### Con Anthropic (Claude) — recomendado para empezar

```bash
export ANTHROPIC_API_KEY="sk-ant-tu-clave-aqui"
pi
```

### Con OpenAI (GPT-4o)

```bash
export OPENAI_API_KEY="sk-tu-clave-aqui"
pi --provider openai --model gpt-4o
```

### Con modelo local vía Ollama

```bash
ollama pull devstral
pi --provider ollama --model devstral
```

> 💡 **Tip:** Guarda tu API key en `~/.bashrc` o `~/.zshrc` para no escribirla cada vez:
> ```bash
> echo 'export ANTHROPIC_API_KEY="sk-ant-..."' >> ~/.bashrc
> ```

Para ver todos los models disponibles:

```bash
pi --list-models
```

---

## Paso 3: Tu primera sesión

Entra a un proyecto cualquiera y ejecuta:

```bash
cd mi-proyecto
pi
```

Verás algo como:

```
╭─────────────────────────────────────╮
│  Pi Coding Agent v0.159.x           │
│  Model: claude-sonnet-4-20250514    │
│  Provider: anthropic                │
│  AGENTS.md: loaded (3 files)        │
╰─────────────────────────────────────╯
>
```

Escribe tu primer prompt:

```
> ¿Qué archivos hay en este proyecto?
```

Pi va a usar su tool `bash` para ejecutar `ls` o `find`, leer los archivos, y responderte con contexto real de **tu** proyecto.

### Los 4 tools básicos

Pi tiene exactamente 4 tools. No 40. No 100. **4**:

| Tool | Qué hace | Ejemplo |
|---|---|---|
| `read` | Lee archivos | Lee el código fuente, configuración, logs |
| `write` | Crea archivos nuevos | Genera componentes, tests, documentación |
| `edit` | Edita archivos existentes | Cambia funciones, corrige bugs, refactoriza |
| `bash` | Ejecuta comandos en la terminal | `npm test`, `git status`, `ls`, cualquier cosa |

**¿Por qué solo 4?** Porque los modelos frontier ya saben usar `grep`, `find`, `git log`, etc. vía `bash`. No necesitan tools separados para cada comando. Menos tools = menos tokens gastados en descripciones = más contexto para tu código.

---

## Paso 4: Tres ejercicios prácticos

Probemos los 4 tools en escenarios reales.

### Ejercicio 1: Explorar un proyecto (read + bash)

```
> Analiza la estructura de este proyecto y dime qué hace
```

Pi ejecutará algo como:

```bash
# Pi internamente ejecuta:
ls -la
cat package.json
find src -type f
```

Y te dará un resumen real del proyecto.

### Ejercicio 2: Crear un archivo (write)

```
> Crea un archivo .gitignore para un proyecto Node.js
```

Pi usará `write` para crear el archivo directamente en tu proyecto.

### Ejercicio 3: Corregir un bug (edit + bash)

```
> Los tests están fallando. Revisa qué pasa y arréglalo.
```

Flujo típico:

1. `bash` → ejecuta `npm test`
2. `read` → lee el archivo con el error
3. `edit` → corrige el código
4. `bash` → ejecuta `npm test` otra vez para verificar

**Sin copy-paste. Sin salir de la terminal.**

---

## Modos de uso de Pi

Pi no es solo interactivo. Tiene varios modos:

| Modo | Comando | Cuándo usarlo |
|---|---|---|
| **Interactivo** | `pi` | Desarrollo diario, exploración |
| **Un solo prompt** | `pi -p "tu pregunta"` | Comandos rápidos, scripts |
| **Continuar sesión** | `pi -c` | Retomar donde dejaste |
| **Modelo específico** | `pi --model gpt-4o` | Probar con otro modelo |
| **Solo lectura** | `pi --readonly` | Revisar código sin riesgo de cambios |

### Ejemplo: prompt rápido

```bash
pi -p "Explícame qué hace la función main en src/index.ts"
```

Pi lee el archivo, analiza la función, y te da la explicación. Todo en un solo comando.

---

## ¿Qué es ese AGENTS.md que aparece al iniciar?

Cuando lanzas `pi`, verás algo como `AGENTS.md: loaded (3 files)`. Es el archivo donde le das instrucciones al agente sobre tu proyecto. Pi busca estos archivos en:

1. `~/.pi/agent/AGENTS.md` — instrucciones globales (para todos tus proyectos)
2. Directorios padre — instrucciones compartidas
3. `./AGENTS.md` o `./.pi/AGENTS.md` — instrucciones del proyecto actual

Todos se concatenan automáticamente.

Ejemplo mínimo de `AGENTS.md`:

```markdown
# Mi proyecto

## Stack
- TypeScript + Node.js
- Tests con Vitest
- Base de datos: PostgreSQL

## Convenciones
- Usar camelCase para variables y funciones
- Siempre escribir tests para funciones nuevas
- Commits en español
```

> 📝 **En el próximo artículo** cubriremos AGENTS.md en profundidad: cómo escribir instrucciones efectivas, la jerarquía de archivos, SYSTEM.md, y settings.json.

---

## Atajos esenciales

Dentro de una sesión interactiva:

| Atajo | Qué hace |
|---|---|
| `Enter` | Envía el mensaje |
| `Escape` | Cancela la generación actual |
| `/compact` | Compacta el contexto manualmente |
| `/clear` | Limpia la pantalla |
| `/help` | Muestra todos los comandos |
| `/hotkeys` | Muestra todos los atajos |
| `Ctrl+C` (2x) | Sale de Pi |

---

## Checklist: ¿Ya tienes Pi funcionando?

- [ ] Pi instalado (`pi --version` responde)
- [ ] API key configurada
- [ ] `pi` arranca sin errores
- [ ] Ejecutaste un prompt y recibiste respuesta
- [ ] Pi puede leer archivos de tu proyecto (`pi -p "qué archivos hay aquí"`)
- [ ] Probaste `pi -p` para un comando rápido
- [ ] Probaste `pi -c` para continuar una sesión

Si todo está ✓, estás listo para el siguiente paso.

---

## Errores comunes al empezar

### "No API key found"

```bash
# Verifica que la variable existe
echo $ANTHROPIC_API_KEY
# Si está vacía, expórtala:
export ANTHROPIC_API_KEY="sk-ant-..."
```

### "Model not found"

```bash
# Lista los models disponibles
pi --list-models
# Usa el nombre exacto:
pi --model claude-sonnet-4-20250514
```

### Pi no encuentra mis archivos

Pi trabaja en el directorio donde lo ejecutas. Asegúrate de estar en la raíz de tu proyecto:

```bash
cd /ruta/a/tu/proyecto
pi
```

---

## En resumen

1. **Instala** con `npm install -g @mariozechner/pi-coding-agent`
2. **Configura** tu API key (`export ANTHROPIC_API_KEY=...`)
3. **Ejecuta** `pi` dentro de un proyecto
4. **Escribe** lo que necesitas en lenguaje natural
5. Pi usa **4 tools** (read, write, edit, bash) para resolverlo

La filosofía es simple: menos herramientas, más transparencia, más control para ti.

---

## 🔗 Recursos

- [Pi oficial](https://shittycodingagent.ai/) — Documentación y packages
- [Repositorio GitHub](https://github.com/badlogic/pi-mono) — Código fuente
- [Tu AGENTS.md — Contexto que el agente entiende](/posts/) — Siguiente artículo de esta serie
- [Por qué Pi cambió mi workflow de desarrollo](/posts/2026-03-23-pi-cambio-mi-workflow/) — Mi experiencia personal

---

**Tags:** `pi`, `instalación`, `principiante`, `guía`, `agentes-ia`

---

*Este artículo forma parte de la serie [Pi desde cero hasta intermedio](/categories/pi/) — Artículo 1 de 6*
