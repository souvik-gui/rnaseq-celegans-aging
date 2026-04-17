# RNA-seq Aging Analysis (C. elegans)

## Overview
This project reanalyses publicly available RNA-seq data to study gene expression changes during aging in C. elegans.

## Tools used

- FastQC
- MultiQC
- HISAT2
- subread
- DESeq2 (planned)

## Workflow

1. Download data and reference
2. Quality control (FastQC, MultiQC)
3. Alignment (HISAT2)
4. Downstream analysis (planned)

## Dataset
Data sourced from NCBI SRA:
- SRR31011841
- SRR31011842
- SRR31011843
- SRR31011844
- SRR31011845
- SRR31011846
- SRR31011847
- SRR31011848

## Download data
```bash
bash scripts/01_download.sh

**## Quality Control**

Run FastQC and MultiQC:

```bash
bash scripts/02_qc.sh
