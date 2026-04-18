library(DESeq2)
library(rtracklayer)
library(openxlsx)
library(ggplot2)

# Import the count table from working directory
counts <- read.table("gene_counts.txt",
                     header=TRUE,
                     row.names = 1)

# Consider only the read count columns
counts <- counts[,6:ncol(counts)]

# Check the heading of the columns
colnames(counts)

# Define samples and Conditions
samples <- c(
  "results.alignment.SRR31011841.bam",
  "results.alignment.SRR31011842.bam",
  "results.alignment.SRR31011843.bam",
  "results.alignment.SRR31011844.bam",
  "results.alignment.SRR31011845.bam",
  "results.alignment.SRR31011846.bam",
  "results.alignment.SRR31011847.bam",
  "results.alignment.SRR31011848.bam"
)

condition <- c(
  "UA_50uM", "UA_50uM", "UA_50uM", "UA_50uM",
  "Control", "Control", "Control", "Control"
)

# Create metadata
coldata <- data.frame(row.names = samples,
                      condition = factor(condition))

# Check if the metadata and column names matches
coldata <- coldata[colnames(counts), , drop = FALSE]
all(rownames(coldata) == colnames(counts))

# Combine the Counts, metadata and experimental design
dds <- DESeqDataSetFromMatrix(
  countData = counts,
  colData = coldata,
  design = ~condition
)

# Make sure control is reference
dds$condition <- relevel(dds$condition, ref = "Control")

# Run DESeq2
dds <- DESeq(dds)

# Check for available comparisons
resultsNames(dds)

# assign a variable for the desired comparison and get the summary
# with your desired log 2 fold change value and p adjusted value

res <- results(dds, 
               name =  "condition_UA_50uM_vs_Control",
               lfcThreshold = 1,
               alpha = 0.05
               )

summary(res)

# Convert to data frame
res_df <- as.data.frame(res)

# Add gene ids as row names
res_df$gene_id <- rownames(res_df)

# Removes version numbers like ".1"
res_df$gene_id <- sub("\\..*", "", res_df$gene_id)

# load the gtf file
gtf <- import("Caenorhabditis_elegans.WBcel235.110.gtf")

# Keep only gene entries
gtf_genes <- gtf[gtf$type == "gene"]

# Check available fields if unsure:
colnames(mcols(gtf_genes))

# Extract annotation
annot <- data.frame(
  gene_id = gtf_genes$gene_id,
  gene_name = if ("gene_name" %in% colnames(mcols(gtf_genes))) {
    gtf_genes$gene_name
  } else if ("Name" %in% colnames(mcols(gtf_genes))) {
    gtf_genes$Name
  } else {
    NA
  },
  gene_biotype = if ("gene_biotype" %in% colnames(mcols(gtf_genes))) {
    gtf_genes$gene_biotype
  } else if ("biotype" %in% colnames(mcols(gtf_genes))) {
    gtf_genes$biotype
  } else {
    NA
  },
  stringsAsFactors = FALSE
)

# Fix gene IDs in annotation too
annot$gene_id <- sub("\\..*", "", annot$gene_id)

# Remove duplicates
annot <- annot[!duplicated(annot$gene_id), ]

# Merge results with annotation
final_df <- merge(res_df, annot, by = "gene_id", all.x = TRUE)

# Reorder columns
final_df <- final_df[, c(
  "gene_id",
  "gene_name",
  "gene_biotype",
  "baseMean",
  "log2FoldChange",
  "lfcSE",
  "stat",
  "pvalue",
  "padj"
)]

# Sort by adjusted p-value
final_df <- final_df[order(final_df$padj), ]

# Export full results
write.xlsx(final_df,
           file = "DESeq2_annotated_results.xlsx",
           rowNames = FALSE)

# check the sample clustering by PCA Plot
vsd <- vst(dds, blind = FALSE)

pcaData <- plotPCA(vsd, 
                   intgroup="condition", 
                   ntop=5000, 
                   returnData=TRUE
                   )
percentVar <- round(100 * attr(pcaData, "percentVar"))

p <- ggplot(pcaData, aes(PC1, PC2, color=condition, label=name)) +
  geom_point(size=4) +
  geom_text(vjust=-1, size=3) +
  xlab(paste0("PC1: ", percentVar[1], "% variance")) +
  ylab(paste0("PC2: ", percentVar[2], "% variance")) +
  coord_cartesian(xlim=c(-50,50), ylim=c(-20,20)) +
  theme_bw() +
  theme(text = element_text(size=14))

ggsave("C_elegans_treated_vs_Control_PCA.svg", plot=p, width=15, height=9.5)
























