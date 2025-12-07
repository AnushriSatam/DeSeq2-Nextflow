library(DESeq2)
library(dplyr)
#It returns a list of everything after the script name
args <- commandArgs(trailingOnly = TRUE)
# args[1] -> count matrix file
# args[2] -> metadata file
counts_file <- args[1]
meta_file <- args[2]
count<-read.csv(counts_file,row.names=1,check.names=FALSE)
metadata <- read.csv(meta_file,row.names=1)

if(!all(colnames(counts) == rownames(metadata))) {
  stop("Sample names in counts and metadata do not match!")
}

dds <- DESeqDataSetFromMatrix(countData = count,
                              colData = metadata,
                              design = ~ condition)
dds <- DESeq(dds)
res <- results(dds,contrast=c("condition","PCOS","Control"))
res_df <- as.data.frame(res)
res_df <-na.omit(res_df)
res_df$padj <-sort(res_df$padj,decreasing = FALSE)
res_df <- res_df %>%
  filter(res_df$padj<0.05)
write.csv(res_df,'deseq2_results.csv')
