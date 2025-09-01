library(pheatmap)

# Load data
file_path <- "C:/Users/manis/Downloads/006_stam/lcbs_presence.csv"
data <- read.csv(file_path, row.names = 1)

# Rename columns
clean_colname <- function(x) {
  if (grepl("_spades", x)) {
    num <- gsub(".*?(\\d+)_spades.*", "\\1", x)
    return(paste0("sample_", num))
  } else {
    name <- gsub(".*reference_genomes\\.", "", x)
    name <- gsub("\\.fasta$", "", name)
    return(name)
  }
}
colnames(data) <- sapply(colnames(data), clean_colname)

# ----------------------
# Filter LCBs based on presence frequency
# ----------------------
# Convert to matrix
mat <- as.matrix(data)

# Remove LCBs that are present in fewer than 10% or more than 90% of genomes
presence_rate <- rowMeans(mat)
mat_filtered <- mat[presence_rate > 0.1 & presence_rate < 0.9, ]

cat("Rows after filtering rare/common LCBs:", nrow(mat_filtered), "\n")

# ----------------------
# Plot with fewer clusters using cutree
# ----------------------

pheatmap(mat_filtered,
         cluster_rows = TRUE,
         cluster_cols = TRUE,
         clustering_distance_rows = "binary",
         clustering_distance_cols = "binary",
         clustering_method = "average",
         cutree_cols = 4,   # force 4 column (genome) clusters
         cutree_rows = 6,   # force 6 row (LCB) clusters
         color = c("white", "blue"),
         legend = TRUE,
         show_rownames = FALSE,
         main = "Presence/Absence of LCBs Across Genomes")

