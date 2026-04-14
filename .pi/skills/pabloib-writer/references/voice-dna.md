# Voice DNA — Métricas y Referentes

Datos reales del blog pabloib.com + patrones extraídos de los mejores escritores de
tecnología en castellano. Úsalos como referencia, no como camisa de fuerza.

Para los referentes en español con análisis completo, lee `fuentes-con-alma.md`.

## Estadísticas globales

| Métrica | Valor | Nota |
|---------|-------|------|
| Total posts analizados | 15 | Todos los publicados |
| Total palabras | 19,566 | Solo body, sin front matter |
| Palabras únicas | 2,880 | TTR: 14.7% |
| Total frases | 810 | |
| Total párrafos | ~1,246 | |

## Longitud de frases

| Métrica | Valor | Interpretación |
|---------|-------|----------------|
| Promedio | 25.9 palabras | |
| Mediana | 11.0 palabras | La mayoría son cortas |
| Desviación estándar | 39.7 | Mucha variación |
| Burstiness (CV) | 153.1% | **Muy alta** — patrón humano |
| Frases <10 palabras | 41.4% | Más de 1 de cada 3 |
| Frases >30 palabras | 22.1% | ~1 de cada 5 |

**Patrón:** Alternancia entre frases muy cortas (5-8 palabras) y más largas (20-35).
Esto es lo que da la sensación de "conversación" vs "artículo".

## Longitud de párrafos

| Métrica | Valor |
|---------|-------|
| Promedio | 15.7 palabras |
| Mediana | 10.0 palabras |

**Regla:** Un punto o dos por párrafo. Si un párrafo supera 30 palabras, probablemente
debería dividirse.

## Elementos estructurales por post (promedio)

| Elemento | Promedio/post |
|----------|---------------|
| Code blocks | 17 |
| Frases en negrita | 33 |
| Headings (H2) | 15 |
| Referencias "yo/me/mi/mis" | 5.3 |

## H2: Preguntas vs Statements

| Tipo | Cantidad | Porcentaje |
|------|----------|------------|
| Statements | 204 | 91% |
| Preguntas | 19 | 9% |

**Nota SEO:** Solo 9% de los H2 son preguntas. La recomendación SEO de "H2 como preguntas"
debe aplicarse solo cuando la pregunta es lo que la gente busca, no forzarlo.

### Ejemplos de H2 que funcionan (del blog)

**Statements:**
- "Lo que hace diferente a Pi"
- "Mi workflow actual"
- "El costo real"
- "Lo que aprendí"
- "El momento ajá"
- "El problema que no sabía que tenía"

**Preguntas (justificadas):**
- "¿Cuándo NO uso Pi?"
- "¿Cuándo NO usar Ant Colony?"

## Vocabulario técnico (top 30, sin stop words)

| Palabra | Frecuencia | Palabra | Frecuencia |
|---------|-----------|---------|-----------|
| bash | 119 | json | 54 |
| typescript | 98 | auth | 51 |
| contexto | 90 | error | 51 |
| código | 85 | onetool | 50 |
| skill | 85 | usar | 49 |
| archivos | 79 | install | 49 |
| tests | 79 | refactor | 47 |
| proyecto | 71 | cada | 46 |
| serena | 68 | cómo | 45 |
| tools | 68 | python | 45 |
| archivo | 67 | tokens | 45 |
| hugo | 66 | extensiones | 44 |
| skills | 65 | solo | 54 |
| agent | 64 | sesión | 57 |
| agente | 61 | prompt | 57 |

**Nota:** La repetición de jerga técnica es normal y esperada. No intentar "diversificar"
el vocabulario técnico — si el post es sobre Pi, la palabra "Pi" debe aparecer muchas veces.

## Patrones de hook (primeras frases)

Los hooks del blog siguen 4 patrones:

1. **Experiencia personal:** "Después de meses usando agentes de IA para programar..."
2. **Dato sorprendente:** "Lo que nadie te dice: Pi está construido en TypeScript."
3. **Analogía:** "Las sesiones de IA son como una pila de platos..."
4. **Tesis directa:** "Esto cambió todo." / "Necesitas más agentes."

**Lo que nunca se hace:** "En este artículo vamos a explorar...", "Hoy vamos a hablar de..."

## Uso de primera persona

Promedio: 5.3 referencias a "yo/me/mi/mis" por post.

No es excesivo pero da personalidad. Aparece principalmente en:
- Experiencias propias ("me di cuenta de que...")
- Opiniones ("mi workflow actual", "mis extensiones favoritas")
- Errores ("lo que no me funcionó")

## Anti-patrones detectados

| Frase | Apariciones | Veredicto |
|-------|-------------|-----------|
| "En resumen" | 15 | ⚠️ Aceptable como heading, NO como transición |
| "Además" | 2 | ✅ Dentro del rango normal |
| Resto de Tier 1/2 | 0 | ✅ Blog limpio |

## Rasgos cualitativos (extraídos de fuentes con alma)

Estos rasgos no se miden con estadísticas, pero son los que dan "alma" al blog.

### Honestidad autoconsciente
Presente en Lacort, Llaneras y el propio blog. Se manifiesta como:
- Admitir lo que no sabes
- Reconocer cuando algo va en tu contra
- Mostrar errores reales y frustraciones

Ejemplo del blog: "Lo que aún no me queda claro es X."

### Analogías del día a día
No solo analogías técnicas ("es como un REST API"), sino cotidianas:
- "Las sesiones de IA son como una pila de platos"
- "El contexto es el recurso más valioso" → imaginarlo como combustible limitado

### El cierre como imagen
Los mejores cierres no resumen — amplifican. Dejan una imagen en la cabeza del lector.
- Lacort: "Completamente incapaz de procesar una sola idea más."
- Blog: "Si tu workflow todavía tiene copy-paste, empieza por el AGENTS.md."

### Curiosidad genuina
El rasgo más compartido por los 6 referentes en español. Se nota cuando el autor
genuinamente encuentra interesante lo que está contando. No se puede falsificar.
