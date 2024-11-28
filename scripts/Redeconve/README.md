# Redeconve
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
Rscript Redeconve_seqFISH+.R
Rscript Redeconve_Visium.R
```
This will run Redeconve on the seqFISH and Visium datasets. Output will be stored in `results`.
