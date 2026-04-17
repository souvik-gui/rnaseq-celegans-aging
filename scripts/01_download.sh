#!/bin/bash

set -e

# Create directories
mkdir -p data
mkdir -p reference

# -------------------------------
# Download RNA-seq data
# -------------------------------

wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR310/042/SRR31011842/SRR31011842_1.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR310/048/SRR31011848/SRR31011848_1.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR310/044/SRR31011844/SRR31011844_1.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR310/045/SRR31011845/SRR31011845_1.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR310/047/SRR31011847/SRR31011847_1.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR310/048/SRR31011848/SRR31011848_2.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR310/042/SRR31011842/SRR31011842_2.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR310/044/SRR31011844/SRR31011844_2.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR310/046/SRR31011846/SRR31011846_2.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR310/041/SRR31011841/SRR31011841_2.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR310/046/SRR31011846/SRR31011846_1.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR310/043/SRR31011843/SRR31011843_1.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR310/041/SRR31011841/SRR31011841_1.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR310/043/SRR31011843/SRR31011843_2.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR310/047/SRR31011847/SRR31011847_2.fastq.gz
wget -nc http://ftp.sra.ebi.ac.uk/vol1/fastq/SRR310/045/SRR31011845/SRR31011845_2.fastq.gz


