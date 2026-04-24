# Reporte de correcciones — Blog pabloib

> **Fecha:** 2026-04-16
> **Motivo:** Error factual sobre `.pi/AGENTS.md` + placeholders de API keys
> **Commits:** `c8222f5` y `4839735` en master (ya deployed) + correcciones locales adicionales pendientes de commit
> **Prioridad:** Cerrar revisión de copy y dejar todos los artículos consistentes

---

## El error

Los siguientes artículos afirmaban que `.pi/AGENTS.md` era una ubicación válida donde Pi carga contexto automáticamente. **Eso es falso.** Pi solo carga `AGENTS.md` o `CLAUDE.md` directamente en cada directorio (cwd y padres), nunca dentro de `.pi/`.

Fuente verificada: código fuente de Pi (`resource-loader.js` → `loadContextFileFromDir`).

---

## Artículos corregidos (ya en producción)

### 1. Tu AGENTS.md — Contexto que el agente entiende

- **URL:** https://pabloib.com/posts/2026-04-12-tu-agents-md-contexto-que-el-agente-entiende/
- **Archivo:** `2026-04-12-tu-agents-md-contexto-que-el-agente-entiende.md`
- **Commit:** `c8222f5`

**Cambio aplicado:**

| Antes | Después |
|---|---|
| `/projects/web/app/.pi/AGENTS.md  ← También válido` | Eliminada |
| Solo el diagrama | Añadido párrafo: "Pi busca AGENTS.md o CLAUDE.md directamente en cada directorio, caminando desde el cwd hacia arriba. **No busca dentro de subdirectorios** como .pi/" |

**Revisión SEO/copy:**
- [x] El párrafo nuevo tiene tono consistente con el resto del artículo
- [x] El diagrama de jerarquía se lee bien (3 niveles, sin `.pi/`)
- [x] La sección "SYSTEM.md — Controlando el system prompt" menciona `.pi/SYSTEM.md` correctamente como feature distinta
- [x] Corregido hallazgo adicional: front matter mal cerrado (`---` pegado al primer párrafo) y `lastmod` actualizado a `2026-04-16`

---

### 2. Pi desde cero — Instalación y primera sesión

- **URL:** https://pabloib.com/posts/2026-04-12-pi-desde-cero-instalacion-y-primera-sesion/
- **Archivo:** `2026-04-12-pi-desde-cero-instalacion-y-primera-sesion.md`
- **Commit:** `4839735`

**Cambios aplicados:**

| Antes | Después |
|---|---|
| `./AGENTS.md` **o `./.pi/AGENTS.md`** — instrucciones del proyecto actual | `./AGENTS.md` — instrucciones del proyecto actual (o `./CLAUDE.md` como alias) |
| "Todos se concatenan automáticamente." | "Pi busca estos archivos directamente en cada directorio (no dentro de subdirectorios como .pi/). Todos se concatenan automáticamente." |
| `ANTHROPIC_API_KEY` con placeholder tipo `sk-ant-tu-clave-aqui` | `ANTHROPIC_API_KEY` con placeholder `<tu-api-key>` |
| `OPENAI_API_KEY` con placeholder tipo `sk-tu-clave-aqui` | `OPENAI_API_KEY` con placeholder `<tu-api-key>` |
| `.bashrc` con placeholder tipo `sk-ant-...` | `.bashrc` con placeholder `<tu-api-key>` |
| Sección troubleshooting con placeholder tipo `sk-ant-...` | Sección troubleshooting con placeholder `<tu-api-key>` |

**Revisión SEO/copy:**
- [x] El párrafo de AGENTS.md fluye bien con el texto anterior
- [x] `<tu-api-key>` es claro para el lector y evita falsos positivos de secret guard
- [x] La sección troubleshooting ("No API key found") sigue teniendo sentido con el nuevo placeholder
- [x] Corregido hallazgo adicional: front matter mal cerrado (`---` pegado al primer párrafo)
- [x] Corregido hallazgo adicional: link interno roto al artículo de AGENTS.md
- [x] Corregido hallazgo adicional: `prerequisites` → `prerrequisitos`
- [x] Corregido hallazgo adicional: resumen final alineado con el placeholder `<tu-api-key>`
- [x] `lastmod` actualizado a `2026-04-16`

---

## Artículo corregido tras la revisión

### 3. Cómo configurar Pi para proyectos TypeScript

- **URL:** https://pabloib.com/posts/2026-03-25-como-configurar-pi-para-proyectos-typescript/
- **Archivo:** `2026-03-25-como-configurar-pi-para-proyectos-typescript.md`
- **Línea:** 50

**Problema detectado:** Placeholder que imitaba una API key real en ejemplo de `settings.json` (línea 50).

**Corrección aplicada:** `"apiKey": "<tu-api-key>"`

**Revisión SEO/copy:**
- [x] Placeholder corregido para mantener consistencia con el resto de artículos
- [x] Revisión manual completada: no hay menciones a `.pi/AGENTS.md` en el artículo
- [x] `lastmod` actualizado a `2026-04-16`

---

## Artículos sin cambios pero que mencionan AGENTS.md

Estos artículos mencionan `AGENTS.md` de forma genérica (sin `.pi/`) y no requieren corrección factual, pero conviene revisar por coherencia:

| Artículo | URL | Menciones | Estado |
|---|---|---|---|
| Por qué Pi cambió mi workflow | [link](https://pabloib.com/posts/2026-03-23-pi-cambio-mi-workflow/) | 1 (link al artículo de AGENTS.md) | ✅ OK |
| Gestión de contexto y sesiones | [link](https://pabloib.com/posts/2026-04-12-gestion-de-contexto-y-sesiones/) | 1 (en diagrama) | ✅ OK |
| Skills — Superpoderes bajo demanda | [link](https://pabloib.com/posts/2026-04-12-skills-superpoderes-bajo-demanda/) | 1 (link al artículo de AGENTS.md) | ✅ OK |
| Cómo monté un LLM Wiki con Hugo y Pi | [link](https://pabloib.com/posts/2026-04-16-como-monte-un-llm-wiki-con-hugo-y-pi/) | 6 (uso correcto de AGENTS.md en raíz) | ✅ OK |
| El patrón LLM Wiki de Karpathy | [link](https://pabloib.com/posts/2026-04-16-el-patron-llm-wiki-de-karpathy/) | 2 (referencia metafórica) | ✅ OK |

---

## Artículos sin mención de AGENTS.md (sin impacto)

- Ant Colony: cuando un agente no es suficiente
- Del caos al orden: gestionando contexto con Pi
- Mis 10 extensiones favoritas de Pi
- Prompt engineering para agentes de código
- Serena vs OneTool: ¿cuándo usar cada uno?
- Extensiones — Pi que se programa a sí mismo
- Patrones avanzados — Multi-agente y automatización
- Builds reproducibles en Hugo con npx
- Debugging con Pi: del stack trace al fix

---

## Hallazgos adicionales de la revisión manual

| Hallazgo | Archivo | Estado |
|---|---|---|
| Front matter mal cerrado (`---` pegado al primer párrafo) | `2026-04-12-tu-agents-md-contexto-que-el-agente-entiende.md` | ✅ Corregido |
| Front matter mal cerrado (`---` pegado al primer párrafo) | `2026-04-12-pi-desde-cero-instalacion-y-primera-sesion.md` | ✅ Corregido |
| Link interno roto hacia el artículo de AGENTS.md (`/posts/`) | `2026-04-12-pi-desde-cero-instalacion-y-primera-sesion.md` | ✅ Corregido |
| Inconsistencia de copy: `prerequisites` en inglés | `2026-04-12-pi-desde-cero-instalacion-y-primera-sesion.md` | ✅ Corregido |
| Resumen final con placeholder residual `...` | `2026-04-12-pi-desde-cero-instalacion-y-primera-sesion.md` | ✅ Corregido |

---

## Acciones pendientes

| # | Acción | Responsable | Prioridad |
|---|---|---|---|
| 1 | Revisar manualmente "Del caos al orden" y "Gestión de contexto" por si tienen diagramas con `.pi/AGENTS.md` que el scanner de texto no detectó en bloques de código con formato especial | SEO/copy | Media |
| 2 | Confirmar que `~/.pi/agent/AGENTS.md` (config global) está bien diferenciado de `.pi/AGENTS.md` (subdirectorio de proyecto) en todos los artículos | SEO/copy | Media |
| 3 | Decidir si el postmortem técnico (`docs/postmortems/2026-04-16-agents-md-location-error.md`) debe publicarse como artículo o queda como doc interno | Editor | Baja |

---

## Referencia rápida: qué es correcto y qué no

| Patrón | ¿Correcto? | Nota |
|---|---|---|
| `~/.pi/agent/AGENTS.md` | ✅ Sí | Config global de Pi (funciona) |
| `<proyecto>/AGENTS.md` | ✅ Sí | Contexto de proyecto (pi lo carga) |
| `<proyecto>/CLAUDE.md` | ✅ Sí | Alias de AGENTS.md |
| `<proyecto>/.pi/AGENTS.md` | ❌ No | Pi NO lo carga automáticamente |
| `<proyecto>/.pi/SYSTEM.md` | ✅ Sí | System prompt override (feature distinta) |
| `<proyecto>/.pi/settings.json` | ✅ Sí | Config de proyecto (feature distinta) |
