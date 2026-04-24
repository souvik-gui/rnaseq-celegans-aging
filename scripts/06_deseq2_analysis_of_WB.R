# Installing Bioconductor Manager
install.packages("BiocManager")

# Installing required Bioconductor packages
BiocManager::install(c("DESeq2", "rtracklayer"))

# Installing standard CRAN packages
install.packages(c(
  "openxlsx",
  "ggplot2",
  "ggrepel",
  "dplyr",
  "pheatmap",
  "RColorBrewer"
))

library(DESeq2)
library(rtracklayer)
library(openxlsx)
library(ggplot2)
library(ggrepel)
library(dplyr)
library(pheatmap)
library(RColorBrewer)

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
               lfcThreshold = 0.1,
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

######## Volcano Plot #########

# Clean data
volcano_df <- final_df %>%
  filter(!is.na(padj), !is.na(log2FoldChange))

# Transform p-values
volcano_df$log10padj <- -log10(volcano_df$padj)

# Fix gene names
volcano_df$gene_name[is.na(volcano_df$gene_name)] <- volcano_df$gene_id

# Define groups (threshold = 0.1)
volcano_df$group <- "NotSig"

volcano_df$group[
  volcano_df$log2FoldChange >= 0.1 & volcano_df$padj < 0.05
] <- "Up"

volcano_df$group[
  volcano_df$log2FoldChange <= -0.1 & volcano_df$padj < 0.05
] <- "Down"

# Ranking score
volcano_df$score <- abs(volcano_df$log2FoldChange) * volcano_df$log10padj

# CAP extreme values (DO THIS BEFORE SUBSETTING)
cap_value <- 30

volcano_df$log10padj_capped <- pmin(volcano_df$log10padj, cap_value)

# Mark capped points
volcano_df$is_capped <- volcano_df$log10padj > cap_value

# Top 20 Up genes
top_up <- volcano_df %>%
  filter(group == "Up") %>%
  arrange(desc(score)) %>%
  head(20)

# Top 20 Down genes
top_down <- volcano_df %>%
  filter(group == "Down") %>%
  arrange(desc(score)) %>%
  head(20)

# Combine labels (NOW it already has capped values)
label_genes <- bind_rows(top_up, top_down)

# Plot
q <- ggplot(volcano_df, aes(x = log2FoldChange, y = log10padj_capped)) +
  
  # Base points
  geom_point(color = "grey80", size = 1.5, alpha = 0.6) +
  
  # Significant points
  geom_point(
    data = subset(volcano_df, group != "NotSig"),
    aes(color = group),
    size = 2.5
  ) +
  
  # Capped points (triangle)
  geom_point(
    data = subset(volcano_df, is_capped),
    shape = 17,
    size = 3,
    color = "black"
  ) +
  
  # Colors
  scale_color_manual(values = c(
    "Up" = "#2ca25f",
    "Down" = "#de2d26"
  )) +
  
  # Threshold lines
  geom_vline(xintercept = c(-0.1, 0.1), linetype = "dashed") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed") +
  
  # Labels (FIXED)
  geom_text_repel(
    data = label_genes,
    aes(x = log2FoldChange, y = log10padj_capped, label = gene_name),
    size = 4,
    box.padding = 0.4,
    point.padding = 0.3,
    segment.color = "black",
    max.overlaps = Inf,
    fontface = "italic"
  ) +
  
  # Axis limits
  xlim(
    min(volcano_df$log2FoldChange) - 0.5,
    max(volcano_df$log2FoldChange) + 0.5
  ) +
  
  ylim(0, cap_value) +
  
  # Annotation
  annotate(
    "text",
    x = max(volcano_df$log2FoldChange),
    y = cap_value - 2,
    label = paste0("Capped at -log10(padj) = ", cap_value),
    hjust = 1,
    size = 4
  ) +
  
  # Theme
  theme_classic(base_size = 14) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold")
  ) +
  
  labs(
    title = "Volcano Plot: UA vs Control",
    x = "Log2 Fold Change",
    y = "-log10 Adjusted P-value"
  )

# Save plot
ggsave("volcano_plot_publication.svg", plot = q, width = 12, height = 8)








