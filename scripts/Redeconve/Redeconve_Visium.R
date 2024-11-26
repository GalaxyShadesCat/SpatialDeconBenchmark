library(Redeconve)

# data loading
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


load_Visium=function(){ # same input format as RCTD
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
out_matrix_norm_fp=file.path(out_dir,sprintf("Visium.Redeconve.norm3.csv")) # output file name

sc_reference=Reference(
  counts=data$sc_counts,
  cell_types= factor(data$sc_labels)
)

# to match colnames(counts) with rownames (coords)
new_col_names = substr(colnames(data$st_counts), 1, nchar(colnames(data$st_counts)) - 2)
colnames(data$st_counts) = new_col_names

st_data=SpatialRNA(
  counts=data$st_counts,
  coords=data$st_location,
  require_int=FALSE
)

sc_reference <- as.matrix(sc_reference@counts)
st_data <- as.matrix(st_data@counts)
promises::promise_resolve(sc_reference)
promises::promise_resolve(st_data)

start_time <- Sys.time()
res <- deconvoluting(sc_reference, st_data, genemode = "def", hpmode = "auto", dopar = T, ncores = 8, dir = out_matrix_norm_fp) 
# dopar = do parallel processing, mode of determining hyperparameter = auto (time-consuming, use customized after finding hyperparameter)

end_time <- Sys.time()

sc_labels_df <- data.frame(sc_labels)
column_names_df <- as.data.frame(t(colnames(sc_counts)))
sc_labels_combined <- t(rbind(column_names_df, as.data.frame(t(sc_labels))))

res.ctmerge <- sc2type(res, sc_labels_combined) # convert deconvolution result to cell type data  
print(end_time-start_time)

res.prop <- to.proportion(res.ctmerge) # convert deconvolution result to cell type ratios
write.csv(t(as.matrix(res.prop)),out_matrix_norm_fp)