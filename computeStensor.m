% M-file for Computing Sensitivity Matrix of Total PREC to Initial Conditions
%
% Variables in Initial Conditions
% "DENS", "MOMZ", "MOMX", "MOMY", "RHOT", "QV", "QC", "QR", "QI", "QS", "QG"
% 
% Toshiyuki Ohtsuka, Feb. 2024
clear;
load("Perturbed\QV\dvarsettings.mat"); % MAT file of settings
stensordata = dirvar+filesep+"StensorPREC.mat"; % MAT file for saving Sensitivity tensor

% Compute sensitivities
StensorPREC = zeros(my,my,nz);
tic
for k = 1:stepz:nz
    for p = 1:prc_num_y
        for j = 1:stepy:ny
            % Read perturbed history file 
            dirnum = sprintf(['%0',num2str(digz),'u','%0',num2str(digy),'u'],k,ny*(p-1)+j);
            dirname = dirbase+filesep+varname+filesep+dirnum+filesep;
            [fn1,finfo1] = getcdfinfo(dirname+fnhistbase,prc_num_x,prc_num_y);
            disp(fn1);
            dataPREC1 = ncreadhist(fn1,prc_num_x,prc_num_y,"PREC");
            dataPRECdiff = dataPREC1 - dataPREC_org; % difference of two histories
            totalPRECdiff = trapz(datat,dataPRECdiff,3)/dvar; % trapezoidal rule
            StensorPREC(:,ny*(p-1)+j,k) = totalPRECdiff';
        end
    end
end
comptime_Stensor=toc;
fprintf("Computation time = %g [sec]\n",comptime_Stensor);
save(stensordata,"StensorPREC","dirvar","settingsdata","stensordata","comptime_Stensor");