# RNA-seq Aging Analysis in *Caenorhabditis elegans*

This project performs a complete RNA-seq analysis pipeline to study gene expression changes associated with aging in *Caenorhabditis elegans* using publicly available sequencing data.

---

## 🧬 Study Objective

The goal of this project is to identify gene expression changes during aging by processing raw RNA-seq data through a reproducible computational pipeline, from quality control to gene-level quantification.

---

## 📊 Dataset

Public RNA-seq datasets were obtained from NCBI SRA:

- SRR31011841  
- SRR31011842  
- SRR31011843  
- SRR31011844  
- SRR31011845  
- SRR31011846  
- SRR31011847  
- SRR31011848  

Organism: *Caenorhabditis elegans*  
Reference genome: WBcel235 (Ensembl)

---

## 🛠️ Tools & Software

- FastQC – raw read quality control  
- MultiQC – aggregated QC reporting  
- HISAT2 – read alignment to reference genome  
- samtools – BAM processing  
- Subread (featureCounts) – gene-level quantification  
- DESeq2 (planned) – differential expression analysis  

---

## ⚙️ Workflow Overview

The pipeline follows a standard RNA-seq workflow:

1. Data acquisition  
2. Quality control of raw reads  
3. Reference genome indexing  
4. Read alignment  
5. BAM processing and sorting  
6. Gene-level quantification  
7. Differential expression analysis (future step)

---

## 📥 Data Download

Raw sequencing data was obtained using:

```bash
bash scripts/01_download.sh
