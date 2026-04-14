#!/usr/bin/env python3
"""
Audit completo de los 15 posts contra la pabloib-writer SKILL.md checklist.
"""

import re
import os

POSTS_DIR = "content/posts"

TIER1 = [
    "Es importante destacar que",
    "En conclusión",
    "Vale la pena mencionar",
    "Hay que tener en cuenta",
    "Es evidente que",
    "Sin lugar a dudas",
    "Resulta fundamental",
    "En el ámbito de",
    "Cabe señalar que",
]

TIER2 = [
    "Además",
    "Por otro lado",
    "Asimismo",
    "No obstante",
    "Por consiguiente",
    "En consecuencia",
    "En este sentido",
]

BODY_NO_NO = [
    "Publicado:",  # bloquePublicado/Lectura
]


def count_words(text):
    return len(text.split())


def count_sentences(text):
    # Split on sentence-ending punctuation
    sentences = re.split(r"[.!?]+", text)
    return [s.strip() for s in sentences if s.strip() and count_words(s.strip()) > 2]


def parse_front_matter(content):
    """Extract front matter fields."""
    parts = content.split("---")
    if len(parts) < 3:
        return {}, content
    fm_text = parts[1]
    body = "---".join(parts[2:])
    fm = {}
    for line in fm_text.strip().split("\n"):
        if ":" in line:
            key = line.split(":")[0].strip()
            val = ":".join(line.split(":")[1:]).strip().strip('"')
            fm[key] = val
    return fm, body


def audit_post(filepath):
    """Full audit of a single post."""
    filename = os.path.basename(filepath)
    with open(filepath, "r") as f:
        content = f.read()

    fm, body = parse_front_matter(content)
    errors = []
    warnings = []
    passes = []

    # === FRONT MATTER ===

    # description length
    desc = fm.get("description", "")
    desc_len = len(desc)
    if desc_len < 150:
        errors.append(f"description: {desc_len} chars (< 150)")
    elif desc_len > 160:
        errors.append(f"description: {desc_len} chars (> 160)")
    else:
        passes.append(f"description: {desc_len} chars ✅")

    # categories
    cats = fm.get("categories", "")
    cat_count = len(re.findall(r"[\w]+", cats))
    if cat_count == 1:
        passes.append("categories: 1 ✅")
    else:
        errors.append(f"categories: {cat_count} (debe ser 1)")

    # tags count
    tags = fm.get("tags", "")
    tag_count = len(re.findall(r'"([^"]+)"', tags))
    if 3 <= tag_count <= 5:
        passes.append(f"tags: {tag_count} ✅")
    elif tag_count < 3:
        warnings.append(f"tags: {tag_count} (< 3)")
    else:
        warnings.append(f"tags: {tag_count} (> 5)")

    # mode
    mode = fm.get("mode", "")
    if mode in ("tutorial", "opinion", "guide", "review"):
        passes.append(f"mode: {mode} ✅")
    else:
        errors.append(f"mode: '{mode}' (inválido)")

    # lastmod
    if "lastmod" in fm:
        passes.append("lastmod: presente ✅")
    else:
        errors.append("lastmod: ausente")

    # no readingTime
    if "readingTime" not in fm:
        passes.append("sin readingTime ✅")
    else:
        errors.append("readingTime: presente (debe eliminarse)")

    # === ESTRUCTURA ===

    # Hook: first paragraph after front matter
    first_para = body.strip().split("\n\n")[0] if body.strip() else ""
    hook_words = count_words(first_para)
    hook_sentences = count_sentences(first_para)

    if hook_words > 75:
        errors.append(f"hook: {hook_words} palabras (> 75, demasiado largo)")
    else:
        passes.append(f"hook: {hook_words} palabras ✅")

    # "En este artículo" / "Hoy vamos a hablar"
    if re.search(r"En este artículo|Hoy vamos a hablar", body):
        errors.append('empieza con "En este artículo" o "Hoy vamos a hablar"')
    else:
        passes.append("no empieza con cliché ✅")

    # Cierre: last H2 heading
    h2s = re.findall(r"^## (.+)$", body, re.MULTILINE)
    if h2s:
        last_h2 = h2s[-1]
        if re.search(r"^En conclusión$", last_h2, re.IGNORECASE):
            errors.append("último H2: 'En conclusión'")
        elif re.search(r"^En resumen$", last_h2, re.IGNORECASE):
            warnings.append("último H2: 'En resumen' — ¿funciona sin heading?")
        else:
            passes.append(f"cierre H2: '{last_h2[:40]}' ✅")

    # No "En resumen" heading anywhere
    resumen_matches = re.findall(r"^## En resumen$", body, re.MULTILINE)
    if resumen_matches:
        errors.append(f"'## En resumen' heading: {len(resumen_matches)} encontrado(s)")
    else:
        passes.append("sin '## En resumen' ✅")

    # Internal links
    internal_links = re.findall(r"\[([^\]]+)\]\(/posts/", body)
    if len(internal_links) >= 2:
        passes.append(f"internal links: {len(internal_links)} ✅")
    else:
        warnings.append(f"internal links: {len(internal_links)} (< 2)")

    # No body redundancy
    if re.search(r"\*\*Publicado:\*\*", body):
        errors.append("bloque 'Publicado/Lectura' en body")
    else:
        passes.append("sin bloque 'Publicado/Lectura' ✅")

    if re.search(r"^\*\*Tags:\*\*", body, re.MULTILINE):
        errors.append("footer '**Tags:**' en body")
    else:
        passes.append("sin footer tags ✅")

    if re.search(r"Este artículo forma parte de la categoría", body):
        errors.append("footer categoría en body")
    else:
        passes.append("sin footer categoría ✅")

    # No "Lo que aprenderás"
    if re.search(r"Lo que aprenderás", body):
        errors.append("sección 'Lo que aprenderás' en body")
    else:
        passes.append("sin 'Lo que aprenderás' ✅")

    # === VOZ ===

    # Tier 1
    tier1_found = []
    for phrase in TIER1:
        if phrase.lower() in body.lower():
            tier1_found.append(phrase)
    if tier1_found:
        errors.append(f"Tier 1 ({len(tier1_found)}): {', '.join(tier1_found)}")
    else:
        passes.append("Tier 1: 0 ✅")

    # Tier 2
    tier2_found = []
    for phrase in TIER2:
        matches = re.findall(re.escape(phrase), body, re.IGNORECASE)
        if matches:
            tier2_found.append(f"{phrase}({len(matches)})")
    tier2_total = sum(int(re.search(r"\((\d+)\)", x).group(1)) for x in tier2_found)
    if tier2_total > 2:
        warnings.append(f"Tier 2: {tier2_total} ({', '.join(tier2_found)})")
    else:
        passes.append(f"Tier 2: {tier2_total} ✅")

    # Long sentences (>40 words)
    sentences = count_sentences(body)
    long_sents = [s for s in sentences if count_words(s) > 40]
    if long_sents:
        warnings.append(f"frases >40 palabras: {len(long_sents)}")
        for s in long_sents[:3]:
            warnings.append(f'  → "{s[:60]}..." ({count_words(s)}w)')
    else:
        passes.append("frases >40 palabras: 0 ✅")

    # Short sentences ratio (<10 words)
    if sentences:
        short = [s for s in sentences if count_words(s) < 10]
        short_pct = len(short) / len(sentences) * 100
        if short_pct >= 30:
            passes.append(f"frases cortas: {short_pct:.0f}% (≥30%) ✅")
        else:
            warnings.append(f"frases cortas: {short_pct:.0f}% (<30%)")

    # Honestidad autoconsciente
    honesty_patterns = [
        r"\bme di cuenta\b",
        r"\bno lo sé\b",
        r"\bno (lo|la) (sé|sabía|entiendo)\b",
        r"\bsé que esto va\b",
        r"\bno (soy|era) (ningún|un) experto\b",
        r"\badmit\b",
        r"\bfrancamente\b",
        r"\bhonestamente\b",
        r"\bno tengo\b",
        r"\bsigo sin\b",
        r"\baún no\b",
        r"\bme equivoc",
        r"\bfue un error\b",
    ]
    honesty_found = sum(
        1 for p in honesty_patterns if re.search(p, body, re.IGNORECASE)
    )
    if honesty_found >= 1:
        passes.append(f"honestidad autoconsciente: {honesty_found} ✅")
    else:
        warnings.append("honestidad autoconsciente: 0 (añadir al menos 1)")

    # Analogía del día a día
    analogy_patterns = [
        r"como una? (pila|nevera|armario|cocina|caja|libro|muro)",
        r"como si (fuer|estuvier)",
        r"es como\b",
        r"imagin(a|e) (esto|una|que|el|la)",
        r"piensa en\b",
        r"piensa( lo)? como\b",
        r"equivaldr(ía|e)a\b",
    ]
    analogies = sum(1 for p in analogy_patterns if re.search(p, body, re.IGNORECASE))
    if analogies >= 1:
        passes.append(f"analogía día a día: {analogies} ✅")
    else:
        warnings.append("analogía día a día: 0 (añadir al menos 1)")

    # === SEO ===

    # Keyword in title, description, first H2
    title = fm.get("title", "")
    if h2s:
        # Simple check: is there a meaningful word overlap between title and first H2?
        title_words = set(re.findall(r"\b\w{4,}\b", title.lower()))
        h2_words = set(re.findall(r"\b\w{4,}\b", h2s[0].lower()))
        overlap = title_words & h2_words
        if overlap:
            passes.append(f"keyword en title+H2: {', '.join(list(overlap)[:3])} ✅")
        else:
            warnings.append("keyword: poco overlap entre title y primer H2")

    return {
        "filename": filename,
        "mode": mode,
        "errors": errors,
        "warnings": warnings,
        "passes": passes,
    }


def main():
    os.chdir(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

    posts = sorted([f for f in os.listdir(POSTS_DIR) if f.endswith(".md")])

    total_errors = 0
    total_warnings = 0
    total_passes = 0

    print("=" * 70)
    print("  AUDIT COMPLETO — pabloib-writer checklist × 15 posts")
    print("=" * 70)

    for filename in posts:
        filepath = os.path.join(POSTS_DIR, filename)
        result = audit_post(filepath)

        total_errors += len(result["errors"])
        total_warnings += len(result["warnings"])
        total_passes += len(result["passes"])

        has_issues = result["errors"] or result["warnings"]

        if has_issues:
            print(f"\n{'─' * 70}")
            print(f"  {filename}  [{result['mode']}]")
            print(f"{'─' * 70}")

        for e in result["errors"]:
            print(f"  ❌ {e}")
        for w in result["warnings"]:
            print(f"  ⚠️  {w}")

    # Summary
    print(f"\n{'=' * 70}")
    print("  RESUMEN")
    print(f"{'=' * 70}")
    print(f"  ✅ Passes:  {total_passes}")
    print(f"  ⚠️  Warnings: {total_warnings}")
    print(f"  ❌ Errors:   {total_errors}")
    print()

    if total_errors == 0:
        print("  🎉 Sin errores. Solo warnings para revisión opcional.")
    else:
        print(f"  ⚡ {total_errors} error(es) requieren corrección antes de publicar.")


if __name__ == "__main__":
    main()
