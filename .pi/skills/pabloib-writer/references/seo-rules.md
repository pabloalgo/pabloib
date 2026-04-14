# Reglas SEO — Guía completa para Hugo

Optimizaciones específicas para pabloib.com con Hugo v0.159.2. Estas reglas complementan
la infraestructura ya implementada (JSON-LD, OG images dinámicas, canonical URLs, sitemap).

## Front Matter SEO

### description (150-160 caracteres)

Es lo que Google muestra en los resultados. Debe ser:
- Una frase completa, no una lista de keywords
- Contener la keyword principal del post
- Respuesta directa a "¿de qué trata este artículo?"
- Única por post (nunca duplicar descriptions)

**Formula:** `[Beneficio/resultado] + [De qué trata] + [Para quién o cuándo]`

Ejemplos del blog (buenos):
- "La diferencia entre un agente de IA mediocre y uno excepcional no está en el modelo, sino en cuánto contexto puede acceder." (154 chars)
- "Pi está construido en TypeScript. Configurarlo para proyectos TS no es una configuración especial — es su modo nativo." (136 chars)

Ejemplos malos:
- "En este artículo exploramos todo sobre Pi y sus características principales." (79 chars, genérico)
- "Guía completa de Pi para desarrolladores TypeScript con ejemplos prácticos paso a paso y mejores prácticas para configurar tu proyecto." (159 chars, keyword stuffing)

### lastmod

Actualizar cada vez que se edita significativamente un post. Google usa esto como
señal de freshness. Un post actualizado puede rankear mejor que uno nuevo sobre el
mismo tema.

```yaml
lastmod: 2026-04-14  # Actualizar al editar
```

### categories y tags

- **categories**: exactamente 1. Es la navegación principal. Valores actuales: Pi, Hugo, AI
- **tags**: 3-5. Afectan los related posts y la búsqueda interna. Incluir al menos 1 tag
  existente del blog para maximizar la red de related posts.

Tags más usados: pi (14), productividad (6), tutorial (3), extensiones (3), contexto (3),
typescript (2), agentes (2), configuración (2), principiante (2), intermedio (2)

## Estructura del contenido

### H2 como preguntas (featured snippets)

Google da prioridad a párrafos que responden preguntas directamente. Cuando un H2 es
pregunta, el párrafo inmediatamente después debe ser la respuesta en 40-60 palabras.

```markdown
## ¿Cuándo NO usar Ant Colony?

Cuando tienes una tarea puntual y bien definida que un solo agente puede resolver
en menos de 5 minutos. Ant Colony añade overhead de coordinación que no se justifica
para tareas triviales como renombrar variables o arreglar un typo.
```

**No forzar.** Solo 9% de los H2 del blog son preguntas. Úsalo cuando la pregunta sea
lo que la gente realmente busca.

### Internal linking (hub & spoke)

Cada post nuevo debe enlazar a al menos 2 posts existentes. Esto:
- Distribuye page authority entre posts
- Aumenta el tiempo en sitio
- Ayuda a Google a entender la estructura temática
- Mejora los related posts

Patrones de linking:
- "Si no has leído [post], empieza por ahí"
- "Ya cubrimos esto en [post]"
- "Para profundizar en X, mira [post]"
- Links naturales en el texto, no solo en "Artículos relacionados"

### Keyword density

- Keyword principal en: title, description, primer H2, primer párrafo
- No repetir más de 3-4 veces por 1000 palabras
- Usar variaciones sinónimas (Pi → agente, sistema, herramienta)

## Elementos multimedia

### Code blocks

- Siempre con language tag: ````typescript`, ````bash`, etc.
- El syntax highlighting ya está configurado (Monokai)
- Los code blocks con contenido técnico son contenido original = positivo para SEO

### Tablas de comparación

Google muestra tablas en featured snippets. Úsalas para:
- Comparaciones (herramientas, enfoques, configuraciones)
- Resúmenes de features
- Pros/contras

```markdown
| Enfoque | Ventaja | Desventaja | Cuándo usarlo |
|---------|---------|-----------|--------------|
| X | ... | ... | ... |
```

### Imágenes

- Si el post lleva `image` en front matter, se muestra como featured
- OG images se generan dinámicamente (no necesitan imagen)
- Screenshots reales del terminal/IDE son mejores que stock photos

## Lo que ya está implementado (no tocar)

La infraestructura SEO ya funciona. No necesitas hacer nada extra para:

- ✅ Canonical URLs (head.html)
- ✅ OG tags + Twitter cards (head.html)
- ✅ JSON-LD Article + BreadcrumbList (jsonld.html)
- ✅ OG images dinámicas SVG (og-image.html)
- ✅ Sitemap con prioridades (sitemap.xml)
- ✅ RSS feed
- ✅ robots.txt
- ✅ HSTS, security headers (_headers)
- ✅ Meta description fallback (head.html usa .Description → .Summary → site params)

## Checklist SEO por post

- [ ] description: 150-160 caracteres, keyword principal incluida
- [ ] lastmod: actualizado si es edición
- [ ] Keyword en title, description, primer H2, primer párrafo
- [ ] Keyword density: 3-4x max por 1000 palabras
- [ ] Al menos 2 internal links a posts existentes
- [ ] Al menos 1 H2 pregunta con respuesta directa (si aplica al modo)
- [ ] Respuesta directa ≤60 palabras después de H2 pregunta
- [ ] Tabla de comparación si el post compara cosas
