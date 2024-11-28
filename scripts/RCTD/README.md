# RCTD (spacexr)
## Environment Setup
Create an R 4.4.2 conda environment and install `devtools`
```
conda create -n RCTD r-base=4.4.2 r-devtools
```
Use `devtools` to install spacexr and Redeconve
```
devtools::install_github("dmcable/spacexr", build_vignettes = FALSE)
devtools::install_github("ZxZhou4150/Redeconve", build_vignettes = FALSE)
```
## Run Example
```
Rscript RCTD_seqFISH+.R
Rscript RCTD_Visium.R
```
This will run RCTD (spacexr) and Redeconve on the seqFISH dataset. Output will be stored in `results/seqFISH/`.
