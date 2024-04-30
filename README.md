# Precipitation-Regulation
Sensitivity analysis and initial condition perturbation for regulating cumulative precipitation

## Overview 

This repository shares Matlab M files for sensitivity analysis, optimization of initial condition perturbation, and validation for regulating cumulative precipitation in a numerical weather prediction model, SCALE-RM. 

The user runs the following M files in order. 
- initsettings.m : Initial settings; In particular, the user needs to specify the directory of the scale-rm binary and the command to run scale-rm, which depend on the environment. Settings are saved to dvarsettings.mat. 
- perturball.m : Perturbs the initial condition at each grid, runs scale-rm, ans saves the hisotry. 
- computeStensor.m : Reads all of the perturbed histories and computes the sensitivity tensor. The sensitivity tensor is saved to StensorPREC.mat. 
- optiminit.m : Reads the sensitivity matrix, solves a minimum norm problem to determine the perturbations in the initial condtions to achieve desired perturbations in the cumulative precipitation, runs scale-rm with the perturbed initial conditions, and plots the cumulative precipitation. The optimal perturbations are saved to dvarans.mat. The user needs to speficy the reference precipitation, constraints, and the solver. 

The following are M files to define utility functions. 
 - copycdf.m : Copies a set of netCDF data
 - getcdfinfo.m : Gets information of netCDF data
 - ncreadinit.m : Reads netCDF init data files and combines them into an array
 - ncreadhist.m : Reads netCDF history data files and combines them into an array
 - minL1lin_rev.m : Solves a constrained L1-norm minimization problem

The following files are needed to run SCALE-RM. 
 - run_R20kmDX500m.conf : Configulation file for the warm bubble experiment
 - init_00000101-000000.000_org.pe000000.nc, init_00000101-000000.000_org.pe000001.nc : Nominal initial conditions for the warm bubble experiment (1 process in x direction and 2 processes in y direction)
 - history_org.pe000000.nc, history_org.pe000001.nc : Nominal history files for the warm bubble experiment

SCALE-RM is a regional atmospheric model using the SCALE library. For details on SCALE and SCALE-RM, refer to the [SCLAE home page](https://scale.riken.jp/) or [GitHub](https://github.com/scale-met/scale). The M files in this repository are developed with SCALE Ver. 5.4.5. The user's guide of SCALE Ver. 5.4.5 is available [here](https://scale.riken.jp/archives/scale_users_guide_En.v5.4.5.pdf). 

## Requirement
 - Matlab with 
 - scale-rm 

## Setup
