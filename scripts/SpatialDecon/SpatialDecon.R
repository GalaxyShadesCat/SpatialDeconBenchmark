### Run SpatialDecon ###
options(repos = c(CRAN = "https://cloud.r-project.org"))
if (!requireNamespace("Seurat", quietly = TRUE)) {
    install.packages("Seurat")
}

library(dplyr)
library(SpatialDecon)
library(Seurat)
library(SeuratObject)
library(Matrix)

# get method from command line 
args <- commandArgs(trailingOnly = TRUE)
method <- args[1]

# Set paths for input and output
current_working_directory <- getwd()

# Set paths for input and output using the current working directory
input_path <- paste0(current_working_directory, "/data/", method, "/")
output_path <- paste0(current_working_directory, "/results/methods/", method, "/")

# Read in data
data <- readRDS(paste0(input_path, "filtered_data.rds"))

# Preprocess and normalize ST data
preprocess=function(data){
  st_counts_norm = sweep(data$st_counts, 2, colSums(data$st_counts), "/") * mean(colSums(data$st_counts)) # normalization
  st_object=CreateSeuratObject(counts=st_counts_norm,assay="Spatial")
  stopifnot(setequal(colnames(st_object),rownames(data$st_location)))
  st_object=AddMetaData(st_object,data$st_locations[colnames(st_object),1],col.name="x")
  st_object=AddMetaData(st_object,data$st_locations[colnames(st_object),2],col.name="y")
  
  stopifnot(all(colnames(data$sc_counts)==rownames(data$sc_labels)))
  
  sc_counts_matrix=as.matrix(data$sc_counts)
  sc_counts_matrix=Matrix::Matrix((sc_counts_matrix),sparse=TRUE)
  sc_labels_df=data.frame(cell_barcodes=names(data$sc_labels),sc_labels=data$sc_labels)
  sc_matrix <- create_profile_matrix(
    mtx = sc_counts_matrix,            # cell x gene count matrix
    cellAnnots = sc_labels_df,  # cell annotations with cell type and cell name as columns 
    cellTypeCol = "sc_labels",  # column containing cell type
    cellNameCol = "cell_barcodes",           # column containing cell ID/name
    matrixName = "custom_cell_type_matrix", # name of final profile matrix
    outDir = NULL,                    # path to desired output directory, set to NULL if matrix should not be written
    normalize = TRUE,                # Should data be normalized? 
    minCellNum = 1,
    minGenes = 1
  ) 
  
  return(
    list(
      st_object=st_object,
      sc_matrix=sc_matrix
    )
  )
}


out_matrix_norm_fp=file.path(output_path,paste0(method,"_SpatialDecon.csv"))

processed_data=preprocess(data)

print("Start running SpatialDecon...")
start_time <- Sys.time()
res = runspatialdecon(object = processed_data$st_object,
                       bg = 0.01,
                       X = visium_processed_data$sc_matrix,
                       align_genes = TRUE)

end_time <- Sys.time()
run_time <- as.numeric(difftime(end_time, start_time, units = "secs"))
print("Finished running.")

# write runtime
logfile <- file(paste0(out_path, method, "_runtime.txt"))
writeLines(c("Runtime: ", run_time), logfile)
close(logfile)

# write deconvolution results
weights=t(visium_res$beta)
norm_weights=sweep(weights, 1, rowSums(weights), "/")
write.csv(as.matrix(norm_weights),out_matrix_norm_fp)
