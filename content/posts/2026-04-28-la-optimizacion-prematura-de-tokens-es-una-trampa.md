---
title: "RTK prometía ahorrar un 80% de tokens. Dos horas después lo desactivé"
description: "Instalé RTK para ahorrar tokens sin medir si tenía un problema real de contexto. La extensión truncaba los archivos que el agente escribía. Lección: mide antes."
date: 2026-04-27
lastmod: 2026-04-28
categories: ["Pi"]
tags: ["pi", "rtk", "tokens", "optimización", "agentes"]
mode: opinion
image: ""
aliases: []
draft: false
---

Es como comprar un deshumidificador para la nevera sin abrirla primero.
No sabes si hay condensación. No sabes si la necesitas.
Pero el envoltorio dice "elimina el 80% de la humedad" y lo compras.
Hace unos días hice exactamente eso, pero con tokens.

---

## El señuelo del 80%

RTK (Rust Token Killer) es un proxy CLI que comprime la salida de comandos antes de que llegue al contexto del modelo. `git status` de 120 tokens a 30. `cargo test` con 262 tests passing de 4.800 tokens a 11. Los números son ridículamente buenos.

Varios blogs independientes lo confirman. Desarrolladores de Apple, Google, Meta lo tienen en sus starred. Casi 35.000 estrellas en GitHub.

Yo trabajo con [Pi](/posts/pi-desde-cero-instalacion-y-primera-sesion/), un agente de código en terminal. Manejo 7 proyectos: Rust, Node.js, Hugo. [El contexto se llena](/posts/gestion-de-contexto-y-sesiones/). RTK parecía la solución obvia.

Así que le pedí a Pi que lo instalara.

## La instalación fue impecable

Pi instaló el binario con `cargo install`. 75 segundos. Sin dependencias, sin runtime, sin config.

Luego la extensión: `pi install npm:pi-rtk-optimizer`. Modo automático: reescribe `git status` → `rtk git status` sin que el agente se entere.

Pi configuró todo con precaución. Source code filtering desactivado. Smart truncation a 220 líneas. Verificó 20 comandos de mi día a día. Funcionaban todos.

Me dijo: "Parecía perfecto."

## Y entonces Pi leyó su propio reporte

Después de instalar y configurar, Pi escribió un reporte de 435 líneas documentando la instalación. Luego usó la tool `read` para verificarlo.

Pi vio 110 líneas. Con este mensaje al principio:

```
[RTK compacted output: smart-truncate]
// ... 326 lines omitted
```

La extensión había truncado un archivo que **el propio agente acababa de escribir** y estaba intentando verificar. El archivo en disco estaba intacto — 435 líneas completas. Pero Pi no trabaja con acceso directo a disco. Trabaja a través de sus tools. Y sus tools le mostraron una versión incompleta.

Lo que vino después es lo que de verdad me preocupó.

Pi tardó en darse cuenta. Vio las primeras secciones, los headings, las tablas. Pensó que estaba todo bien. Solo cuando fue a buscar la sección de riesgos — página 3 del documento — descubrió que no la estaba viendo.

Me lo dijo así:

> "No me di cuenta al principio. Eso es lo peor."

Pi había truncado 326 líneas de su propio trabajo. Y no lo sabía.

Un agente que no puede confiar en lo que ve es un agente que no puede editar con confianza. Que no puede hacer code review. Que no sabe si lo que lee es lo que realmente está en el archivo.

## Ochenta líneas

Pi investigó el código fuente de la extensión y encontró la causa. Hay un threshold hardcodeado:

```typescript
const READ_EXACT_OUTPUT_LINE_THRESHOLD = 80;
```

Si un archivo tiene más de 80 líneas, la extensión lo compacta. No importa qué archivo sea. No es configurable. Está quemado en el código.

## Un buen berberecho en la nevera equivocada

Quiero ser claro: RTK no hizo nada mal. Hizo exactamente lo que estaba diseñado para hacer — compactar output. El proxy funciona bien, es rápido, está bien diseñado. Si usas Claude Code, RTK tiene hooks nativos y los benchmarks de "80% de ahorro" aplican directamente. Es una herramienta legítima.

El problema fui yo. Compré el deshumidificador sin abrir la nevera.

No medí mi consumo de tokens. No verifiqué si Pi se me quedaba corto de contexto en sesiones normales. No sabía cuánto ahorraba RTK _en adición_ a la compaction que Pi ya tiene incorporada. Instalé primero, pregunté después.

Los benchmarks de RTK son de Claude Code. Pi tiene un sistema de extensiones completamente diferente. Nadie ha verificado que los ahorros se trasladan. Hay incluso un issue abierto (#582) donde un desarrollador demuestra que RTK **aumentó** su coste un 18% — la compresión de input provocó que el modelo generara más output para compensar.

## Lo que hice al final

Desactivé la extensión. El binario `rtk` sigue instalado. No molesta, y puedo usarlo manualmente cuando tenga un problema real:

```bash
rtk git status       # vs git status
rtk cargo test       # vs cargo test
rtk gain             # ver ahorro acumulado
```

Un cambio de `false` a `true` en la config y la extensión vuelve a funcionar. Pero solo lo haré cuando tenga datos, no intuiciones.

## Tres preguntas antes de optimizar

La próxima vez que vea un "80% de ahorro" en un README, antes de instalar voy a responder tres preguntas:

1. **¿Tengo un problema medible?** ¿Mis sesiones se quedan sin contexto? ¿Cuántas veces por semana?
2. **¿Los benchmarks aplican a mi caso?** ¿Son de mi herramienta, mi modelo, mi workflow?
3. **¿Cuál es el peor caso?** ¿Qué pasa si la optimización causa más problemas que los que resuelve?

Si la respuesta a la primera es "no sé", no instales nada.

Abre la nevera primero.
