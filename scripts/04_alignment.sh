for R1 in data/*_1.fastq.gz
do
    base=$(basename "$R1" _1.fastq.gz)
    R2="data/${base}_2.fastq.gz"

    echo "Processing: $base"

    hisat2 -p 8 \
        -x reference/genome_tran \
        -1 "$R1" \
        -2 "$R2" \
        --dta \
        2> results/alignment/${base}.log | \
    samtools view -bS - | \
    samtools sort -o results/alignment/${base}.bam

    samtools index results/alignment/${base}.bam
done
