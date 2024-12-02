library(spacexr)
library(Redeconve)
current_working_directory <- getwd()
setwd(file.path(current_working_directory, 'scripts'))

# data loading
st_counts_fp="../data/seqFISH/st_counts.csv"
st_locations_fp="../data/seqFISH/st_coords.csv"
sc_counts_fp="../data/seqFISH/raw_data/raw_somatosensory_sc_exp.txt"
sc_labels_fp="../data/seqFISH/raw_data/somatosensory_sc_labels.txt"

st_counts=read.csv(st_counts_fp,sep=",",row.names=1) # row name is global bin id
st_counts=t(st_counts)
st_locations=read.csv(st_locations_fp,sep=",",row.name=1) # row name is global bin id
st_locations=st_locations[,c("x","y")]

sc_counts=read.csv(sc_counts_fp,sep="\t",row.names=1)
sc_labels=read.csv(sc_labels_fp,header=FALSE)$V1


load_seqFISH=function(){ # same input format as RCTD
  names(sc_labels)=colnames(sc_counts)
  ret_list=list(
    st_counts=st_counts,
    st_locations=st_locations,
    sc_counts=sc_counts,
    sc_labels=sc_labels
  )
  return(ret_list)
}

data = load_seqFISH()
out_dir="../results/methods/seqFISH/" # output file path
dir.create(out_dir,recursive = TRUE, showWarnings = FALSE)
out_matrix_norm_fp=file.path(out_dir,sprintf("seqFISH_Redeconve.csv")) # output file name

sc_reference=Reference(
  counts=data$sc_counts,
  cell_types= factor(data$sc_labels)
)

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
#res <- deconvoluting(sc_reference, st_data, genemode = "def", hpmode = "auto", dopar = T, ncores = 8, dir = out_matrix_norm_fp) # before finding hp
res <- deconvoluting(sc_reference, st_data, genemode = "def", hp = 34797,hpmode = "customized", dopar = T, ncores = 8, dir = out_matrix_norm_fp) 
# dopar = do parallel processing, mode of determining hyperparameter = default (time-consuming, use customized after finding hyperparameter)

end_time <- Sys.time()

sc_labels_df <- data.frame(sc_labels)
column_names_df <- as.data.frame(t(colnames(sc_counts)))
sc_labels_combined <- t(rbind(column_names_df, as.data.frame(t(sc_labels))))

res.ctmerge <- sc2type(res, sc_labels_combined) # convert deconvolution result to cell type data  
print(end_time-start_time)
setwd(current_working_directory)

res.prop <- to.proportion(res.ctmerge) # convert deconvolution result to cell type ratios
write.csv(t(as.matrix(res.prop)),out_matrix_norm_fp)
