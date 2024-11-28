# RCTD (spacexr)
## Environment Setup
Create an R 4.4.2 conda environment and install `devtools`
```
conda create -n RCTD r-base=4.4.2 r-devtools
```
Use `devtools` to install spacexr
```
devtools::install_github("dmcable/spacexr", build_vignettes = FALSE)
```
## Run Example
```
Rscript RCTD_seqFISH+.R
Rscript RCTD_Visium.R
```
This will run RCTD (spacexr) on the seqFISH and Visium dataset. Output will be stored in `results/seqFISH/seqFISH_RCTD.csv`.
