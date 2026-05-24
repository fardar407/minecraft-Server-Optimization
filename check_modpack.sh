#!/bin/bash
# Check a modpack folder for compatibility issues, duplicates, and heavy mods.
set -e
MODDIR="${1:-mods}"
if [ ! -d "$MODDIR" ]; then
  echo "ERROR: folder '$MODDIR' not found."
  echo "Usage: ./check_modpack.sh mods"
  exit 1
fi

shopt -s nullglob
files=("$MODDIR"/*.jar "$MODDIR"/*.jar.disabled)
if [ ${#files[@]} -eq 0 ]; then
  echo "No mod files found in '$MODDIR'."
  exit 0
fi

count=0
disabled=0
duplicates=0
heavy=0
perf=0
fabric=0
forge=0
client_only=0

check_pattern() {
  case "$1" in
    *sodium*|*sodiumdynamiclights*|*iris*|*fabric-api*|*cloth-config*|*optifine*|*canvas*) return 0;;
    *) return 1;;
  esac
}

check_heavy() {
  case "$1" in
    *CustomNPCs*|*Immersive*Vehicles*|*Epic*Fight*|*Waystones*|*Blood*N*Particles*|*Immersive*Vehicles*|*CustomNPCs*) return 0;;
    *) return 1;;
  esac
}

check_perf() {
  case "$1" in
    *ferritecore*|*spark*|*Chunky*|*entityculling*|*Phosphor*|*phosphor*) return 0;;
    *) return 1;;
  esac
}

for file in "${files[@]}"; do
  if [ ! -e "$file" ]; then
    continue
  fi
  name=$(basename "$file")
  count=$((count + 1))
  case "$name" in
    *.disabled) disabled=$((disabled + 1));;
  esac
  case "$name" in
    *.duplicate) duplicates=$((duplicates + 1)); echo "WARNING: duplicate file detected: $name";;
  esac
  case "$name" in
    *fabric*|*Fabric*) fabric=1;;
  esac
  case "$name" in
    *forge*|*Forge*) forge=1;;
  esac
  if check_pattern "$name"; then
    client_only=$((client_only + 1))
    echo "WARNING: client-only or renderer mod found: $name"
  fi
  if check_heavy "$name"; then
    heavy=$((heavy + 1))
    echo "INFO: heavy mod candidate: $name"
  fi
  if check_perf "$name"; then
    perf=1
  fi
done

printf "\nTotal mod files found: %d\n" "$count"
printf "Disabled mods: %d\n" "$disabled"
printf "Duplicate marker files: %d\n" "$duplicates"
if [ $fabric -eq 1 ]; then echo "WARNING: Fabric mod files detected."; fi
if [ $forge -eq 1 ]; then echo "WARNING: Forge mod files detected."; fi
if [ $fabric -eq 1 ] && [ $forge -eq 1 ]; then echo "WARNING: mixed Fabric and Forge files may not work together."; fi
if [ $client_only -gt 0 ]; then printf "WARNING: %d candidate client-only mods detected.\n" "$client_only"; fi
if [ $heavy -gt 0 ]; then printf "INFO: %d heavy mod candidates detected.\n" "$heavy"; fi
if [ $perf -eq 1 ]; then
  echo "INFO: performance mods found (good)."
else
  echo "WARNING: no core performance mods detected. Add FerriteCore, Phosphor, Chunky, or Spark."
fi

echo
echo Recommendations:
echo - Remove disabled and duplicate files before deploying.
echo - Use only the correct loader: Forge or Fabric, not both.
echo - Keep server install clean: server-side mods only.
echo - Run this check again after cleaning.
