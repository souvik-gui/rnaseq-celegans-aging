# RNA-seq Aging Analysis in *Caenorhabditis elegans*

This project performs a complete RNA-seq analysis pipeline to study gene expression changes associated with 50uM Urolithin A (A potent mitophagy inducer) treatment in *Caenorhabditis elegans* using publicly available RNA sequencing data (GSE279559).

---

##  Study Objective

The goal of this project is to identify gene expression changes during aging by processing raw RNA-seq data through a reproducible computational pipeline, from quality control to gene-level quantification.

---

##  Dataset

Public RNA-seq datasets were obtained from NCBI SRA:

- SRR31011841  (50uM Urolithin A treated Rep-1)
- SRR31011842  (50uM Urolithin A treated Rep-2)
- SRR31011843  (50uM Urolithin A treated Rep-3)
- SRR31011844  (50uM Urolithin A treated Rep-4)
- SRR31011845  (Conrol Rep-1)
- SRR31011846  (Conrol Rep-2)
- SRR31011847  (Conrol Rep-3)
- SRR31011848  (Conrol Rep-4)

Organism: *Caenorhabditis elegans*  
Reference genome: WBcel235 (Ensembl)

---

##  Tools & Software

- FastQC – raw read quality control  
- MultiQC – aggregated QC reporting  
- HISAT2 – read alignment to reference genome  
- samtools – BAM processing  
- Subread (featureCounts) – gene-level quantification  
- DESeq2 – differential expression analysis  

---

##  Workflow Overview

The pipeline follows a standard RNA-seq workflow:

1. Data acquisition  
2. Quality control of raw reads  
3. Reference genome indexing  
4. Read alignment  
5. BAM processing and sorting  
6. Gene-level quantification  
7. Differential expression analysis 

---

##  Data Download

Raw sequencing data was obtained using:

```bash
bash scripts/01_download.sh
```

## Results

### Principal Component Analysis (PCA)

![PCA Plot](reference/results/C_elegans_treated_vs_Control_PCA.png)

Principal Component Analysis (PCA) reveals clear separation between control and UA-treated samples along PC1 (49% variance), indicating strong treatment-driven transcriptional differences. Notably, higher dispersion among control replicates suggests intra-group variability, which may reduce statistical power in downstream differential expression analysis.

---

## Differential Expression Analysis

### Volcano Plot

![Volcano Plot](reference/results/volcano_plot_publication.png)

The volcano plot summarizes differential gene expression between UA-treated and control samples. Genes were classified as significant based on the following thresholds:

- |log2 Fold Change| ≥ 0.1  
- Adjusted p-value (FDR) < 0.05  

Upregulated genes are shown in green, while downregulated genes are shown in red. Highly significant genes are capped at -log10(adjusted p-value) = 30 for improved visualization. The top differentially expressed genes (ranked by combined effect size and significance) are labeled.

Overall, the distribution indicates a modest but biologically relevant shift in gene expression upon UA treatment.
