---
title: "Builds reproducibles en Hugo con npx"
description: "Fijar la versión de Hugo en package.json con npx elimina dependencias de binarios globales y garantiza builds idénticos en local, CI y cualquier máquina."
date: 2026-04-04
lastmod: 2026-04-04
categories: ["Hugo"]
tags: ["hugo", "build", "devops", "productividad", "ci-cd"]
mode: tutorial
draft: false
---Fijar la versión de Hugo en `package.json` con `npx` elimina dependencias de binarios globales y garantiza builds reproducibles. Tu local, CI y cualquier desarrollador obtienen el mismo resultado.

---

## El problema: binarios globales

Instalación típica de Hugo:

```bash
# Instalación global
brew install hugo

# O descargar binario manual
wget https://github.com/gohugoio/hugo/releases/download/v0.159.2/hugo_extended_0.159.2_linux-amd64.deb
sudo dpkg -i hugo_extended_0.159.2_linux-amd64.deb
```

**El problema:**

```json
// package.json (antes)
{
  "scripts": {
    "dev": "hugo server --buildDrafts",
    "build": "hugo --minify"
  }
}
```

¿Qué versión de Hugo usa `npm run dev`?

- **Tu local:** Hugo 0.159.2 (instalado con brew)
- **CI:** Hugo 0.158.0 (version más reciente en GitHub Actions)
- **Colaborador:** Hugo 0.157.0 (nunca actualizó)

Resultado: builds inconsistentes. Un feature que funciona en local falla en CI porque cambiaron APIs entre versiones.

---

## La solución: npx + hugo-extended

`npx` ejecuta paquetes sin instalarlos globalmente. Combínalo con una versión fija:

```json
// package.json (después)
{
  "scripts": {
    "dev:css": "npx --yes tailwindcss@3.4.0 -i ./assets/css/input.css -o ./assets/css/output.css --watch",
    "build:css": "npx --yes tailwindcss@3.4.0 -i ./assets/css/input.css -o ./assets/css/output.css --minify",
    "dev:hugo": "npx --yes hugo-extended@0.159.2 server --buildDrafts -D --port 1315",
    "build:hugo": "npx --yes hugo-extended@0.159.2 --minify",
    "dev": "npm run dev:css & npm run dev:hugo",
    "build": "npm run build:css && npm run build:hugo"
  }
}
```

**Qué pasa:**

1. `npx --yes` descarga la versión exacta si no está en caché
2. `hugo-extended@0.159.2` usa esa versión, ni más ni menos
3. Sin instalación global, sin dependencias del sistema

---

## Comandos concretos

### Desarrollo

```bash
# Iniciar servidor de desarrollo
npm run dev

# npx:
# 1. Descarga tailwindcss@3.4.0 y hugo-extended@0.159.2 si no están en caché
# 2. Ejecuta ambos comandos en paralelo
# 3. Servidor en http://localhost:1315
```

### Build para producción

```bash
# Build optimizado
npm run build

# npx:
# 1. Compila CSS con tailwindcss@3.4.0 (minificado)
# 2. Ejecuta hugo-extended@0.159.2 (minifica HTML, JS, SVG)
# 3. Output en ./public/
```

### Primera vez (descarga)

```bash
# npx descarga el paquete la primera vez
npm run dev

# Output:
# npx: installed 23 in 2.5s
# npx: installed 1 in 1.8s
# Start building sites …
# Hugo Static Site Generator v0.159.2/extended linux/amd64 BuildDate=unknown
```

Siguientes ejecuciones usan caché, son casi instantáneas.

---

## Por qué fijar la versión

### 1. Evita cambios de comportamiento inesperados

Cada salto de versión puede tocar templates, recursos o minificación. Si usas `npx hugo-extended@latest`, hoy compila y mañana puede romperse sin que hayas cambiado tu código.

Si usas `npx hugo-extended@latest`:

```bash
# Hoy: funciona
npm run build  # Hugo 0.159.2

# Mañana: rompe
npm run build  # Hugo 0.160.0, breaking change → build falla
```

Fijar la versión previene esto.

### 2. CI/CD predecible

GitHub Actions con versión fija:

```yaml
# .github/workflows/deploy.yml
- name: Build Hugo site
  run: npm run build

# Siempre usa Hugo 0.159.2, sin importar la versión del runner
```

Sin `npx`:

```yaml
# .github/workflows/deploy.yml (antes)
- name: Install Hugo
  run: brew install hugo
  # ¿Versión? Depende del runner macOS
  # Hoy: 0.159.2. Mañana: 0.160.0 → build falla
```

### 3. Onboarding simplificado

Nuevo colaborador:

```bash
# Clona repo
git clone https://github.com/tuorg/blog.git

# Sin instalar nada
npm run dev
# Funciona. Hugo, Tailwind, todo ahí.
```

Sin `npx`:

```bash
# Antes: 10+ pasos de instalación
# 1. Instalar Go
# 2. Instalar Hugo desde fuente
# 3. Verificar PATH
# 4. Instalar Node
# 5. Instalar npm packages
# 6. Configurar Tailwind
# ...
```

---

## Impacto en CI/CD

### CI con npx (reproducible)

```yaml
name: Deploy
on: [push]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm install
      - run: npm run build  # Hugo 0.159.2 siempre
      - deploy...
```

**Ventajas:**

- Sin setup de Go
- Sin instalación de Hugo
- Sin dependencias del runner
- Mismo resultado que local

### CI sin npx (frágil)

```yaml
# Antes: dependes del runner
- name: Install Hugo
  run: |
    wget -q https://github.com/gohugoio/hugo/releases/download/v0.159.2/hugo_extended_0.159.2_linux-amd64.deb
    sudo dpkg -i hugo_extended_0.159.2_linux-amd64.deb

# Problemas:
# - Runner actualiza Hugo → build rompe
# - wget falla → CI roto
# - Versión hardcodeada en 2+ lugares (package.json + CI)
```

---

## hugo vs hugo-extended

Usa `hugo-extended`, no `hugo`:

```bash
# Hugo básico (no suficiente)
npx hugo@0.159.2  # Falta Sass/SCSS, PostCSS

# Hugo extendido (completo)
npx hugo-extended@0.159.2  # Incluye Sass/SCSS, PostCSS
```

La mayoría de blogs modernos usan:
- Tailwind CSS → PostCSS
- Custom CSS → Sass
- Image processing → extended features

---

## Actualizar versión de Hugo

Cuando quieras actualizar:

```bash
# 1. Cambiar versión en package.json
"dev:hugo": "npx --yes hugo-extended@0.160.0 server ...",
"build:hugo": "npx --yes hugo-extended@0.160.0 --minify",

# 2. Probar local
npm run dev  # Descarga nueva versión

# 3. Si funciona, commit
git add package.json
git commit -m "chore: bump hugo-extended to 0.160.0"

# 4. CI usa nueva versión automáticamente
```

Un solo lugar para cambiar. CI actualiza sin cambios en YAML.

---

## Costos y trade-offs

### Ventajas

| Aspecto | Sin npx | Con npx |
|---------|----------|----------|
| Consistencia | ❌ Depende de sistema | ✅ Versión fija |
| CI setup | ❌ 10+ líneas YAML | ✅ `npm run build` |
| Onboarding | ❌ Manual, 30+ min | ✅ `npm install && run` |
| Reproducibilidad | ❌ Local ≠ CI | ✅ Idéntico |
| Actualizaciones | ❌ N lugares | ✅ 1 archivo |

### Desventajas (menores)

- **Primer run:** `npx` descarga el binario (2-5s)
- **Offline:** No funciona sin conexión inicial (pero usa caché después)
- **Disk usage:** ~100MB por versión en caché `~/.npm/_npx`

En la práctica, estos trade-offs son triviales comparados con el valor de builds reproducibles.

---

## Ejemplo completo

### package.json

```json
{
  "name": "tu-blog",
  "scripts": {
    "dev:css": "npx --yes tailwindcss@3.4.0 -i ./assets/css/input.css -o ./assets/css/output.css --watch",
    "build:css": "npx --yes tailwindcss@3.4.0 -i ./assets/css/input.css -o ./assets/css/output.css --minify",
    "dev:hugo": "npx --yes hugo-extended@0.159.2 server --buildDrafts -D --port 1315",
    "build:hugo": "npx --yes hugo-extended@0.159.2 --minify",
    "dev": "npm run dev:css & npm run dev:hugo",
    "build": "npm run build:css && npm run build:hugo",
    "clean": "rm -rf public resources assets/css/output.css"
  }
}
```

### Uso

```bash
# Desarrollo
npm run dev

# Producción
npm run build

# Limpiar
npm run clean
```

---


1. **No uses binarios globales** → dependen del sistema, rompen CI
2. **Fija versiones con npx** → `hugo-extended@0.159.2`
3. **Un comando para todo** → `npm run dev` y `npm run build`
4. **CI/CD simplificado** → sin setup de Go ni Hugo
5. **Reproducibilidad** → local = CI = cualquier colaborador

---

## 🔗 Recursos

- [Hugo Releases](https://github.com/gohugoio/hugo/releases) - Versiones disponibles
- [npx Documentation](https://docs.npmjs.com/cli/v9/commands/npx) - Más sobre npx
- [Hugo Extended](https://gohugo.io/installation/linux/#debian) - Diferencias básico vs extendido

---

## 💭 ¿Cómo manejas las versiones de herramientas?

¿Usas binarios globales, Docker, o npx? ¿Alguna vez tuviste un build que fallaba en CI pero no en local?
