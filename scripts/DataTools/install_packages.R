# Install packages from GitHub
library(devtools)

options(timeout = 600000000)
devtools::install_github("dmcable/spacexr")
devtools::install_github("ZxZhou4150/Redeconve", build_vignettes = FALSE)