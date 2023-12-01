
# Explaining Agent-based Modeling Outputs Using Subgroup Discovery: A Case Study in Marketing

## Overview

This repository contains the necessary resources for the experimental part of the paper "Explaining Agent-based Modeling Outputs Using Subgroup Discovery: A Case Study in Marketing", including data, preprocessing scripts in R, and Java Archive (JAR) files for subgroup discovery algorithms. Convenient shell scripts are provided to facilitate the execution process.

## Repository Structure

-   **data**: This directory holds the dataset used for the experiments, provided by the company Zio.
-   **preprocessing**: R scripts for data preprocessing.
-   **SDMap**: JAR file and parameter settings for SDMap algorithm.
-   **NMEEFSDR**: JAR file and parameter settings for NMEEFSDR algorithm.
-   **FuGePSD**: JAR file and parameter settings for FuGePSD algorithm.

## Usage

### Data Preprocessing

Prepare the data for subgroup discovery algorithms by employing the R scripts found in the `preprocessing_scripts` directory. These scripts manage event selection, brand filtering, class construction, and discretization.

**Execution:** Streamline the execution of data preprocessing with the `run_preprocessing.sh` script. This script is configured to conduct all four experiments with their respective settings, as comprehensively detailed in our paper. Alternatively, users can employ the R script `./preprocessing/main_preprocessing.R` with customized settings.

**Output:** After successful execution, the preprocessed data in ARFF will be available in the path `./data/in`.

**Requirements:** Ensure that you have R installed on your system before running the preprocessing scripts.

### Subgroup Discovery Algorithms

Before applying subgroup discovery algorithms, ensure that your data adheres to the Attribute-Relation File Format (ARFF). The repository includes the following subgroup discovery algorithms: SDMap, FuGePSD, and NMEEFSDR.

**Execution:** Streamline the execution of each algorithm with their respective `run_[algorithm].sh` script. These scripts are configured to conduct all four experiments with their corresponding configurations. Users can customize the execution settings by modifying the parameter files located in the `./[Algorithm]/param` directory.

**Output:** After successful execution, the output for each algorithm will be available in the path `./data/output/output_[algorithm]`.

**Requirements:** Ensure that Java is installed on your system.\

For more detailed information on the implementation of the subgroup discovery algorithms, you can consult [KEEL](http://www.keel.es)

## Acknowledgments

We would like to express our gratitude to [Zio](https://www.zio-analytics.com/) for providing the dataset used in this research.

## Citation

If you use the resources in this repository, please cite this paper as:

``` bibtex
@article{Romero_ExplainingABM,
author = {E. Romero and C. J. Carmona and O. Cord{\'o}n and M. J. del Jesus and S. Damas and  M. Chica},
title = {Explaining Agent-based Modeling Outputs Using Subgroup Discovery: A Case Study in Marketing},
note = {Submited to Applied Soft Computing}}
```
