#!/usr/bin/env bash
set -e
SRC=resume.md
OUT=resume

# preprocess: right-aligned dates, contact-block line breaks, blank line before lists,
# and grouping of institution/program (and role) lines into a single block.
sed -E 's/^(\*\*.+\*\*) — (.+)$/\1 <span class="date">\2<\/span>/' "$SRC" \
| sed -E '/^(Contact No|Bayan Lepas)/ s/$/\\/' \
| awk '
  /^- / && prev != "" && prev !~ /^- / { print "" }
  # a bold line directly after a bold line is a sub-line (program / role): keep it tight
  /^\*\*/ && prev ~ /^\*\*/ { print "" }
  { print; prev=$0 }
' \
> .build.md

pandoc .build.md -f markdown+raw_html -s --css=resume.css \
  --metadata pagetitle="Aqil Yusri - Resume" -o "$OUT.html"
weasyprint "$OUT.html" "$OUT.pdf" 2>/dev/null
echo "Built $OUT.pdf at $(date +%T)"
