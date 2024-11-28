# SpatialDeconBenchmark

This repository hosts resources for a benchmark study on spatial transcriptomics deconvolution, assessing various computational methods to deconvolve mixed cell-type spots in complex tissues.

# Setup Development Environment

For detailed instructions on setting up your development environment, please refer to
our [setup guide](docs/setup-development-environment.md).

**Important:** Before executing any subsequent commands, ensure that you are in the project's root directory and have
activated the necessary Conda environment. Failing to do so may result in commands not working as expected.

To create and activate the environment, use the following command:

```bash
conda env create -f environment.yml
conda activate spatial-deconv
Rscript scripts/DataTools/install_packages.R
```

# Prepare seqFISH+ Dataset

```bash
jupyter execute scripts/DataTools/seqFISH.ipynb
```

# Download and Clean Visium Dataset

```bash
bash scripts/DataTools/download_visium.sh
RScript scripts/DataTools/clean_visium.R
```

# Run Spatial Deconvolution Methods

## Tangram
```bash
jupyter execute scripts/Tangram/Tangram.ipynb
```

# Compare Results

## seqFISH+ Benchmarking Results

```bash
jupyter execute scripts/Metrics/calculate_metrics.ipynb
```

## Visium Benchmarking Results

```bash
jupyter execute scripts/Metrics/calculate_spot_metrics.ipynb
```

# Credits

| Task                                                    | Contributor |
|---------------------------------------------------------|-------------|
| Creation of GitHub Repository & Programming Environment | Lem         |
| Prepare seqFISH+ Data for Benchmarking                  | Lem         |
| Filter and Clean Visium Data                            | Vanessa     |