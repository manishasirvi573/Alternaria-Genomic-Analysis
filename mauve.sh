#!/bin/bash

# Activate conda (adjust if your conda is installed elsewhere)
__conda_setup="$('/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
eval "$__conda_setup"

# Activate your conda env with Java (if needed)
conda activate mauve_env  # change if your env name is different

THREADS=8  # unused by Mauve, but keep for consistency

# Set paths (avoid ~ in quotes)
SAMPLE_DIR="$HOME/my_materials/project/results_assembly"
REF_DIR="$HOME/my_materials/project/reference_genomes"

# Sample IDs (adjust as needed)
SAMPLES=(2 8 20 24 25 54 58 59 64 79 82)

# Prepare array to hold all fasta file paths
declare -a ALL_FASTAS=()

# Add sample contigs.fasta files
for ID in "${SAMPLES[@]}"; do
  FASTA_PATH="$SAMPLE_DIR/${ID}_spades/contigs.fasta"
  if [ -f "$FASTA_PATH" ]; then
    ALL_FASTAS+=("$FASTA_PATH")
  else
    echo "Warning: File not found: $FASTA_PATH"
  fi
done

# Add reference genomes (adjust filenames accordingly)
REFS=(
  "$REF_DIR/solani_ref_1.fasta"
  "$REF_DIR/alternata_ref_1.fasta"
  "$REF_DIR/arborescens_ref_1.fasta"
  # Add more refs if you have them
)

for REF in "${REFS[@]}"; do
  if [ -f "$REF" ]; then
    ALL_FASTAS+=("$REF")
  else
    echo "Warning: Reference genome not found: $REF"
  fi
done

# Check if we have at least two genomes to align
if [ "${#ALL_FASTAS[@]}" -lt 2 ]; then
  echo "Error: Not enough genomes to align. Exiting."
  exit 1
fi

# Run progressiveMauve with all genomes
echo "Running progressiveMauve on ${#ALL_FASTAS[@]} genomes..."

# Path to progressiveMauve binary (change if installed elsewhere)
MAUVE_BIN="$HOME/my_materials/project/mauve/linux-x64/progressiveMauve"

if [ ! -x "$MAUVE_BIN" ]; then
  echo "Error: Mauve binary not found or not executable at $MAUVE_BIN"
  exit 1
fi

# Run Mauve alignment
"$MAUVE_BIN" \
  --output=alternaria_alignment.xmfa \
  --output-guide-tree=alternaria_guide.tree \
  --backbone-output=alternaria_backbone.txt \
  "${ALL_FASTAS[@]}"

echo "Mauve alignment complete. Output files:"
echo " - alternaria_alignment.xmfa"
echo " - alternaria_guide.tree"
echo " - alternaria_backbone.txt"
