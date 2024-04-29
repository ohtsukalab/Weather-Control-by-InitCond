# Precipitation-Regulation
Sensitivity analysis and initial condition perturbation for regulating cumulative precipitation

This repository shares Matlab M files for sensitivity analysis, optimization of initial condition perturbation, and validation for regulating cumulative precipitation in a numerical weather prediction model, SCALE-RM. The user runs the following M files in order. 
- initsettings.m : Initial settings; In particular, the user needs to specify the directory of the scale-rm binary and the command to run scale-rm, which depend on the environment. Settings are saved to dvarsettings.mat. 
- perturball.m : Perturbs the initial condition at each grid, runs scale-rm, ans saves the hisotry. 
- computeStensor.m : Reads all of the perturbed histories and computes the sensitivity tensor. The sensitivity tensor is saved to StensorPREC.mat. 
- optiminit.m : Reads the sensitivity matrix, solves a minimum norm problem to determine the perturbations in the initial condtions to achieve desired perturbations in the cumulative precipitation, runs scale-rm with the perturbed initial conditions, and plots the cumulative precipitation. The optimal perturbations are saved to dvarans.mat. The user needs to speficy the reference precipitation, constraints, and the solver. 

