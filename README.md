# Weather-Control-by-InitCond
Sensitivity analysis and initial condition perturbation for controlling accumulated precipitation

## Overview 

This repository shares Matlab M files for sensitivity analysis, optimization of initial condition perturbation, and validation for controlling accumulated precipitation in a numerical weather prediction model, SCALE-RM. 

The user runs the following M files in sequence. 
- initsettings.m : Configures initial settings. In particular, the user needs to specify the directory of the SCALE-RM binary file and the command to run SCALE-RM, which depend on the environment. Settings are saved to dvarsettings.mat. 
- perturball.m : Perturbs the initial condition at each grid, runs SCALE-RM, and saves time histories. 
- computeStensor.m : Reads all of the perturbed histories and computes the sensitivity tensor. The sensitivity tensor is saved to StensorPREC.mat. 
- optiminit.m : Reads the sensitivity tensor, solves a minimum norm problem to determine the perturbations in the initial conditions to achieve desired perturbations in the accumulated precipitation, runs SCALE-RM with the perturbed initial conditions, and plots the accumulated precipitation. The optimal perturbations are saved to dvarans.mat. The user needs to specify the reference accumulated precipitation, constraints, and the solver.
- plot2cases.m : Plots optimal perturbations determined by $\ell_2$ and $\ell_1$ norm minimization problems and corresponding accumulated precipitation. 

The following M files define utility functions. 
 - copycdf.m : Copies a set of netCDF data
 - getcdfinfo.m : Gets information of netCDF data
 - ncreadinit.m : Reads netCDF init data files and combines them into an array
 - ncreadhist.m : Reads netCDF history data files and combines them into an array
 - minL1lin_rev.m : Solves a constrained $\ell_1$ norm minimization problem

The following files are needed to run SCALE-RM. 
 - run_R20kmDX500m.conf : Configuration file for the warm bubble experiment
 - init_00000101-000000.000_org.pe000000.nc, init_00000101-000000.000_org.pe000001.nc : Nominal initial conditions for the warm bubble experiment (1 process in $x$ direction and 2 processes in $y$ direction)
 - history_org.pe000000.nc, history_org.pe000001.nc : Nominal history files for the warm bubble experiment

SCALE-RM is a regional atmospheric model using the SCALE library. For details on SCALE and SCALE-RM, refer to the [SCLAE home page](https://scale.riken.jp/) or [GitHub](https://github.com/scale-met/scale). The M files in this repository are developed with SCALE Ver. 5.4.5. The users guide of SCALE Ver. 5.4.5 is available [here](https://scale.riken.jp/archives/scale_users_guide_En.v5.4.5.pdf). 

The following M files can be used for checking a history of SCALE-RM.
 - plothistPREC.m : Plots history of precipitation intensity and accumulated precipitation
 - plothistvideo.m : Generates a video of contour plots of a variable

## Requirement
 - Matlab 2023a with Optimization Toolbox
 - SCALE-RM Ver. 5.4.5 (Warm Bubble Experiment in Section 3.1 of SCALE Users Guide)

## Setup
```
git clone https://github.com/ohtsukalab/Weather-Control-by-InitCond --recursive
```

## License
MIT

## Contribution
This repository is developed by Toshiyuki Ohtsuka, Graduate School of Informatics, Kyoto University. 

## Acknowledgment
This work was supported by JST Moonshot R\&D Program Grant Number JPMJMS2389-1-1.
