library(spacexr)
library(Matrix)
library(readxl)
library(dplyr)
setwd('C:/Users/Vincent Yeung/Desktop/School/BIOF3001/Project/STdeconv_benchmark/methods/RCTD/')

# data loading
load_Visium=function(){ 
    st_counts_fp=("C:/Users/Vincent Yeung/Desktop/School/BIOF3001/Project/STdeconv_benchmark/methods/datasets/Visium/filtered_st_counts.csv")
    st_locations_fp="C:/Users/Vincent Yeung/Desktop/School/BIOF3001/Project/STdeconv_benchmark/methods/datasets/Visium/filtered_st_locations.csv"
    sc_counts_fp="C:/Users/Vincent Yeung/Desktop/School/BIOF3001/Project/STdeconv_benchmark/methods/datasets/Visium/filtered_sc_counts.csv"
    sc_labels_fp="C:/Users/Vincent Yeung/Desktop/School/BIOF3001/Project/STdeconv_benchmark/methods/datasets/Visium/filtered_sc_annotations.txt"
    
    st_counts=read.csv(st_counts_fp,sep=",",row.names=1)
    st_locations=read.csv(st_locations_fp,sep = ",",row.name = 1)
    new_row_names = substr(rownames(st_locations), 1, nchar(rownames(st_locations)) - 2)
    rownames(st_locations) = new_row_names
    st_locations=st_locations[,c("x","y")]
    
    sc_counts=read.csv(sc_counts_fp,row.names=1)
    new_col_names = gsub(".*_(.*)", "\\1", colnames(sc_counts))
    new_col_names = substr(new_col_names, 1, nchar(new_col_names) - 2)
    colnames(sc_counts) = new_col_names
    sc_labels=read.csv(sc_labels_fp,header=FALSE)$V1
    names(sc_labels)=colnames(sc_counts)
    
    ret_list=list(
            st_counts=st_counts,
            st_locations=st_locations,
            sc_counts=sc_counts,
            sc_labels=sc_labels
    )
    return(ret_list)
}

data = load_Visium()
out_dir="../Vdata" # output directory
dir.create(out_dir,recursive = TRUE, showWarnings = FALSE)
out_matrix_norm_fp=file.path(out_dir,sprintf("Visium.RCTD.norm.csv")) # output file name

sc_reference=Reference(
    counts=data$sc_counts,
    cell_types = factor(data$sc_labels)
)

# to match colnames(counts) with rownames (coords)
new_col_names = substr(colnames(data$st_counts), 1, nchar(colnames(data$st_counts)) - 2)
colnames(data$st_counts) = new_col_names

st_data=SpatialRNA(
    counts=data$st_counts,
    coords=data$st_locations,
    require_int=FALSE
)

start_time <- Sys.time()

myRCTD <- create.RCTD(st_data, sc_reference, max_cores = 8, CELL_MIN_INSTANCE = 1) # minimum number of instances for each cell type = 1
myRCTD <- run.RCTD(myRCTD, doublet_mode = 'full') # full mode

end_time <- Sys.time()

weights=myRCTD@results$weights
norm_weights=normalize_weights(weights) # # get cell type ratios
print(end_time-start_time)

write.csv(as.matrix(norm_weights),out_matrix_norm_fp)