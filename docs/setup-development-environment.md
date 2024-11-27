# Setting up Your Development Environment

To ensure seamless execution of development tools from the project directory, you must configure your system's
environment variables. This documentation covers the addition of Conda, Python, R, Git to your system's PATH.

## Prerequisites

Before proceeding, install the following tools if they are not already installed:

- Conda (typically comes with Anaconda or Miniconda)
- Git

# Conda Environment Setup

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

