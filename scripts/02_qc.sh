#!/bin/bash

set -e

# -------------------------------
# CONFIGURATION
# -------------------------------

FASTQ_DIR="data"
OUT_DIR="results/qc"
THREADS=8

mkdir -p $OUT_DIR

# Run FastQC on all FASTQ files
fastqc ${FASTQ_DIR}/*.fastq.gz -o $OUT_DIR -t $THREADS

# Run MultiQC to summarize reports
multiqc $OUT_DIR -o $OUT_DIR

echo "QC completed!"
