---
title: "Hermes vs Agent Zero: no son rivales, son complementarios"
description: "Hermes Agent y Agent Zero son frameworks de agentes de IA con filosofías opuestas. Uno domina el messaging, el otro los proyectos. Veredicto: úsalos juntos."
date: 2026-04-21
lastmod: 2026-04-21
categories: ["AI"]
tags: ["agentes", "ia", "hermes", "agent-zero", "review"]
mode: review
draft: false
isCJKLanguage: false
---

Llevo semanas leyendo documentación de dos agentes de IA que prometen lo mismo — ser tu copiloto inteligente — pero que en la práctica son tan distintos como un bisturí y un martillo. Ambos cortan. No querrás usar el mismo para todo.

[Hermes Agent](https://github.com/nous-research/hermes) viene de Nous Research, un lab con modelos propios. [Agent Zero](https://github.com/agent0ai/agent-zero) es proyecto comunitario open-source. Ambos en Python, ambos extensibles, ambos con memoria persistente. Y ahí terminan las similitudes.

Mi conclusión antes de entrar en detalle: **no compiten. Son complementarios.** Si solo puedes instalar uno, el artículo te ayuda a elegir. Si puedes instalar dos, te explico cómo combinarlos.

## Los contendientes en 60 segundos

**Hermes Agent** es un agente personal multi-plataforma. Le hablas por Telegram, Discord, Slack, WhatsApp, Signal — hasta por WeChat si vives en China. Piensa en él como un asistente que vive en tu bolsillo y tiene 53 herramientas nativas pulidas. Su lema: *"the agent that grows with you"*.

**Agent Zero** es un framework agéntico general-purpose. No vive en tu teléfono — vive en Docker y te da una Web UI completa con gestión de proyectos, memory dashboard, y REST API. Su lema: *"dynamic, organic, growing"*. Todo es transparente: cada prompt que el agente ve está en una carpeta, editable, sin nada oculto.

## Dónde gana cada uno

No voy a hacer un desglose de 19 categorías — para eso está [la documentación original](https://github.com/nous-research/hermes). Aquí van las diferencias que realmente importan cuando eliges uno.

### Hermes: el rey del messaging

Hermes soporta **14 plataformas de mensajería**. Catorce. Telegram, Discord, Slack, WhatsApp, Signal, Email, DingTalk, Feishu... y sigue la lista. Puedes empezar una conversación por Telegram y continuarla por Slack sin perder contexto. Tiene voice memos, transcripción con Whisper, TTS, y hasta PII redaction automático (hashea números de teléfono y user IDs).

Si tu caso de uso es "quiero hablar con mi agente desde el móvil mientras voy en el metro", Hermes es la única opción real. Agent Zero solo tiene Web UI y terminal.

### Agent Zero: el rey de los proyectos

Agent Zero tiene un sistema de **Projects** que no tiene Hermes. Cada proyecto tiene: Git clone con auth, memoria aislada, secrets propios, file tree injection configurable, knowledge base, y configuración de subagentes por proyecto. Está diseñado para agencias multi-cliente — puedes tener 5 proyectos con 5 configuraciones distintas sin que se pisen.

[Hermes usa context files](/posts/tu-agents-md-contexto-que-el-agente-entiende/) (SOUL.md, AGENTS.md) que es más minimalista pero no llega a este nivel de aislamiento.

### Las tablas rápidas

Lo que Hermes hace mejor:

| Categoría | Por qué gana |
|-----------|-------------|
| Messaging | 14 plataformas, cross-platform continuity, voice, PII redaction |
| Skills | Hub con 7 fuentes, security scanner con trust levels, progressive disclosure |
| Despliegue | 6 backends (local, Docker, SSH, Daytona, Singularity, Modal) + Android/Termux |
| Modelos | 8+ auxiliary slots configurables individualmente, reasoning control, credential pools |
| Serverless | Modal (hibernate on idle) + Daytona — casi gratis cuando no lo usas |
| Memoria | 8 external providers (Honcho, Mem0, Hindsight...), user modeling, FTS5 session search |

Lo que Agent Zero hace mejor:

| Categoría | Por qué gima |
|-----------|-------------|
| Proyectos | Git clone, memory isolation, scoped secrets, file tree, knowledge base |
| UI/UX | Web UI completa: file browser, memory dashboard, context viewer, plugin hub |
| API | REST API completa, MCP server + client, A2A nativo, WebSocket |
| Transparencia | 100% editable — cada prompt en `prompts/`, nada hard-coded |
| Multi-agente | A2A protocol (FastA2A), jerarquía superior-subordinado madura |
| Plugins | 12+ extension points, frontend contributions, per-project/per-agent config |

## La diferencia filosófica (que lo explica todo)

Hermes construye abstracciones modulares. Tienes toolsets, plugins con hooks lifecycle, skills con progressive disclosure, compression automática con modelo separado. Todo está pulido y funciona. Pero hay cierta "magia interna" — no ves todo lo que pasa.

Agent Zero pone todo sobre la mesa. Los prompts son archivos `.md` en una carpeta. Las extensiones son archivos `.py` con un decorador `@extensible`. El system prompt se construye concatenando múltiples archivos numerados (`_10_main_prompt.py` → `_14_project_prompt.py`). Puedes leer exactamente lo que el agente va a ver antes de que lo vea.

Esto no es un defecto de Hermes — es un trade-off. [Igual que con Serena vs OneTool](/posts/serena-vs-onetool-cuando-usar-cada-uno/)), la elección depende de qué priorizas: abstracción pulida o control total.

## ¿Qué pasa con la memoria?

Ambos tienen memoria persistente y auto-aprendizaje. Pero funcionan distinto.

Hermes usa MEMORY.md y USER.md — bounded, curated, ~1.3k tokens. Es deliberadamente limitado: el agente mantiene solo lo importante. Tiene 8 plugins de memoria externa (Honcho para user modeling dialectic, Mem0 para server-side, Hindsight que auto-extrae en 6 categorías). Y un comando `hermes doctor` que diagnostica problemas. Curado, como una nevera donde solo guardas lo que vas a cocinar esta semana.

Agent Zero usa vector DB con embeddings locales — ilimitada. No hay capping. Y tiene un **memory dashboard visual** donde puedes buscar, filtrar, editar y eliminar memorias. Ajustar el threshold de relevancia con un slider. Ver exactamente qué recuerda el agente y por qué. Es como tener una biblioteca entera en vez de una nevera: más capacidad, más gestión.

## Multi-agente: el punto donde se separan

Hermes puede delegar tareas a subagentes aislados con RPC de costo-cero en contexto. Es eficiente. Pero no tiene A2A protocol — los agentes no se hablan entre instancias.

Agent Zero tiene **FastA2A nativo**. Las instancias de Agent Zero se comunican entre ellas. Puedes tener un agente que delegue a otro que delegue a otro, cada uno con sus tools, prompts y configuración. Es el patrón que describí en [Ant Colony: cuando un agente no es suficiente](/posts/ant-colony-cuando-un-agente-no-es-suficiente/) pero implementado como protocolo nativo, no como feature de un framework externo.

Si necesitas orquestación multi-agente real — múltiples instancias comunicándose — Agent Zero gana por goleada.

## ¿Y Pi? ¿Cómo encaja?

Sé que lo estabas pensando. Pi es el agente que uso para programar, el que tiene [skills que se cargan bajo demanda](/posts/skills-superpoderes-bajo-demanda/) y [extensiones que le dan código ejecutable](/posts/extensiones-pi-que-se-programa-a-si-mismo/). ¿Dónde queda frente a estos dos?

Pi es más específico — está optimizado para desarrollo de software. Hermes y Agent Zero son general-purpose: manejan archivos, navegan web, ejecutan código, automatizan tareas, pero no están tan enfocados en el ciclo edit→debug→commit como Pi. Son capas distintas de tu stack de agentes.

## Cuándo usar cada uno

**Usa Hermes si:**

- Quieres hablar con tu agente desde el móvil (Telegram, Discord, WhatsApp)
- Necesitas serverless (Modal, Daytona) para no pagar cuando está idle
- Te importa el skills hub con scanning de seguridad
- Tu agente va a vivir en un server sin GUI
- Quieres voice memos y TTS/STT

**Usa Agent Zero si:**

- Gestionas múltiples proyectos o clientes simultáneamente
- Necesitas REST API para integrar con CI/CD u otros sistemas
- Quieres ver y modificar cada prompt que el agente recibe
- Tu equipo necesita A2A (comunicación entre agentes)
- Prefieres GUI sobre CLI

**Usa ambos si puedes:**

Agent Zero como agente de proyecto — projects con Git, memory isolation, API para integraciones. Hermes como agente de sistema — alertas por Telegram, serverless para tareas de fondo, messaging cross-platform. Y Pi para lo que mejor hace: programar.

## Veredicto

Después de leer toda la documentación de ambos — y confieso que me faltan las cicatrices de usarlos en producción — mi recomendación es directa.

Si solo puedes elegir uno: **Agent Zero**. La Web UI, el sistema de proyectos, la REST API, el A2A — es más completo como framework general. Aprende más rápido porque todo es visible.

Si puedes instalar dos: **Hermes como sistema + Agent Zero como proyecto**. Hermes manda alertas a Telegram, corre barato en Modal, tiene el skills hub más maduro. Agent Zero maneja tus proyectos con aislamiento real, API para automatización, y transparencia total.

Y si ya tienes Pi para programar — que es mi caso — los tres cubren capas distintas. Como tener un cuchillo de chef, un serrucho y un martillo. Nadie pregunta cuál es mejor. Preguntas para qué vas a usarlo.
