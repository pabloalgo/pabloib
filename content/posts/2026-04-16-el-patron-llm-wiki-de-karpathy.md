---
title: "El patrón LLM Wiki de Karpathy — conocimiento que se acumula"
description: "Karpathy propone reemplazar RAG con una wiki persistente mantenida por LLMs. El conocimiento se compila una vez y crece con cada fuente."
date: 2026-04-16
lastmod: 2026-04-16
categories: ["AI"]
tags: ["llm-wiki", "karpathy", "knowledge-management", "rag", "productividad"]
mode: guide
draft: true
isCJKLanguage: false
---

Hace poco Andrej Karpathy publicó un gist. Lo llamó "LLM Wiki". La idea es simple: en lugar de subir documentos a un chatbot y preguntar, deja que el LLM construya y mantenga una wiki por ti. Cada fuente que añades no se indexa para búsqueda — se integra, se sintetiza, se conecta con lo que ya sabes.

Karpathy lo resume así: el LLM no indexa para búsqueda, integra. No recupera, compila. Y lo compilado se acumula. Es un cambio pequeño de perspectiva con consecuencias grandes.

## El problema con RAG

La mayoría usamos LLMs con documentos así: subes archivos, el modelo recupera chunks relevantes, genera una respuesta. Funciona. Pero hay un problema que no se ve hasta que llevas un tiempo usándolo.

Nada se acumula.

Preguntas algo sutil que requiere sintetizar cinco documentos y el LLM tiene que encontrar y reconectar los fragmentos cada vez. No hay memoria entre preguntas. No hay cross-references. No hay detección de contradicciones. Cada conversación empieza de cero.

NotebookLM, ChatGPT con archivos, la mayoría de sistemas RAG — todos funcionan igual. Recuperación instantánea, acumulación cero.

## La propuesta: una wiki que crece sola

Karpathy plantea algo distinto. En lugar de recuperar desde documentos crudos en cada query, el LLM construye y mantiene una **wiki persistente** — una colección de archivos markdown interconectados que se sienta entre tú y las fuentes originales.

Cuando añades una fuente nueva, el LLM no la indexa. La lee, extrae lo importante, y lo integra en la wiki existente. Actualiza páginas de temas, revisa resúmenes, marca donde la información nueva contradice lo que ya estaba. El conocimiento se compila una vez y se mantiene actualizado. Nunca se redescubre desde cero.

La diferencia clave: **la wiki es un artefacto que crece con cada interacción** (lo que Karpathy llama *compounding*). Las cross-references ya están. Las contradicciones ya están marcadas. La síntesis ya refleja todo lo que has leído.

Tú no escribes la wiki. El LLM la escribe y la mantiene. Pero no es un proceso ciego — Karpathy lo describe como dos ventanas abiertas lado a lado: el agente LLM en una, Obsidian en la otra. El LLM escribe, tú revisas en tiempo real. Sigues links, lees las páginas actualizadas, ves el graph view. Si algo no cuadra, lo corriges o dejas una nota. El LLM lee esas notas en la siguiente iteración y las integra.

La metáfora es buena: Obsidian es el IDE, el LLM es el programador, la wiki es el código. Como en código, lo que importa es el review — el humano lee lo que el LLM escribió y decide qué se queda, qué se cambia, y qué necesita más fuentes. Sin ese review, la wiki degrada.

## Las tres capas

El sistema tiene tres capas, cada una con un rol claro.

**Raw sources** — Tu colección de documentos fuente. Artículos, papers, videos. Son inmutables. El LLM lee de ellos pero nunca los modifica. Es tu fuente de verdad.

**La wiki** — Un directorio de archivos markdown generados por el LLM. Resúmenes, páginas de entidades, páginas de conceptos, comparaciones, una visión general. El LLM escribe, tú lees.

**El schema** — Un documento de configuración (tipo AGENTS.md) que le dice al LLM cómo está estructurada la wiki, qué convenciones seguir, qué workflows ejecutar. Tú y el LLM lo co-evolucionan con el tiempo.

## Los tres workflows

Hay tres flujos de trabajo que definen cómo operar la wiki.

### Ingest — procesar fuentes

Sueltas una fuente nueva y el LLM la procesa. Lee, resumen, identifica temas relevantes, actualiza páginas existentes, crea páginas nuevas si hace falta, actualiza el índice, y registra la actividad en un log. Una sola fuente puede tocar 10-15 páginas de la wiki. Eso no es un bug — es la wiki acumulando conocimiento.

Karpathy prefiere ingerir fuentes de una en una y mantenerse involucrado. Leer los resúmenes, verificar las actualizaciones, guiar al LLM. Pero también puedes batch-ingest con menos supervisión.

### Query — preguntar a la wiki

Preguntas algo y el LLM busca en la wiki, lee las páginas relevantes, y sintetiza una respuesta con citas. Pero aquí hay un insight importante: **las buenas respuestas se archivan como páginas nuevas.** Una comparación que pediste, un análisis, una conexión que descubriste — no deberían desaparecer en el historial del chat. Se archivan y la wiki crece.

### Lint — health check periódico

Periódicamente le pides al LLM que revise la wiki. Busca contradicciones entre páginas, claims obsoletos, páginas huérfanas sin inbound links, conceptos mencionados pero sin su propia página, cross-references rotas. El LLM es bueno sugiriendo nuevas preguntas y nuevas fuentes para investigar.

## El review humano (y por qué Obsidian importa)

Los tres workflows suenan a que el LLM hace todo. Pero Karpathy insiste en algo: tú revisas en tiempo real. El agente en una ventana, Obsidian en la otra. El LLM escribe, tú lees lo que escribió.

Obsidian no es solo un lector de markdown. En este patrón cumple tres funciones:

- **Graph view** — ves la forma de tu wiki. Qué páginas son hubs, cuáles están huérfanas, dónde faltan conexiones. Es la vista que el LLM no tiene.
- **Web Clipper** — el plugin del navegador convierte artículos en markdown con un click. Así caen directamente a tu colección de raw sources.
- **Anotaciones manuales** — tú puedes añadir notas, corregir, dejar preguntas en cualquier página. El LLM las lee después y las integra.

Sin esa capa de review humano, la wiki escribe pages que nadie verifica. Con ella, el ciclo es: LLM escribe → humano revisa → humano anota → LLM lee notas → LLM mejora. Compounding con supervisión.

El Web Clipper de Obsidian es la pieza que cierra el ciclo de ingest: navegas, lees un artículo, un click, y ya tienes el markdown en tu vault listo para que el LLM lo procese. Sin copy-paste, sin formato roto. Exploraremos esto en un post dedicado.

## Dos archivos que lo sostienen

La wiki usa dos archivos especiales para navegar a medida que crece.

**index.md** es el catálogo. Cada página listada con un link, un resumen de una línea, y metadata. Organizado por categoría. El LLM lo actualiza en cada ingest. Cuando responde una query, primero lee el índice para encontrar páginas relevantes. Funciona sorprendentemente bien a escala moderada — unas 100 fuentes, unos cientos de páginas.

**log.md** es el timeline. Append-only, cronológico. Cada entrada con un prefijo parseable: `## [2026-04-02] ingest | Article Title`. Puedes filtrar con grep. Te dice qué se ha hecho y cuándo.

## Por qué funciona (y por qué las wikis normales mueren)

La parte tediosa de mantener una base de conocimiento no es leer o pensar. Es el bookkeeping. Actualizar cross-references, mantener resúmenes al día, notar contradicciones, mantener consistencia entre docenas de páginas. Los humanos abandonamos wikis porque la carga de mantenimiento crece más rápido que el valor. Los LLMs no se aburren.

> "The tedious part of maintaining a knowledge base is not the reading or the thinking — it's the bookkeeping."

Karpathy lo conecta con el Memex de Vannevar Bush (1945) — un almacén personal de conocimiento con trails asociativas entre documentos. La parte que Bush no pudo resolver era quién hace el mantenimiento. El LLM se encarga de eso.

## Aplicaciones prácticas

El patrón sirve para muchos contextos. Algunos ejemplos:

- **Investigación** — profundizar en un tema durante semanas, ingerir papers y artículos, construir una wiki con una tesis que evoluciona
- **Lectura** — ir capítulo a capítulo, ir creando páginas para personajes, temas, tramas. Al final tienes un companion rico
- **Negocio** — wiki interna alimentada por threads de Slack, transcripciones de reuniones, documentos de proyecto. Se mantiene actualizada porque el LLM hace el trabajo que nadie del equipo quiere hacer
- **Análisis competitivo, due diligence, planning** — cualquier contexto donde acumulas conocimiento y quieres que esté organizado

## Lo que me llamó la atención

Hay un par de cosas que me gustan de esta idea.

Primera: es deliberadamente minimalista. Karpathy dice que el documento es abstracto a propósito. No prescribe una estructura de directorios ni herramientas específicas. Es un patrón, no un framework. Lo que necesitas es markdown, un LLM, y disciplina.

Segunda: la wiki como git repo. Obtienes historial de versiones, branching, y colaboración gratis. Cada cambio es un commit. Puedes ver cómo evolucionó tu entendimiento de un tema.

Tercera: no necesitas infraestructura compleja al inicio. El archivo index.md como motor de búsqueda funciona bien a escala moderada. Si la wiki crece, puedes añadir un motor de búsqueda local después. Pero no necesitas vector databases ni embeddings para empezar.

## Lo que aún no me queda claro

Para qué tamaño de wiki el archivo índice deja de ser suficiente. Karpathy menciona ~100 fuentes como punto donde funciona bien, pero no dice explícitamente dónde se rompe. Supongo que con cientos de páginas necesitas algo como qmd — su motor de búsqueda local con BM25 + vector search. Pero es una incógnita real.

También me pregunto por la calidad de la síntesis a largo plazo. El LLM está reescribiendo páginas constantemente. ¿Se degrada la calidad con múltiples reescrituras? ¿O es más bien como un refinamiento iterativo que mejora? Sospecho que depende del dominio y del modelo, pero es algo que solo se sabe usándolo.

## Si quieres explorar

El gist original de Karpathy está en [GitHub](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f). Es corto y merece la pena leerlo completo. Es un idea file — diseñado para copiar y pegar en tu agente y que lo adapte a tu caso.

Si te interesa la gestión de contexto en agentes, mi post sobre [tu AGENTS.md](/posts/tu-agents-md-contexto-que-el-agente-entiende/) cubre la capa de schema desde otro ángulo. Y si quieres ver cómo Pi maneja contexto en sesiones largas, [del caos al orden](/posts/del-caos-al-orden-gestionando-contexto-con-pi/) explica el problema que el LLM Wiki viene a resolver.
