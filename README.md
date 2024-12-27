# Comprehensive Installation Guide for CAMx and Supporting Software

This documentation outlines the step-by-step process for setting up CAMx (Comprehensive Air Quality Model with Extensions) and its supporting software: wrfcamx, mozart2camx, TUV, and o3map.

Link to the Documentation [(Link)](https://docs.google.com/document/d/18LjrqF9l3puvmGLK7n18_vU0Ozy5BMmVmj8eRSPRduE/edit?tab=t.0)

## 1. Prerequisites

Before proceeding with the installations, ensure the following are available on your system:

### System Requirements
- **Docker**

    Steps to set up docker 
    ```bash
        docker pull rutwik1440/wrfcamx:latest
        docker run -it rutwik1440/wrfcamx:latest /bin/bash
    ```
    
This will start a new container and open an interactive shell (/bin/bash).
## 2. CAMx Installation

### Step 1: Download CAMx Source Code
1. Visit the official CAMx website: [https://camx.com](https://camx.com).
2. Download the latest release of CAMx.
3. Extract the downloaded archive:
4. docker pull rutwik1440/wrfcamx:latest
    docker run -it rutwik1440/wrfcamx:latest /bin/bash

    ```bash
    tar -xzvf camx_vX.X.tar.gz
    cd camx_vX.X
    ```

## 3. wrfcamx Installation

### Step 1: Clone wrfcamx Repository
1. Download wrfcamx from [https://www.camx.com/download/support-software/](https://www.camx.com/download/support-software/).
2. Extract the files:

    ```bash
    wrfcamx_v5.2.10Jan22.tgz
    tar -xzvf wrfcamx_v5.2
    cd wrfcamx/src
    ```

### Step 2: Build wrfcamx
1. Modify the `Makefile` to match your environment settings for NetCDF, MPI, and compilers.
2. Build the wrfcamx executable:

    ```bash
    make
    cd ..
    ```

3. Make necessary changes in the job script, setting input and output file paths:

    ```bash
    ./run_job_script
    ```

## 4. mozart2camx Installation

### Step 1: Download mozart2camx
1. Download mozart2camx from [https://www.camx.com/download/support-software/](https://www.camx.com/download/support-software/).
2. Extract the files:

    ```bash
    mozart2camx.26mar24.tgz
    tar -xzvf mozart2camx_v4.2
    cd mozart2camx_v4.2/src
    ```

### Step 2: Build mozart2camx
1. Update the `Makefile` to include the correct NetCDF paths.
2. Compile the software:

    ```bash
    make
    cd ..
    ```

3. Make necessary changes in the job script, setting input and output file paths:

    ```bash
    ./run_job_script
    ```

## 5. TUV Installation

### Step 1: Download TUV Source Code
1. Download TUV from [https://www.camx.com/download/support-software/](https://www.camx.com/download/support-software/).
2. Extract the files:

    ```bash
    tuv4.8.camx7.30.24jun24.tgz
    tar -xzvf tuv4.8.camx7.30.24jun24.tgz
    cd tuv4.8.camx7.30/src
    ```

### Step 2: Configure and Build
1. Update environment variables for compilers and libraries.
2. Compile TUV:

    ```bash
    make
    cd ..
    ```

3. Make necessary changes in the job script, setting input and output file paths:

    ```bash
    ./run_job_script
    ```

## 6. o3map Installation

### Step 1: Download o3map
1. Download o3map from [https://www.camx.com/download/support-software/](https://www.camx.com/download/support-software/).
2. Extract the files:

    ```bash
    o3map.31may20.tgz
    tar -xzvf o3map
    cd o3map/src
    ```

### Step 2: Build o3map
1. Set the environment variables for NetCDF and compilers.
2. Compile the software:

    ```bash
    make
    cd ..
    ```

3. Make necessary changes in the job script, setting input and output file paths:

    ```bash
    ./run_job_script
    ```

