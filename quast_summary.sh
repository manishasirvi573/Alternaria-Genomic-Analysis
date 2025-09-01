#!/bin/bash

QUAST_OUT_DIR="./results_quast"
SUMMARY_FILE="./results_quast/QUAST_summary.tsv"

# Header
echo -e "Sample\t# contigs\tTotal length\tN50\tGC (%)" > "$SUMMARY_FILE"

for QUAST_FOLDER in "$QUAST_OUT_DIR"/*_quast; do
    SAMPLE=$(basename "$QUAST_FOLDER" _quast)
    REPORT_FILE="$QUAST_FOLDER/report.tsv"

    if [[ -f "$REPORT_FILE" ]]; then
        CONTIGS=$(awk -F'\t' '$1 == "# contigs" {print $2}' "$REPORT_FILE" | xargs)
        TOTAL_LEN=$(awk -F'\t' '$1 == "Total length" {print $2}' "$REPORT_FILE" | xargs)
        N50=$(awk -F'\t' '$1 == "N50" {print $2}' "$REPORT_FILE" | xargs)
        GC=$(awk -F'\t' '$1 == "GC (%)" {print $2}' "$REPORT_FILE" | xargs)

        if [[ -n "$CONTIGS" || -n "$TOTAL_LEN" || -n "$N50" || -n "$GC" ]]; then
            echo -e "${SAMPLE}\t${CONTIGS}\t${TOTAL_LEN}\t${N50}\t${GC}" >> "$SUMMARY_FILE"
        else
            echo "[⚠️ Warning] Empty values for $SAMPLE"
        fi
    else
        echo "[❌ Missing] $REPORT_FILE not found"
    fi
done

echo "✅ QUAST summary written to: $SUMMARY_FILE"