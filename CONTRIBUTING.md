# 🤝 Contributing Guide

¡Gracias por tu interés en contribuir a Pablo IB Blog!

## 📋 Tabla de Contenidos

- [Código de Conducta](#código-de-conducta)
- [¿Cómo Contribuir?](#cómo-contribuir)
- [Guía de Estilo](#guía-de-estilo)
- [Proceso de Pull Request](#proceso-de-pull-request)
- [Reportar Bugs](#reportar-bugs)
- [Sugerir Features](#sugerir-features)

---

## Código de Conducta

### Nuestro Compromiso

- Ser respetuoso e inclusivo
- Aceptar críticas constructivas
- Enfocarse en lo mejor para la comunidad
- Mostrar empatía hacia otros

### Comportamiento Inaceptable

- Uso de lenguaje sexualizado
- Trolling o comentarios insultantes
- Acoso público o privado
- Publicar información privada sin permiso

---

## ¿Cómo Contribuir?

### 1. Fork y Clone

```bash
# Fork en GitHub, luego:
git clone https://github.com/TU_USERNAME/pabloib.git
cd pabloib

# Añadir upstream
git remote add upstream https://github.com/pabloalgo/pabloib.git
```

### 2. Crear Rama

```bash
# Crear rama para tu feature
git checkout -b feature/mi-feature

# O para bugfix
git checkout -b fix/mi-fix
```

### 3. Hacer Cambios

```bash
# Realizar tus cambios
# Seguir guía de estilo (ver abajo)

# Probar localmente
hugo server --buildDrafts
```

### 4. Commit y Push

```bash
# Commit con mensaje descriptivo
git add .
git commit -m "feat: añadir buscador con Fuse.js"

# Push a tu fork
git push origin feature/mi-feature
```

### 5. Crear Pull Request

1. Ir a GitHub
2. Click "New Pull Request"
3. Describir cambios detalladamente
4. Esperar review

---

## Guía de Estilo

### Commits

Seguir [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: añadir buscador
fix: corregir error en dark mode
docs: actualizar README
style: formatear código
refactor: reorganizar layouts
test: añadir tests
chore: actualizar dependencias
```

### Markdown

- **Títulos**: Usar `#` para H1, `##` para H2, etc.
- **Énfasis**: `**bold**`, `*italic*`, `` `code` ``
- **Links**: `[texto](url)`
- **Listas**: `- item` o `1. item`
- **Código**: Usar fenced code blocks con lenguaje

```markdown
# Título Principal

Párrafo introductorio.

## Sección

- Item 1
- Item 2

```javascript
const example = "código";
```
```

### Frontmatter de Posts

```yaml
---
title: "Título del Post"
date: 2026-03-25
categories: ["Categoría"]
tags: ["tag1", "tag2", "tag3"]
readingTime: 10
description: "Descripción corta para SEO (150-160 chars)"
draft: false
---
```

### HTML/CSS

- **Indentación**: 2 espacios
- **Clases**: BEM o utility-first (Tailwind)
- **Accesibilidad**: Usar aria-labels, semantic HTML

```html
<!-- Bien -->
<button class="btn btn-primary" aria-label="Buscar">
  Buscar
</button>

<!-- Mal -->
<div onclick="...">Buscar</div>
```

---

## Proceso de Pull Request

### Checklist antes de PR

- [ ] Código sigue la guía de estilo
- [ ] Commits siguen Conventional Commits
- [ ] Hugo build pasa sin errores (`hugo`)
- [ ] Probado localmente (`hugo server`)
- [ ] README/CHANGELOG actualizado si aplica

### Template de PR

```markdown
## Descripción
Breve descripción de cambios.

## Tipo de Cambio
- [ ] Bug fix
- [ ] Nueva feature
- [ ] Breaking change
- [ ] Documentación

## Checklist
- [ ] Hugo build pasa
- [ ] Seguí guía de estilo
- [ ] Actualicé documentación

## Screenshots (si aplica)
...
```

### Review Process

1. Mantenedor revisa PR
2. Feedback y cambios si necesario
3. Aprobación → Merge
4. CI/CD deploy automático

---

## Reportar Bugs

### Antes de Reportar

1. Buscar en [Issues](https://github.com/pabloalgo/pabloib/issues)
2. Verificar que es un bug, no feature
3. Reproducir el bug

### Template de Bug Report

```markdown
## Descripción del Bug
Descripción clara del problema.

## Pasos para Reproducir
1. Ir a '...'
2. Click en '...'
3. Ver error

## Comportamiento Esperado
Lo que debería pasar.

## Screenshots
Si aplica.

## Entorno
- OS: [e.g. Linux, macOS]
- Browser: [e.g. Chrome 120]
- Hugo: [e.g. 0.159.0]

## Contexto Adicional
...
```

---

## Sugerir Features

### Template de Feature Request

```markdown
## ¿Tu suggestion está relacionada con un problema?
Descripción clara del problema.

## Solución Propuesta
Descripción de lo que quieres que pase.

## Alternativas Consideradas
Otras soluciones que consideraste.

## Contexto Adicional
Screenshots, mockups, etc.
```

---

## 🎯 Áreas de Contribución

### Alta Prioridad
- 🐛 Bug fixes
- 📝 Mejoras de contenido
- 🔍 Implementar buscador
- 💬 Sistema de comentarios

### Media Prioridad
- 📊 Analytics
- 🎨 Mejoras de diseño
- 📱 PWA features
- ♿ Accesibilidad

### Baja Prioridad
- 🌍 Traducciones
- 📚 Documentación
- 🧪 Tests automatizados

---

## 🏆 Reconocimientos

Los contribuidores serán mencionados en:

- README.md
- CHANGELOG.md
- Página de About (próximamente)

---

## ❓ Preguntas

¿Dudas? Abre un [Issue](https://github.com/pabloalgo/pabloib/issues) o contacta:

- GitHub: [@pabloalgo](https://github.com/pabloalgo)
- Email: (añadir si quieres)

---

## 📜 Licencia

Al contribuir, aceptas que tus contribuciones estén bajo la Licencia MIT.

---

<div align="center">

**¡Gracias por contribuir! 🎉**

</div>
