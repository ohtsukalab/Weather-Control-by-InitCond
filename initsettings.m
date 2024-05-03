% M-file for Initializing Settings for Sensitivity Analysis and Initial
% Condition Optimization for SCALE-RM
%
% Variables in Initial Conditions
% "DENS", "MOMZ", "MOMX", "MOMY", "RHOT", "QV", "QC", "QR", "QI", "QS", "QG"
% 
% Toshiyuki Ohtsuka, Feb. 2024
clear; 
varname = "RHOT"; % Name of variable to be perturbed
dvar = 0.1;   % Perturbation for RHOT, MOMY, and MOMZ
%dvar = 0.001; % Perturbation for QV
dirbase = "Perturbed"; % Base directory of data files
dirvar  = dirbase+filesep+varname; % Directory for saving settings and perturbed history
settingsdata = dirvar+filesep+"dvarsettings.mat"; % MAT file for saving settings
system("mkdir "+dirvar);

% Init data, history data, and config files in the same directory as this M-file
% Original init and history files have to be generated according to 
% SCALE USERS GUIDE Ver. 5.4.5 Subsec 3.1.2 and renamed to "..._org.pe..." beforehand.
fninitbase_org = "init_00000101-000000.000_org.pe"; % Base name of original init data files
fnhistbase_org = "history_org.pe"; % Base name of original history files
fninitbase = "init_00000101-000000.000.pe"; % Base name of init data files to be modifed
fnconf = "run_R20kmDX500m.conf"; % Configuration file 
fnhistbase = "history.pe"; % Base name of history files
scaledir = "/home/ohtsuka/scale-5.4.5/scale-rm/test/tutorial/ideal/"; % Directory of scale-rm
scalecommand = "wsl -e mpirun -n 2 "+scaledir+"scale-rm "+fnconf; % Command to run scale-rm
prc_num_x = 1; % Number of processes in x direction
prc_num_y = 2; % Number of processes in y direction
stepy = 1; % Step of perturbed grids in y direction
stepz = 1; % Step of perturbed grids in z direction

% Load nominal initial condition
[fninit_org,finfoinit_org] = getcdfinfo(fninitbase_org,prc_num_x,prc_num_y);
disp(fninit_org);
varinit_org = ncreadinit(fninit_org,prc_num_x,prc_num_y,varname);
ny = finfoinit_org(1).Dimensions(6).Length;
nz = finfoinit_org(1).Dimensions(1).Length;
my = prc_num_y*ny;
digy = ceil(log10(ny))+1; % Digit of grid numbers in y direction
digz = ceil(log10(nz))+1; % Digit of grid numbers in z direction

% Load nominal history
[fnhist_org,finfohist_org] = getcdfinfo(fnhistbase_org,prc_num_x,prc_num_y);
disp(fnhist_org);

prc_num = prc_num_x * prc_num_y;
datat = ncread(fnhist_org(1),"time");
datax = [];
datay = [];
for i = 1:prc_num_x
    datax = [datax;ncread(fnhist_org(i),"x")];
end
for j = 1:prc_num_y
    datay = [datay;ncread(fnhist_org(prc_num_x*(j-1)+1),"y")];
end
dataz = ncread(fnhist_org(1),"z");
dataPREC_org = ncreadhist(fnhist_org,prc_num_x,prc_num_y,"PREC");
totalPREC_org = trapz(datat,dataPREC_org,3); % trapezoidal rule

dimt = size(datat,1);
dimx = size(datax,1);
dimy = size(datay,1);
dimz = size(dataz,1);
dimyz = dimy*dimz;
dimxyz = dimx*dimyz;
dimPREC = size(totalPREC_org,2);

save(settingsdata);
