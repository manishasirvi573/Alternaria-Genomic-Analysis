#!/bin/bash

# Enable conda activate in script
eval "$(/miniconda3/bin/conda shell.bash hook)"

# Define paths (do not use ~ inside variables—expand it first!)
READS_DIR="$HOME/my_materials/project/Arborescens_Sequences"
OUT_DIR="$HOME/my_materials/project/trimmed_reads"
THREADS=8
SAMPLES=(2 8 20 24 25 26 34 35 37 38 54 56 58 59 60 64 66 73 79 80 82 89 96 116)

# Create output directory if it doesn't exist
mkdir -p "$OUT_DIR"

# Activate conda environment
conda activate trim_quality

# Loop over sample IDs
for ID in "${SAMPLES[@]}"; do
  echo "[TRIM] Processing sample $ID..."

  trimmomatic PE -threads $THREADS \
    "$READS_DIR/${ID}_1.fq" "$READS_DIR/${ID}_2.fq" \
    "$OUT_DIR/${ID}_1.paired.fq" "$OUT_DIR/${ID}_1.unpaired.fq" \
    "$OUT_DIR/${ID}_2.paired.fq" "$OUT_DIR/${ID}_2.unpaired.fq" \
    SLIDINGWINDOW:4:20 MINLEN:50
done

echo "✅ Trimming complete. Outputs saved to $OUT_DIR"
