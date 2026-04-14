#!/usr/bin/env python3
"""
Limpieza masiva de los 13 posts restantes del blog pabloib.com.

Lecciones aprendidas (de la validación manual de 2 posts):
1. readingTime: eliminar siempre (Hugo lo calcula)
2. lastmod: copiar de date (no usar fecha de hoy)
3. mode: asignar valor por defecto según contenido, marcar para revisión
4. Bloque "Publicado/Lectura": eliminar (Hugo ya lo renderiza)
5. Footer tags/categoría: eliminar (Hugo ya lo renderiza)
6. "En resumen": eliminar heading, CONSERVAR contenido (no se puede automatizar el cierre)
7. description: reportar si excede 160 chars, NO modificar (requiere juicio humano)
"""

import re
import os

POSTS_DIR = "content/posts"

# Posts ya corregidos manualmente
ALREADY_FIXED = {
    "2026-03-23-pi-cambio-mi-workflow.md",
    "2026-03-25-ant-colony-cuando-un-agente-no-es-suficiente.md",
}

# Mode por defecto según palabras clave en el contenido
MODE_HINTS = {
    "tutorial": [
        "paso a paso",
        "cómo instalar",
        "cómo configurar",
        "setup",
        "guía rápida",
    ],
    "guide": ["guía completa", "cómo funciona", "qué es", "profundidad", "explicación"],
    "opinion": [
        "mi workflow",
        "mi experiencia",
        "por qué cambio",
        "reflexión",
        "opinión",
    ],
    "review": ["vs ", "versus", "comparación", "cuál usar", "cuándo usar cada"],
}


def infer_mode(title, body):
    """Inferir mode a partir del título y contenido."""
    text = (title + " " + body).lower()
    scores = {}
    for mode, keywords in MODE_HINTS.items():
        score = sum(1 for kw in keywords if kw in text)
        scores[mode] = score
    best = max(scores, key=lambda k: scores[k])
    if scores[best] > 0:
        return best
    return "guide"  # default seguro para posts técnicos


def fix_front_matter(content, filename):
    """Corregir front matter: eliminar readingTime, añadir lastmod y mode."""
    changes = []

    # Split into parts
    parts = content.split("---")
    if len(parts) < 3:
        return content, changes, []
    fm = parts[1]
    body = "---".join(parts[2:])
    warnings = []

    # 1. Eliminar readingTime
    if re.search(r"^readingTime:", fm, re.MULTILINE):
        fm = re.sub(r"^readingTime:.*\n", "", fm, flags=re.MULTILINE)
        changes.append("  ✅ Eliminado readingTime")

    # 2. Extraer date para lastmod
    date_match = re.search(r"^date:\s*(.+)$", fm, re.MULTILINE)
    date_val = date_match.group(1).strip() if date_match else None

    # 3. Añadir lastmod si no existe
    if not re.search(r"^lastmod:", fm, re.MULTILINE):
        if date_val:
            # Insertar lastmod después de date
            fm = re.sub(
                r"^(date:\s*.+)$", r"\1\nlastmod: " + date_val, fm, flags=re.MULTILINE
            )
            changes.append(f"  ✅ Añadido lastmod: {date_val}")

    # 4. Añadir mode si no existe
    if not re.search(r"^mode:", fm, re.MULTILINE):
        title_match = re.search(r'^title:\s*"(.+)"', fm, re.MULTILINE)
        title = title_match.group(1) if title_match else ""
        inferred = infer_mode(title, body)
        # Insertar mode después de tags
        fm = re.sub(
            r"^(tags:\s*\[.+?\])$",
            r"\1\nmode: " + inferred + "  # ← revisar",
            fm,
            flags=re.MULTILINE,
        )
        changes.append(f"  ⚠️ Añadido mode: {inferred} (← revisar)")
        warnings.append(f"mode: {inferred} — revisar si es correcto")

    # 5. Verificar description length
    desc_match = re.search(r'^description:\s*"(.+)"', fm, re.MULTILINE)
    if desc_match:
        desc_len = len(desc_match.group(1))
        if desc_len > 160:
            changes.append(
                f"  ⚠️ description: {desc_len} chars (excede 160, revisar manualmente)"
            )
            warnings.append(f"description: {desc_len} chars — recortar a 150-160")
        elif desc_len < 150:
            changes.append(f"  ⚠️ description: {desc_len} chars (menos de 150, revisar)")
            warnings.append(f"description: {desc_len} chars — ampliar a 150-160")
        else:
            changes.append(f"  ✅ description: {desc_len} chars")

    return "---" + fm + "---" + body, changes, warnings


def fix_body(content):
    """Corregir body: eliminar bloque Publicado/Lectura, footer tags, heading En resumen."""
    changes = []
    warnings = []
    parts = content.split("---")
    if len(parts) < 3:
        return content, changes, warnings
    body = "---".join(parts[2:])

    # 1. Eliminar bloque "Publicado/Lectura"
    publicado_pattern = r"\*\*Publicado:\*\*.*?\n\n"
    if re.search(publicado_pattern, body):
        body = re.sub(publicado_pattern, "", body)
        changes.append("  ✅ Eliminado bloque 'Publicado/Lectura'")

    # 2. Eliminar "Lo que aprenderás" (metadato, no contenido)
    aprender_pattern = r"\n---\n\n## 🎯 Lo que aprenderás\n\n.*?(?=\n---\n\n##|\n## )"
    if re.search(aprender_pattern, body, re.DOTALL):
        body = re.sub(aprender_pattern, "", body, flags=re.DOTALL)
        changes.append("  ✅ Eliminada sección 'Lo que aprenderás'")

    # 3. Eliminar footer tags + categoría
    # Patrón A: **Tags:** `tag1`, `tag2` ... hasta el final
    tags_pattern = r"\n---\n\n\*\*Tags:\*\*.*$"
    if re.search(tags_pattern, body, re.DOTALL | re.MULTILINE):
        body = re.sub(tags_pattern, "", body, flags=re.DOTALL | re.MULTILINE)
        changes.append("  ✅ Eliminado footer '**Tags:**'")

    # Patrón B: línea de categoría
    cat_pattern = r"\n---\n\n\*Este artículo forma parte de la categoría.*$"
    if re.search(cat_pattern, body, re.DOTALL | re.MULTILINE):
        body = re.sub(cat_pattern, "", body, flags=re.DOTALL | re.MULTILINE)
        changes.append("  ✅ Eliminado footer categoría")

    # 4. Eliminar heading "En resumen" pero CONSERVAR el contenido
    resumen_pattern = r"^## En resumen$\n"
    if re.search(resumen_pattern, body, re.MULTILINE):
        body = re.sub(resumen_pattern, "", body, flags=re.MULTILINE)
        changes.append("  ⚠️ Eliminado heading '## En resumen' (contenido conservado)")
        warnings.append(
            "'## En resumen' eliminado — revisar si el cierre funciona sin heading"
        )

    # 5. Limpiar múltiples blank lines consecutivos (máx 2)
    body = re.sub(r"\n{4,}", "\n\n\n", body)

    # Limpiar trailing whitespace
    body = body.strip() + "\n"

    return "---" + parts[1] + "---" + body, changes, warnings


def process_post(filepath):
    """Procesar un post completo."""
    filename = os.path.basename(filepath)

    with open(filepath, "r") as f:
        content = f.read()

    print(f"\n{'─' * 60}")
    print(f"📝 {filename}")
    print(f"{'─' * 60}")

    # Fix front matter
    content, fm_changes, fm_warnings = fix_front_matter(content, filename)

    # Fix body
    content, body_changes, body_warnings = fix_body(content)

    all_changes = fm_changes + body_changes
    all_warnings = fm_warnings + body_warnings

    if not all_changes:
        print("  (nada que cambiar)")
        return False, []

    for change in all_changes:
        print(change)

    # Write back
    with open(filepath, "w") as f:
        f.write(content)

    print("  💾 Guardado")

    return True, all_warnings


def main():
    os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

    posts = sorted([f for f in os.listdir(POSTS_DIR) if f.endswith(".md")])
    pending = [f for f in posts if f not in ALREADY_FIXED]

    print(f"Posts totales: {len(posts)}")
    print(f"Ya corregidos: {len(ALREADY_FIXED)}")
    print(f"Pendientes: {len(pending)}")

    all_warnings = []
    modified_count = 0

    for filename in pending:
        filepath = os.path.join(POSTS_DIR, filename)
        modified, warnings = process_post(filepath)
        if modified:
            modified_count += 1
            all_warnings.extend([(filename, w) for w in warnings])

    print(f"\n{'=' * 60}")
    print(f"  Resultado: {modified_count}/{len(pending)} posts modificados")
    print(f"{'=' * 60}")

    if all_warnings:
        print(f"\n⚠️  {len(all_warnings)} advertencias para revisión manual:")
        for filename, warning in all_warnings:
            print(f"  • {filename}: {warning}")


if __name__ == "__main__":
    main()
