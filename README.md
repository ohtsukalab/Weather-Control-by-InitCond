# Precipitation-Regulation
Sensitivity analysis and initial condition perturbation for regulating cumulative precipitation

This repository shares Matlab M files for sensitivity analysis, optimization of initial condition perturbation, and validation for regulating cumulative precipitation in a numerical weather prediction model, SCALE-RM. The user run the following M files in order. 
- initsettings.m : Initial settings; In particular, you need to set the directory of your scale-rm binary and the command to run scale-rm on your environment. Settings are saved to dvarsettings.mat. 
- perturball.m : Perturbs the initial condition at each grid, run scale-rm, ans save the hisotry. 
- computeStensor.m :
- optiminit.m :

