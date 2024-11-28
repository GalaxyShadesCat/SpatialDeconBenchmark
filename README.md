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
```

### Step 2: Install R Packages
```bash
conda activate r-env
Rscript scripts/DataTools/install_packages.R
```

# Prepare seqFISH+ Dataset

```bash
conda activate metrics-env
jupyter execute scripts/DataTools/seqFISH.ipynb
```

# Download and Clean Visium Dataset

```bash
conda activate r-env
bash scripts/DataTools/download_visium.sh
RScript scripts/DataTools/clean_visium.R
```

# Run Spatial Deconvolution Methods

## RCTD
```bash
conda activate r-env
RScript scripts/RCTD/RCTD_seqFISH.ipynb
RScript scripts/RCTD/RCTD_Visium.ipynb
```

## Redeconve
```bash
conda activate r-env
RScript scripts/Redeconve/Redeconve_seqFISH.ipynb
RScript scripts/Redeconve/Redeconve_Visium.ipynb
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

| Task                                                    | Contributor |
|---------------------------------------------------------|-------------|
| Creation of GitHub Repository & Programming Environment | Lem         |
| Prepare seqFISH+ Data for Benchmarking                  | Lem         |
| Filter and Clean Visium Data                            | Vanessa     |