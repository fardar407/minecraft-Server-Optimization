#!/bin/bash
# Clean modpack folder by moving disabled, duplicate, and client-only mods to ignored.
set -e
MODDIR="${1:-$(pwd)/mods}"
if [ ! -d "$MODDIR" ]; then
  echo "ERROR: folder '$MODDIR' not found."
  exit 1
fi
IGNORED="$MODDIR/ignored"
mkdir -p "$IGNORED"

echo "Cleaning mod folder: $MODDIR"
for file in "$MODDIR"/*.jar "$MODDIR"/*.jar.disabled; do
  [ -e "$file" ] || continue
  name=$(basename "$file")
  if [[ "$name" == *.disabled ]]; then
    echo "Moving disabled mod: $name"
    mv -f "$file" "$IGNORED/"
    continue
  fi
  if [[ "$name" == *.duplicate ]]; then
    echo "Moving duplicate mod: $name"
    mv -f "$file" "$IGNORED/"
    continue
  fi
  if [[ "$name" =~ sodium|sodiumdynamiclights|cloth-config|iris|optifine|canvas ]]; then
    echo "Moving client-only mod: $name"
    mv -f "$file" "$IGNORED/"
    continue
  fi
done

echo "Clean complete. Moved non-server mods to $IGNORED."
