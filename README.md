<div align="center">

# 🚀 Pablo IB - Tech Blog

### *Mi segunda memoria refinada*

Blog personal sobre **tecnología**, **IA**, **desarrollo** y **productividad**.

[![Hugo](https://img.shields.io/badge/Hugo-0.159.0-ff4088?logo=hugo&logoColor=white)](https://gohugo.io)
[![Theme](https://img.shields.io/badge/Theme-Paper-00d4aa?logo=hugo&logoColor=white)](https://github.com/nanxiaobei/hugo-paper)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Last Update](https://img.shields.io/badge/Updated-2026--03--25-brightgreen)](CHANGELOG.md)

[Ver Blog](https://pabloalgo.github.io/pabloib/) • [Roadmap](ROADMAP.md) • [Changelog](CHANGELOG.md)

</div>

---

## ✨ Características

### 📊 SEO Optimizado
- ✅ Meta tags completos (title, description, keywords)
- ✅ Open Graph para Facebook/LinkedIn
- ✅ Twitter Cards
- ✅ JSON-LD structured data (Schema.org)
- ✅ Canonical URLs
- ✅ Sitemap XML automático
- ✅ robots.txt
- ✅ RSS Feed

### 🎨 Diseño Moderno
- ✅ Hero section con personal branding
- ✅ Grid de posts con cards interactivas
- ✅ Dark mode con persistencia
- ✅ Navegación sticky con blur
- ✅ Diseño responsive (móvil + desktop)
- ✅ Tipografía optimizada

### 🛠️ Features Técnicas
- ✅ Generación estática con Hugo
- ✅ Build time < 100ms
- ✅ Sin JavaScript innecesario
- ✅ CSS crítico inline
- ✅ Imágenes optimizadas

---

## 📝 Contenido

### Artículos Publicados (7)

| Título | Categoría | Fecha | Lectura |
|--------|-----------|-------|---------|
| [Por qué Pi cambió mi workflow](https://pabloalgo.github.io/pabloib/posts/2026-03-23-pi-cambio-mi-workflow/) | Pi | 2026-03-23 | 8 min |
| [Ant Colony: cuando un agente no es suficiente](https://pabloalgo.github.io/pabloib/posts/2026-03-25-ant-colony-cuando-un-agente-no-es-suficiente/) | Pi | 2026-03-25 | 10 min |
| [Serena vs OneTool](https://pabloalgo.github.io/pabloib/posts/2026-03-25-serena-vs-onetool-cuando-usar-cada-uno/) | Pi | 2026-03-25 | 12 min |
| [Configurar Pi para TypeScript](https://pabloalgo.github.io/pabloib/posts/2026-03-25-como-configurar-pi-para-proyectos-typescript/) | Pi | 2026-03-25 | 8 min |
| [Mis 10 extensiones favoritas](https://pabloalgo.github.io/pabloib/posts/2026-03-25-mis-10-extensiones-favoritas-de-pi/) | Pi | 2026-03-25 | 12 min |
| [Prompt engineering para agentes](https://pabloalgo.github.io/pabloib/posts/2026-03-25-prompt-engineering-para-agentes-de-codigo/) | AI | 2026-03-25 | 11 min |
| [Gestionando contexto con Pi](https://pabloalgo.github.io/pabloib/posts/2026-03-25-del-caos-al-orden-gestionando-contexto-con-pi/) | Pi | 2026-03-25 | 9 min |

### Temas Cubiertos

- 🤖 **Pi Agent** - Coding assistant
- 🧠 **IA** - Inteligencia artificial aplicada
- 💻 **Desarrollo** - TypeScript, Python, herramientas
- ⚡ **Productividad** - Workflows y optimización
- 🔧 **DevTools** - Herramientas para desarrolladores

---

## 🛠️ Tech Stack

| Tecnología | Uso |
|------------|-----|
| [Hugo](https://gohugo.io/) | Generador de sitios estáticos |
| [Paper Theme](https://github.com/nanxiaobei/hugo-paper) | Base del theme (personalizado) |
| [GitHub Pages](https://pages.github.com/) | Hosting planeado |
| [Tailwind CSS](https://tailwindcss.com/) | Estilos (planeado) |

### Herramientas de Desarrollo
- **Editor**: Neovim
- **Agent**: Pi Coding Agent
- **Knowledge**: Obsidian
- **Brainstorming**: Claude

---

## 🚀 Quick Start

### Prerrequisitos

```bash
# Verificar que tienes Hugo instalado
hugo version
# hugo v0.159.0+ o superior

# Verificar que tienes Git instalado
git version
```

### Instalación

```bash
# Clonar el repositorio
git clone https://github.com/pabloalgo/pabloib.git
cd pabloib

# Inicializar submódulos (theme)
git submodule update --init --recursive

# Iniciar servidor de desarrollo
hugo server --buildDrafts

# Abrir en navegador
# http://localhost:1313/pabloib/
```

### Build para Producción

```bash
# Generar sitio estático
hugo --minify

# Los archivos se generan en /public
# Listo para deploy
```

---

## 📁 Estructura del Proyecto

```
.
├── 📂 content/              # Contenido del blog
│   ├── 📂 posts/           # Artículos del blog (7 posts)
│   │   ├── 2026-03-23-pi-cambio-mi-workflow.md
│   │   ├── 2026-03-25-ant-colony-*.md
│   │   └── ...
│   └── 📄 about.md         # Página "Sobre mí"
│
├── 📂 layouts/             # Layouts personalizados
│   ├── 📂 _default/        # Layouts base
│   │   ├── baseof.html     # Template principal
│   │   ├── single.html     # Vista de post individual
│   │   └── list.html       # Lista de posts
│   ├── 📂 partials/        # Componentes reutilizables
│   │   └── head.html       # SEO meta tags
│   └── 📄 index.html       # Homepage con hero
│
├── 📂 static/              # Archivos estáticos
│   ├── 📂 images/          # Imágenes (OG, etc.)
│   └── 📄 robots.txt       # Robots para SEO
│
├── 📂 themes/              # Themes de Hugo
│   └── 📂 paper/           # Paper theme (submodule)
│
├── 📄 hugo.toml            # Configuración de Hugo
├── 📄 README.md            # Este archivo
├── 📄 CHANGELOG.md         # Historial de cambios
├── 📄 ROADMAP.md           # Plan de desarrollo
└── 📄 .gitignore           # Archivos ignorados por Git
```

---

## 🔍 SEO Features Detalladas

### Meta Tags
```html
<title>Pablo IB | Tech Blog & Second Brain</title>
<meta name="description" content="Blog personal...">
<meta name="keywords" content="tecnología, ia, desarrollo">
<meta name="author" content="Pablo IB">
```

### Open Graph
```html
<meta property="og:type" content="website">
<meta property="og:url" content="https://...">
<meta property="og:title" content="...">
<meta property="og:description" content="...">
<meta property="og:image" content="/images/og-image.png">
```

### JSON-LD Structured Data
```json
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "name": "Pablo IB",
  "author": {
    "@type": "Person",
    "name": "Pablo IB"
  }
}
```

---

## 🧪 Testing & Validación

### Validar SEO
```bash
# Validar HTML
html5validator public/

# Validar structured data
# https://search.google.com/test/rich-results

# Validar Open Graph
# https://www.opengraph.xyz/
```

### Validar Performance
```bash
# Lighthouse CLI
lighthouse https://pabloalgo.github.io/pabloib/

# PageSpeed Insights
# https://pagespeed.web.dev/
```

---

## 📊 Analytics (Próximamente)

### Google Analytics 4
```html
<!-- Pendiente de implementar -->
<script async src="https://www.googletagmanager.com/..."></script>
```

### Search Console
- Sitemap: `https://pabloalgo.github.io/pabloib/sitemap.xml`
- robots.txt: `https://pabloalgo.github.io/pabloib/robots.txt`

---

## 🚀 Deploy

### GitHub Pages

```bash
# Build del sitio
hugo --minify

# Push a GitHub
git add .
git commit -m "deploy: new version"
git push origin master

# GitHub Actions se encarga del deploy
# Ver .github/workflows/deploy.yml
```

### Cloudflare Pages (Alternativa)

1. Conectar repositorio en Cloudflare Pages
2. Build command: `hugo --minify`
3. Output directory: `public`
4. Deploy automático en cada push

---

## 🤝 Contribuir

¡Las contribuciones son bienvenidas!

### Tipos de Contribuciones
- 📝 **Contenido**: Correcciones, nuevos artículos
- 🐛 **Bugs**: Reportar problemas
- 💡 **Features**: Sugerir mejoras
- 🎨 **Diseño**: Mejoras visuales
- 🌍 **Traducciones**: Otros idiomas

### Proceso
1. Fork el repositorio
2. Crear rama (`git checkout -b feature/amazing-feature`)
3. Commit cambios (`git commit -m 'Add amazing feature'`)
4. Push a la rama (`git push origin feature/amazing-feature`)
5. Abrir Pull Request

Ver [CONTRIBUTING.md](CONTRIBUTING.md) para más detalles.

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver [LICENSE](LICENSE) para detalles.

```
Copyright (c) 2026 Pablo IB

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software...
```

---

## 📬 Contacto

- **Blog**: [pabloalgo.github.io/pabloib](https://pabloalgo.github.io/pabloib/)
- **GitHub**: [@pabloalgo](https://github.com/pabloalgo)
- **Email**: (Añadir si quieres)

---

## 🙏 Agradecimientos

- [Hugo](https://gohugo.io/) - Por el mejor SSG
- [Paper Theme](https://github.com/nanxiaobei/hugo-paper) - Base del diseño
- [Pi Agent](https://github.com/badlogic/pi-mono) - Por ayudar a construir esto
- [Claude](https://claude.ai/) - Por el brainstorming

---

<div align="center">

**[⬆ Volver arriba](#-pablo-ib---tech-blog)**

*Construido con ❤️ y mucho ☕*

*Última actualización: 2026-03-25*

</div>
