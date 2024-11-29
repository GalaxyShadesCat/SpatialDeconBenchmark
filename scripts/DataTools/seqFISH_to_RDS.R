### Create RDS object from seqFISH+ data ###
# Set paths for input and output
current_working_directory <- getwd()

# Set paths for input and output using the current working directory
path <- paste0(current_working_directory, "/data/seqFISH/")

setwd(path)

# Format seqFISH data in RDS object
sc_counts <- read.csv("sc_counts.csv", row.names=1, header = TRUE)
sc_counts <- t(sc_counts)
sc_labels <- read.csv("sc_labels.csv", header=FALSE)$V1
names(sc_labels) <- colnames(sc_counts)
st_counts <- read.csv("st_counts.csv", header = TRUE, row.names = 1)
st_locations <- read.csv("st_coords.csv", header = TRUE, row.names = 1)

data <- list(
  st_counts=st_counts,
  st_locations=st_locations,
  sc_counts=sc_counts,
  sc_labels=sc_labels
)

saveRDS(data, "filtered_data.rds")
