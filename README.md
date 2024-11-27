# SpatialDeconBenchmark

This repository hosts resources for a benchmark study on spatial transcriptomics deconvolution, assessing various computational methods to deconvolve mixed cell-type spots in complex tissues.

# Setup Development Environment

For detailed instructions on setting up your development environment, please refer to
our [setup guide](docs/setup-development-environment.md).

**Important:** Before executing any subsequent commands, ensure that you are in the project's root directory and have
activated the necessary Conda environment. Failing to do so may result in commands not working as expected.

To activate the environment, use the following command:

```bash
conda activate spatial-deconv
```

# Prepare seqFISH+ Dataset

```bash
jupyter nbconvert --to notebook --execute --inplace notebooks/seqFISH.ipynb
```

# Download and Clean Visium Dataset

```bash
bash scripts/Visium/download_visium.sh
RScript scripts/Visium/clean_visium.R
```

# Credits

| Task                                                    | Contributor |
|---------------------------------------------------------|-------------|
| Creation of GitHub Repository & Programming Environment | Lem         |
| Prepare seqFISH+ Data for Benchmarking                  | Lem         |
| Filter and Clean Visium Data                            | Vanessa     |