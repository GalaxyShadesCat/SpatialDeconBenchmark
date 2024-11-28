# Install packages
library(devtools)
options(repos = c(CRAN = "https://cloud.r-project.org"))
options(timeout = 600000000)

install.packages("hdf5r")
install.packages("Seurat")
install.packages("Matrix")
install.packages("dplyr")
install.packages("ggplot2")

devtools::install_github("dmcable/spacexr")
devtools::install_github("ZxZhou4150/Redeconve", build_vignettes = FALSE)