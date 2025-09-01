#!/bin/bash

# Ensure conda activate works in scripts
__conda_setup="$('/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
eval "$__conda_setup"

IN_DIR="~/my_materials/project/trimmed_reads"
OUT_DIR="./results_assembly"
THREADS=4
SAMPLES=(66)

mkdir -p "$OUT_DIR"

conda activate assembly

for ID in "${SAMPLES[@]}"; do
  echo "[ASSEMBLY] Sample $ID"

  spades.py -1 "$IN_DIR/${ID}_1.paired.fq" -2 "$IN_DIR/${ID}_2.paired.fq" \
            -o "$OUT_DIR/${ID}_spades" --careful -t $THREADS
done

echo "✅ Batch 3 complete: Assemblies saved to $OUT_DIR"
