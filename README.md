# SpatialDeconBenchmark
This repository hosts resources for a benchmark study on spatial transcriptomics deconvolution, assessing various computational methods to deconvolve mixed cell-type spots in complex tissues.

# Project Environment Setup

## Overview

This guide will help you set up the necessary Conda environment to run and develop the project. The environment includes
dependencies managed by Conda and pip.

## Prerequisites

- [Anaconda](https://www.anaconda.com/products/individual)
  or [Miniconda](https://docs.conda.io/en/latest/miniconda.html) installed on your machine.

## Setting Up Your Environment

1. **Clone the repository**:
   Start by cloning this repository to your local machine.

    ```bash
    git clone https://github.com/GalaxyShadesCat/SpatialDeconBenchmark.git
    cd SpatialDeconBenchmark
    ```

2. **Create the environment**:
   Use the `environment.yml` file provided in the repository to create an identical Conda environment.

    ```bash
    conda env create -f environment.yml
    ```

   This command will create a new Conda environment that includes all necessary Conda and pip packages.

3. **Activate the environment**:
   Once the environment is successfully created, you can activate it using:

    ```bash
    conda activate spatial-deconv
    ```

4. **Verify the environment**:
   To ensure everything is set up correctly, you can check the installed packages:

    ```bash
    conda list
    ```

## Troubleshooting

- **Issues with the environment creation**: If you encounter errors during the environment creation, make sure that your
  Conda is up to date. Update Conda using:

    ```bash
    conda update conda
    ```

- **Package conflicts**: In case of package conflicts, you may need to resolve specific package versions manually.

## Additional Information

- The environment can be deactivated by running:

    ```bash
    conda deactivate
    ```

# Download Visium Data

Download the data from the following
link: [Visium Data](https://drive.google.com/drive/folders/1axyYEzjwNwqurKqSgOgDwhUTe_iNeqih)
and place it in the `data/Visium/` directory.

# Credits

| Task                                                    | Contributor |
|---------------------------------------------------------|-------------|
| Creation of GitHub Repository & Programming Environment | Lem         |
| Generate Ground Truth for seqFISH+                      | Lem         |
| Filtering and Cleaning Visium Data                      | Vanessa     |