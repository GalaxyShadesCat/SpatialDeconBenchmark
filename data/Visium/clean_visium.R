### process visium data from celltolocation paper ###
library(dplyr)
library(Seurat)
library(Matrix)

### Visium data ###
setwd("/Users/vanessayu/biof3001/dataset/visium/visium_correct")

# read in single cell rna count matrix downloaded from source 
visium_paired_sc_counts <- Read10X_h5("5705STDY8058280_filtered_feature_bc_matrix.h5")
colnames(visium_paired_sc_counts) <- sapply(colnames(visium_paired_sc_counts), function(x){return(paste0("5705STDY8058280_", x))}) # convert labels to match with cell annotation file

# read in single cell rna cell annotation file
visium_paired_sc_labels_df <- read.csv("cell_annotation.csv") 
visium_paired_sc_labels_df <- visium_paired_sc_labels_df %>%
  filter(sample == "5705STDY8058280") # filter for single sample 5705STDY8058280 replicate1 for female mice

# re-group ambiguous cell type annotations i.e. subclusters with arbitrary numeric labels
split_and_regroup <- function(input_vector, separator = "_") {
  # Process each element in the input vector
  result <- lapply(input_vector, function(item) {
    # Split the item by the separator
    parts <- strsplit(item, separator)[[1]]
    
    # Check if the last part is an integer
    if (grepl("^\\d+$", parts[length(parts)])) {
      # If the last part is an integer, regroup previous parts and include the number
      paste(parts[-length(parts)], collapse = separator)
    } else {
      # If the last part is not an integer, regroup the entire vector
      paste(parts, collapse = separator)
    }
  })
  
  # Convert the list back into a character vector
  unlist(result)
}

visium_paired_sc_labels_df$annotation_benchmark <- split_and_regroup(visium_paired_sc_labels_df$annotation_1)
visium_paired_sc_labels <- visium_paired_sc_labels_df$annotation_benchmark 
names(visium_paired_sc_labels) <- visium_paired_sc_labels_df$Cell.ID # create named vector for cell labels

# match barcodes of the cell annotation file and scrna count matrix 
sc_barcodes_match <- intersect(names(visium_paired_sc_labels), colnames(visium_paired_sc_counts))
visium_paired_sc_counts <- visium_paired_sc_counts[, sc_barcodes_match]
visium_paired_sc_labels[sc_barcodes_match]

# read in spatial rna count and coordinate data downloaded from source
visium_st_counts <- Read10X_h5("ST8059048_filtered_feature_bc_matrix.h5") # paired replicate data
visium_st_locations <- read.csv("./spatial/tissue_positions_list.csv", header = FALSE, row.names = 1)
visium_st_locations <- visium_st_locations[, c(4, 5)]
colnames(visium_st_locations) <- c("x", "y")

# match barcodes of location and spatial rna count matrix
st_barcodes_match <- intersect(rownames(visium_st_locations), colnames(visium_st_counts))
visium_st_locations <- visium_st_locations[st_barcodes_match, ]
visium_st_counts <- visium_st_counts[, st_barcodes_match]

# create structured object for R-based tools
visium_data <- list(
  st_counts=visium_st_counts,
  st_locations=visium_st_locations,
  sc_counts=visium_paired_sc_counts,
  sc_labels=visium_paired_sc_labels
)

# output filtered data as csv files and visium data as RDS
write.csv(visium_paired_sc_labels_df, "./filtered_sc_annotations.csv")
write.csv(visium_paired_sc_counts, "./filtered_sc_counts.csv")
write.csv(visium_st_locations, "./filtered_st_locations.csv")
write.csv(visium_st_counts, "./filtered_st_counts.csv")
saveRDS(visium_data, "./filtered_data.rds")