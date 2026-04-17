#!/bin/bash

set -e
set -o pipefail

# -------------------------------
# CONFIGURATION
# -------------------------------

REF_DIR="reference"
OUT_DIR="$HOME/rnaseq_reference"
THREADS=8

mkdir -p "$OUT_DIR"
cd "$OUT_DIR"

echo "Downloading C. elegans genome and annotation..."

# Genome
wget -c https://ftp.ensembl.org/pub/release-110/fasta/caenorhabditis_elegans/dna/Caenorhabditis_elegans.WBcel235.dna.toplevel.fa.gz

# GTF
wget -c https://ftp.ensembl.org/pub/release-110/gtf/caenorhabditis_elegans/Caenorhabditis_elegans.WBcel235.110.gtf.gz

echo "Unzipping files..."
gunzip -f *.gz

GENOME="Caenorhabditis_elegans.WBcel235.dna.toplevel.fa"
GTF="Caenorhabditis_elegans.WBcel235.110.gtf"

echo "Extracting splice sites and exons..."

hisat2_extract_splice_sites.py "$GTF" > splicesites.txt
hisat2_extract_exons.py "$GTF" > exons.txt

echo "Building HISAT2 index..."

hisat2-build -p $THREADS \
  --ss splicesites.txt \
  --exon exons.txt \
  "$GENOME" genome_tran

echo "Index build completed successfully!"
