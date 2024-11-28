### process visium data from celltolocation paper ###
library(dplyr)
library(SpatialDecon)
library(Seurat)
library(SeuratObject)
library(Matrix)

#write.csv(visium_paired_sc_labels_df, "/Users/vanessayu/biof3001/dataset/visium/filtered_sc_annotations_updated.csv")
#write.csv(visium_paired_sc_counts, "/Users/vanessayu/biof3001/dataset/visium/filtered_sc_counts.csv")
#write.csv(visium_st_locations, "/Users/vanessayu/biof3001/dataset/visium/filtered_st_locations.csv")
#write.csv(visium_st_counts, "/Users/vanessayu/biof3001/dataset/visium/filtered_st_counts.csv")


visium_data <- list(
  st_counts=visium_st_counts,
  st_locations=visium_st_locations,
  sc_counts=visium_paired_sc_counts,
  sc_labels=visium_paired_sc_labels
)

preprocess=function(data){
  st_counts_norm = sweep(data$st_counts, 2, colSums(data$st_counts), "/") * mean(colSums(data$st_counts)) # normalization
  st_object=CreateSeuratObject(counts=st_counts_norm,assay="Spatial")
  stopifnot(setequal(colnames(st_object),rownames(data$st_location)))
  st_object=AddMetaData(st_object,data$st_locations[colnames(st_object),1],col.name="x")
  st_object=AddMetaData(st_object,data$st_locations[colnames(st_object),2],col.name="y")
  
  stopifnot(all(colnames(data$sc_counts)==names(data$sc_labels)))
  
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

setwd("/Users/vanessayu/biof3001/dataset/visium")
out_dir="./SpatialDecon_results/correctly_paired_1127"
dir.create(out_dir,recursive = TRUE, showWarnings = FALSE)
out_matrix_norm_fp=file.path(out_dir,sprintf("Visium_SpatialDecon.csv"))

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
logfile <- file(paste0(out_dir, "/runtime.txt"))
writeLines(c("Runtime: ", run_time), logfile)
close(logfile)

weights=t(visium_res$beta)
norm_weights=sweep(weights, 1, rowSums(weights), "/")
write.csv(as.matrix(norm_weights),out_matrix_norm_fp)