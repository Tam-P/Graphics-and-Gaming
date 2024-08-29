<!-- Tools & Technology -->

<div align="center">

   ![Python Badge](https://img.shields.io/badge/-Python-3B4252?style=flat&logo=python&logoColor=EBCB8B)
   ![Jupyter Badge](https://img.shields.io/badge/-Jupyter-3B4252?style=flat&logo=jupyter&logoColor=D08770)
   ![Moises Badge](https://img.shields.io/badge/-Moises-3B4252?style=flat&logo=moises&logoColor=8FBCBB)

</div>


## Sound Analysis Notebooks

This repository contains Jupyter notebooks designed for the analysis of sound waves, audio, and music. The notebooks aim to facilitate research and development in Digital Signal Processing (DSP), Music Information Retrieval (MIR), and other sound-related fields. These tools are suitable for AI experts, data scientists, and engineers with a focus on audio signal processing.

### Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Notebooks Overview](#notebooks-overview)
6. [Contributing](#contributing)
7. [License](#license)
8. [References](#references)

## Introduction

The Sound Analysis Notebooks provide a comprehensive suite of tools for analysing various aspects of sound and music. These notebooks cover topics ranging from basic waveform analysis to advanced MIR techniques. The goal is to offer an accessible platform for both educational and professional purposes.


## Prerequisites

Before you begin, ensure you have the following installed on your machine:

- **Python 3.7 or higher**: Required for running the hooks and other project dependencies.
- **Jupyter Notebook**: Necessary for working with `.ipynb` files.
- **Anaconda distribution (Recommended)**: Simplifies package management and deployment.
- **pre-commit**: To enable and run the pre-commit hooks.

### Installation Instructions

1. **Install Python 3.8 or higher, preferably 3.11**:
    - Download and install the latest version of Python from [python.org](https://www.python.org/downloads/).

2. **Install Anaconda (Recommended)**:
    - Download and install Anaconda from [anaconda.com](https://www.anaconda.com/products/distribution#download-section).

3. **Install Jupyter Notebook**:
    - If you have Anaconda installed, Jupyter Notebook is included. If not, install it using pip:
      ```sh
      pip install notebook
      ```

4. **Install pre-commit**:
    - Install pre-commit globally using pip:
      ```sh
      pip install pre-commit
      ```

### Setting Up Pre-commit Hooks

1. **Clone the Repository**:
    ```sh
    git clone <repository_url>
    cd <repository_directory>
    ```

2. **Install the Pre-commit Hooks**:
    - Run the following command to install the pre-commit hooks specified in the `.pre-commit-config.yaml` file:
      ```sh
      pre-commit install
      ```

3. **Run Pre-commit Hooks Manually (Optional)**:
    - To run the pre-commit hooks on all files manually, use:
      ```sh
      pre-commit run --all-files
      ```

### Pre-commit Hooks Configuration

The project is configured to use the following pre-commit hooks:

- **Bandit**: Checks Python code for security issues.
- **Black**: Formats Python code to adhere to PEP 8.
- **End-of-file Fixer**: Ensures files end with a newline.
- **Flake8**: Lints Python code for style and quality.
- **nbstripout**: Strips output from Jupyter Notebooks to keep diffs clean.
- **Pyupgrade**: Upgrades syntax for newer versions of Python.
- **Trailing Whitespace**: Ensures no trailing whitespace.
- **YAML Check**: Checks for valid YAML syntax.


## Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/yourusername/sound-analysis-notebooks.git
    ```

2. Navigate to the project directory:

    ```bash
    cd sound-analysis-notebooks
    ```

3. Create a virtual environment:

    ```bash
    python -m venv venv
    source venv/bin/activate
    ```
    or on Windows:

     ```bash
      python -m venv venv
    source venv\Scripts\activate
    ```

4. Install the required packages:

    ```bash
    pip install -r requirements.yaml
    ```

## Usage

To start using the notebooks:

1. Activate the virtual environment if not already activated:

    ```bash
    source venv/bin/activate  # On Windows, use `venv\Scripts\activate`
    ```
    or on Windows:

     ```bash
    source venv\Scripts\activate
    ```

2. Launch Jupyter Notebook:

    ```bash
    jupyter notebook
    ```

3. Open and run the desired notebook from the Jupyter interface.

## Notebooks Overview

### 1. Time Domain Audio Representations
- **Amplitude Envelope (AE)**: The amplitude envelope is a representation of how the amplitude (or loudness) of an audio signal changes over time. It is derived from the audio waveform by tracking the peaks of the signal's absolute amplitude over short time intervals, creating a smooth curve that outlines the overall shape of the sound. The amplitude envelope is useful in various audio analysis tasks, including identifying the temporal structure of a sound, detecting transient events, and distinguishing between different types of audio signals based on their dynamic characteristics.


## Contributing

We welcome contributions from the community. If you wish to contribute, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature/branch`).
3. Make your changes.
4. Commit your changes (`git commit -m 'Add a feature'`).
5. Push to the branch (`git push origin feature/branch`).
6. Open a pull request.

