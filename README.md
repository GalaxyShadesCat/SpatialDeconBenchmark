# SpatialDeconBenchmark

This repository hosts resources for a benchmark study on spatial transcriptomics deconvolution, assessing various computational methods to deconvolve mixed cell-type spots in complex tissues.

## Important Notes

Before proceeding, please ensure the following:
- Ensure that your terminal is open in the project's root directory.
- The necessary Conda environment is activated. Failure to activate the environment before executing commands can lead to unexpected results.

## Setup Development Environment

Follow these steps to create and activate the required Conda environments:

### Step 1: Create Environments

Execute the following commands in your terminal to create the Conda environments from the provided YAML files. These commands need to be run one at a time to ensure each environment is created successfully:

```bash
conda env create -f environments/metrics-env.yml
conda env create -f environments/tangram-env.yml
conda env create -f environments/r-env.yml
conda env create -f environments/spatialdecon-env.yml
```

### Step 2: Install R Packages
```bash
conda activate r-env
Rscript scripts/DataTools/install_packages.R
```

# Process Datasets

## Process seqFISH+ Dataset

```bash
conda activate metrics-env
jupyter execute scripts/DataTools/seqFISH.ipynb
```

## Format seqFISH+ Data for R

```bash
conda activate r-env
RScript scripts/DataTools/seqFISH_to_RDS.R
```

## Download and Clean Visium Dataset

```bash
conda activate r-env
bash scripts/DataTools/download_visium.sh
RScript scripts/DataTools/clean_visium.R
```

# Run Spatial Deconvolution Methods

## RCTD
```bash
conda activate r-env
RScript scripts/RCTD/RCTD_seqFISH+.R
RScript scripts/RCTD/RCTD_Visium.R
```

## Redeconve
```bash
conda activate r-env
RScript scripts/Redeconve/Redeconve_seqFISH+.R
RScript scripts/Redeconve/Redeconve_Visium.R
```

## SpatialDecon

```bash
conda activate spatialdecon-env
RScript scripts/SpatialDecon/SpatialDecon.R SeqFISH
RScript scripts/SpatialDecon/SpatialDecon.R Visium
```

## Tangram
```bash
conda activate tangram-env
jupyter execute scripts/Tangram/Tangram.ipynb
```

# Compare Results

## seqFISH+ Benchmarking Results

```bash
conda activate metrics-env
jupyter execute scripts/Metrics/calculate_metrics.ipynb
```

## Visium Benchmarking Results

```bash
conda activate metrics-env
jupyter execute scripts/Metrics/calculate_spot_metrics.ipynb
```

# Credits

| Task                                                     | Contributor |
|----------------------------------------------------------|-------------|
| Creation of GitHub Repository & Programming Environments | Lem         |
| Preparation of seqFISH+ Data                             | Lem         |
| Preparation of Visium Data                               | Vanessa     |
| Evaluation Metric Calculation (RMSE, JSD, PCC, Moran's I)| Vanessa     |
| Integration of Evaluation Metric Scripts                 | Lem         |
| Method: RCTD                                             | Vincent     |
| Method: Redeconve                                        | Vincent     |
| Method: Tangram                                          | Lem         |
| Method: SpatialDecon                                     | Vanessa     |
| Visium Visualization                                     | Vanessa     |
| seqFISH+ Visualization                                   | Vincent     |
