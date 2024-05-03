% M-file for Running SCALE-RM with Initial Condition Perturbed at Each Grid
%
% Variables in Initial Conditions
% "DENS", "MOMZ", "MOMX", "MOMY", "RHOT", "QV", "QC", "QR", "QI", "QS", "QG"
% 
% Toshiyuki Ohtsuka, Nov. 2023, Feb. 2024 - May 2024
clear;
load("Perturbed/RHOT/dvarsettings.mat"); % MAT file of settings

copycdf(fninitbase_org,fninitbase,prc_num); % Copy original init data files for modification
[fn,finfo] = getcdfinfo(fninitbase,prc_num_x,prc_num_y);
disp(fn);

for i = 1:prc_num
    fnnum = sprintf('%06u',i-1);
    fnhist(i) = fnhistbase + fnnum + '.nc';
end
disp(fnhist);

tscale= [];
tstart = tic;
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
            tic;
            [status,cmdout] = system(scalecommand);
            tscale1 = toc;
            tscale = [tscale,tscale1];
            if status == 1
                exit;
            end
            disp(cmdout);
            fprintf("Execution time for SCALE = %g [sec]\n",tscale1);
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
comptime_per=toc(tstart);
num_scale = length(tscale);
comptime_scale = mean(tscale);
fprintf("Total execution time = %g [sec] = %g [h]\n",comptime_per,comptime_per/3600);
fprintf("Total number of SCALE runs = %d\n",num_scale);
fprintf("Average execution time for SCALE runs = %g [sec]\n",comptime_scale);
save(dirvar+filesep+"comptime_per.mat","comptime_per","comptime_scale","tscale","num_scale");