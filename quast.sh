#!/bin/bash

# Activate conda (assumes conda is installed in /miniconda3)
__conda_setup="$('/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
eval "$__conda_setup"

# Use specific conda environment if needed
conda activate trim_quality  # Uncomment and set your env name if required

THREADS=8

# Set paths (avoid using ~ in variables – it won't expand inside quotes)
SAMPLE_DIR="$HOME/my_materials/project/results_assembly"
RESULTS="$HOME/my_materials/project/results_quast"
SAMPLES=(2 8 20 24 25 26 34 35 37 38 54 56 58 59 60 64 66 73 79 80 82 89 96 116) 

# Create results directory if it doesn't exist
mkdir -p "$RESULTS"

# Log start
echo "------------------  QUAST STARTED ------------------"

# Run QUAST on all contigs.fasta files from SPAdes output folders

for ID in "${SAMPLES[@]}"; do
  echo "[QUAST] Sample $ID"
  echo "Looking for: $SAMPLE_DIR/${ID}_spades/contigs.fasta"
  ls "$SAMPLE_DIR/${ID}_spades/contigs.fasta"


  quast.py "$SAMPLE_DIR/${ID}_spades/contigs.fasta" \
            -o "$RESULTS/${ID}_quast" -t $THREADS

done

echo "------------------  QUAST FINISHED ------------------"

