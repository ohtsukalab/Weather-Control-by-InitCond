% M-file for Running SCALE-RM with Initial Condition Perturbed at Each Grid
%
% Variables in Initial Conditions
% "DENS", "MOMZ", "MOMX", "MOMY", "RHOT", "QV", "QC", "QR", "QI", "QS", "QG"
% 
% Toshiyuki Ohtsuka, Feb. 2024
clear;
load("Perturbed\QV\dvarsettings.mat"); % MAT file of settings

copycdf(fninitbase_org,fninitbase,prc_num); % Copy original init data files for modification
[fn,finfo] = getcdfinfo(fninitbase,prc_num_x,prc_num_y);
disp(fn);

for i = 1:prc_num
    fnnum = sprintf('%06u',i-1);
    fnhist(i) = fnhistbase + fnnum + '.nc';
end
disp(fnhist);

tic
for k = 1:stepz:nz
    for p = 1:prc_num_y
        for j = 1:stepy:ny
            disp("=============================");
            disp([k ny*(p-1)+j]);
            pos = [k 1 j]; % Position of grid to be perturbed
            var0 = ncread(fn(p),varname,pos,[1 1 1]);
            var1 = var0 + dvar;
            ncwrite(fn(p),varname,var1,pos);
            % Run scale-rm
            disp(scalecommand);
            [status,cmdout] = system(scalecommand);
            if status == 1
                exit;
            end
            disp(cmdout);
            % Copy history files 
            dirnum = sprintf(['%0',num2str(digz),'u','%0',num2str(digy),'u'],k,ny*(p-1)+j);
            dirname = dirbase+filesep+varname+filesep+dirnum;
            disp(dirname);
            system("mkdir "+dirname);
            copycdf(fnhistbase,dirname+filesep+fnhistbase,prc_num); % Copy perturbed history files
            copycdf(fninitbase_org,fninitbase,prc_num); % Reset init data files
        end
    end
end
comptime_per=toc;
fprintf("Computation time = %g [sec]\n",comptime_per);
save(dirvar+filesep+"comptime_per.mat","comptime_per");