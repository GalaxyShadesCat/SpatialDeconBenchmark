library(spacexr)
library(Matrix)
current_working_directory <- getwd()
setwd(file.path(current_working_directory, 'scripts'))
  
# data loading
st_counts_fp="../data/seqFISH/st_counts.csv"
st_locations_fp="../data/seqFISH/st_coords.csv"
sc_counts_fp="../data/seqFISH/raw_somatosensory_sc_exp.txt"
sc_labels_fp="../data/seqFISH/somatosensory_sc_labels.txt"

st_counts=read.csv(st_counts_fp,sep=",",row.names=1) # row name is global bin id
st_counts=t(st_counts)
st_locations=read.csv(st_locations_fp,sep=",",row.name=1) # row name is global bin id
st_locations=st_locations[,c("x","y")]

sc_counts=read.csv(sc_counts_fp,sep="\t",row.names=1)
sc_labels=read.csv(sc_labels_fp,header=FALSE)$V1
names(sc_labels)=colnames(sc_counts)

load_seqFISH=function(){ 
  ret_list=list(
    st_counts=st_counts,
    st_locations=st_locations,
    sc_counts=sc_counts,
    sc_labels=sc_labels
  )
  return(ret_list)
}

data = load_seqFISH()
out_dir="../results/seqFISH/" # output file path
dir.create(out_dir,recursive = TRUE, showWarnings = FALSE)
out_matrix_norm_fp=file.path(out_dir,sprintf("seqFISH_RCTD.csv")) # output file name

sc_reference=Reference(
  counts=data$sc_counts,
  cell_types = factor(data$sc_labels)
)

st_data=SpatialRNA(
  counts=data$st_counts,
  coords=data$st_locations,
  require_int=FALSE
)

start_time <- Sys.time()

myRCTD <- create.RCTD(st_data, sc_reference, max_cores = 8, CELL_MIN_INSTANCE = 1) # minimum number of instances for each cell type = 1
myRCTD <- run.RCTD(myRCTD, doublet_mode = 'doublet') # doublet mode

end_time <- Sys.time()

weights=myRCTD@results$weights
norm_weights=normalize_weights(weights) # get cell type ratios
print(end_time-start_time)

write.csv(as.matrix(norm_weights),out_matrix_norm_fp)
setwd(current_working_directory)
