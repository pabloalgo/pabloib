# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- TODO: Add search functionality with Fuse.js
- TODO: Add newsletter subscription
- TODO: Add reading progress indicator
- TODO: Add table of contents for posts
- TODO: Add related posts section

## [1.1.0] - 2026-03-25

### Added
- Complete SEO optimization
  - Meta tags with title, description, keywords
  - Open Graph tags for social sharing
  - Twitter Cards support
  - JSON-LD structured data (Schema.org)
  - Canonical URLs
  - robots.txt
- Modern UI redesign
  - Hero section with personal branding
  - Stats section (articles, tags, categories)
  - Grid layout for posts with cards
  - Dark mode toggle
  - Sticky navigation with backdrop blur
  - Tech stack section
  - Newsletter/RSS section
- Custom layouts
  - `layouts/index.html` - Homepage with hero
  - `layouts/_default/baseof.html` - Base template
  - `layouts/_default/single.html` - Single post view
  - `layouts/_default/list.html` - Posts list
  - `layouts/partials/head.html` - SEO head partial
- About page with tech stack and philosophy
- Responsive design for mobile and desktop
- RSS feed optimization

### Changed
- Migrated from theme-only to custom layouts
- Improved README with project documentation
- Enhanced hugo.toml configuration

### Fixed
- Dark mode persistence with localStorage

## [1.0.0] - 2026-03-25

### Added
- Initial Hugo setup with Paper theme
- GitHub repository creation
- 7 blog posts migrated from Obsidian docs
  - "Por qué Pi cambió mi workflow de desarrollo"
  - "Ant Colony: cuando un agente no es suficiente"
  - "Serena vs OneTool: ¿cuándo usar cada uno?"
  - "Cómo configurar Pi para proyectos TypeScript"
  - "Mis 10 extensiones favoritas de Pi"
  - "Prompt engineering para agentes de código"
  - "Del caos al orden: gestionando contexto con Pi"
- Basic Hugo configuration
- Git ignore for Hugo projects
- Theme installation as git submodule

### Technical Details
- Hugo version: 0.159.0
- Theme: [hugo-paper](https://github.com/nanxiaobei/hugo-paper) v6.30
- Hosting: GitHub Pages / Cloudflare Pages ready

---

## Version History

| Version | Date | Description |
|---------|------|-------------|
| 1.1.0 | 2026-03-25 | SEO + Modern UI redesign |
| 1.0.0 | 2026-03-25 | Initial release |

---

[Unreleased]: https://github.com/pabloalgo/pabloib/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/pabloalgo/pabloib/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/pabloalgo/pabloib/releases/tag/v1.0.0
