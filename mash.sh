#!/bin/bash
# MASH script with Alternaria reference genomes
ASSEMBLY_DIR="./results_assembly"
REFERENCE_DIR="./reference_genomes"
MASH_DIR="./results_mash_2"
SKETCH_DIR="$MASH_DIR/sketches"
THREADS=8

# Your sample IDs
SAMPLES=(2 8 20 24 25 54 58 59 64 79 82)

# Reference labels (with _reference suffix for clear identification)
REFS=("Alternaria_solani_reference" "Alternaria_alternata_reference" "Alternaria_arborescens_reference")
REF_FILES=("$REFERENCE_DIR/Alternaria_solani.fasta" "$REFERENCE_DIR/Alternaria_alternata.fasta" "$REFERENCE_DIR/Alternaria_arborescens.fasta")

mkdir -p "$SKETCH_DIR"

# Sketch sample genomes
for ID in "${SAMPLES[@]}"; do
  echo "[MASH] Sketching sample $ID..."
  mash sketch -p $THREADS -o "$SKETCH_DIR/${ID}" \
    "$ASSEMBLY_DIR/${ID}_spades/contigs.fasta"
done

# Sketch reference genomes
for i in "${!REFS[@]}"; do
  REF_NAME=${REFS[$i]}
  REF_FILE=${REF_FILES[$i]}
  echo "[MASH] Sketching reference genome $REF_NAME..."
  mash sketch -p $THREADS -o "$SKETCH_DIR/${REF_NAME}" "$REF_FILE"
done

# Combine all sketches
echo "[MASH] Combining all sketches..."
mash paste "$MASH_DIR/all_samples" "$SKETCH_DIR"/*.msh

# Calculate pairwise distances
echo "[MASH] Calculating pairwise distances..."
mash dist "$MASH_DIR/all_samples.msh" "$MASH_DIR/all_samples.msh" > "$MASH_DIR/mash_distances.txt"

# Build tree
echo "[MASH] Building tree..."
mash tree "$MASH_DIR/all_samples.msh" > "$MASH_DIR/tree.nwk"

echo "✅ Mash analysis complete!"
echo "Distance matrix: $MASH_DIR/mash_distances.txt"
echo "Tree file: $MASH_DIR/tree.nwk"
