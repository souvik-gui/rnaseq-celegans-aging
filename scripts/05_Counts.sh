set -e
set -o pipefail

# -------------------------------
# CONFIGURATION
# -------------------------------

BAM_DIR="results/alignment"
OUT_DIR="results/counts"
GTF="reference/Caenorhabditis_elegans.WBcel235.110.gtf"
THREADS=8

mkdir -p "$OUT_DIR"

echo "Running featureCounts..."

featureCounts \
    -T $THREADS \
    -p \
    -a "$GTF" \
    -o "$OUT_DIR/gene_counts.txt" \
    -t exon \
    -g gene_id \
    $BAM_DIR/*.bam

echo "Counting completed!"
