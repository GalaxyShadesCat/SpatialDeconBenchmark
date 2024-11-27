# Set a CRAN mirror
options(repos = c(CRAN = "https://cloud.r-project.org"))

install.packages("hdf5r")
install.packages("Seurat")

library(dplyr)
library(Matrix)
library(hdf5r)
library(Seurat)

# Set paths for input and output
current_working_directory <- getwd()

# Set paths for input and output using the current working directory
input_path <- paste0(current_working_directory, "/data/Visium/input/")
output_path <- paste0(current_working_directory, "/data/Visium/")

# Read in single-cell RNA count matrix
visium_paired_sc_counts <- Read10X_h5(paste0(input_path, "5705STDY8058280_filtered_feature_bc_matrix.h5"))
colnames(visium_paired_sc_counts) <- sapply(colnames(visium_paired_sc_counts), function(x) {paste0("5705STDY8058280_", x)})

# Read in single-cell RNA cell annotation file
visium_paired_sc_labels_df <- read.csv(paste0(input_path, "cell_annotation.csv"))
visium_paired_sc_labels_df <- visium_paired_sc_labels_df %>%
  filter(sample == "5705STDY8058280")

# Regroup ambiguous cell type annotations
split_and_regroup <- function(input_vector, separator = "_") {
  result <- lapply(input_vector, function(item) {
    parts <- strsplit(item, separator)[[1]]
    if (grepl("^\\d+$", parts[length(parts)])) {
      paste(parts[-length(parts)], collapse = separator)
    } else {
      paste(parts, collapse = separator)
    }
  })
  unlist(result)
}

visium_paired_sc_labels_df$annotation_benchmark <- split_and_regroup(visium_paired_sc_labels_df$annotation_1)
visium_paired_sc_labels <- visium_paired_sc_labels_df$annotation_benchmark
names(visium_paired_sc_labels) <- visium_paired_sc_labels_df$Cell.ID

# Match barcodes between annotation file and scRNA count matrix
sc_barcodes_match <- intersect(names(visium_paired_sc_labels), colnames(visium_paired_sc_counts))
visium_paired_sc_counts <- visium_paired_sc_counts[, sc_barcodes_match]

# Read in spatial RNA count and coordinate data
visium_st_counts <- Read10X_h5(paste0(input_path, "ST8059048_filtered_feature_bc_matrix.h5"))
visium_st_locations <- read.csv(paste0(input_path, "spatial/tissue_positions_list.csv"), header = FALSE, row.names = 1)
visium_st_locations <- visium_st_locations[, c(4, 5)]
colnames(visium_st_locations) <- c("x", "y")

# Match barcodes of location and spatial RNA count matrix
st_barcodes_match <- intersect(rownames(visium_st_locations), colnames(visium_st_counts))
visium_st_locations <- visium_st_locations[st_barcodes_match, ]
visium_st_counts <- visium_st_counts[, st_barcodes_match]

# Create structured object for R-based tools
visium_data <- list(
  st_counts = visium_st_counts,
  st_locations = visium_st_locations,
  sc_counts = visium_paired_sc_counts,
  sc_labels = visium_paired_sc_labels
)

# Output filtered data as CSV files and Visium data as RDS
write.csv(visium_paired_sc_labels_df, paste0(output_path, "filtered_sc_annotations.csv"))
write.csv(visium_paired_sc_counts, paste0(output_path, "filtered_sc_counts.csv"))
write.csv(visium_st_locations, paste0(output_path, "filtered_st_locations.csv"))
write.csv(visium_st_counts, paste0(output_path, "filtered_st_counts.csv"))
saveRDS(visium_data, paste0(output_path, "filtered_data.rds"))