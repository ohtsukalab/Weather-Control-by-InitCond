% M-file for Optimizing Initial Condition Perturbation
%  and Run SCALE-RM with Perturbed Initial Condition
%
% Toshiyuki Ohtsuka, Feb. 2024
clear;
load("Perturbed\RHOT\dvarsettings.mat"); % MAT file of settings
load(dirvar+filesep+"StensorPREC.mat"); % MAT file of sensitivity
%optname = "Ref0p5L2NN"; % Name of optimization problem
optname = "Uub0p5L1NN"; % Name of optimization problem
optdir  = dirvar+filesep+optname; % Directory for settings and solutions of optimization problem
ansdata     = optdir+filesep+"dvarans.mat"; % Settings and Solutions to save
figdata     = optdir+filesep+"opt_"+varname; % Figure to save
perhistdata = optdir+filesep+"history_opt.pe"; % Perturbed history files to save


% Optimize perturbation of initial condition
SmatPREC = reshape(StensorPREC,dimPREC,dimyz);

%%%% Define reference of total PREC %%%%
%totalPRECref = 0.5*totalPREC_org;  % Reference PREC 
totalPRECref = 0.5*max(totalPREC_org)*ones(1,dimy); % Uniform Upper Bound

dPREC = totalPRECref - totalPREC_org;  % Desired perturbation in total PREC

%%%% Find opitmal perturbation of initial condition %%%%
tic
%dvarans = lsqlin(eye(dimyz),zeros(dimyz,1),[],[],SmatPREC,dPREC'); % L2 norm min for Ref. 
%dvarans = lsqlin(eye(dimyz),zeros(dimyz,1),SmatPREC,dPREC'); % L2 norm min for Ref. Upper Bound 
%dvarans = minL1lin_rev(eye(dimyz),zeros(dimyz,1),[],[],SmatPREC,dPREC'); % L1 norm min for Ref. 
%dvarans = minL1lin_rev(eye(dimyz),zeros(dimyz,1),SmatPREC,dPREC'); % L1 norm min for Ref. Upper Bound 
%%% optimization with a non-negativity constraint for initial condition after perturbation: var0vec+dvarans >= 0 
var0vec = reshape(varinit_org,dimyz,1); % nominal initial condition 
Aineq = -eye(dimyz);
%dvarans = lsqlin(eye(dimyz),zeros(dimyz,1),Aineq,var0vec,SmatPREC,dPREC'); % L2 norm min for Ref. 
%dvarans = lsqlin(eye(dimyz),zeros(dimyz,1),[SmatPREC;Aineq],[dPREC';var0vec]); % L2 norm min for Ref. Upper Bound 
%dvarans = minL1lin_rev(eye(dimyz),zeros(dimyz,1),Aineq,var0vec,SmatPREC,dPREC'); % L1 norm min for Ref. 
dvarans = minL1lin_rev(eye(dimyz),zeros(dimyz,1),[SmatPREC;Aineq],[dPREC';var0vec]); % L1 norm min for Ref. Upper Bound 
comptime_dvarans=toc;
fprintf("Computation time = %g [sec]\n",comptime_dvarans);
fprintf("Minimun value of initial condition after perturbation %g \n",min(var0vec+dvarans));

dvaransmat = reshape(dvarans,dimy,dimz);
system("mkdir "+optdir);
save(ansdata,"varname","optname","totalPRECref","dvaransmat","comptime_dvarans");
surf(dvaransmat');
xlabel("Grid y");
ylabel("Grid z");
zlabel("\Delta"+varname);
title(varname);
savefig(figdata+".fig");
print(figdata,"-dpng");

% Modify initial conditions by dvaransmat
copycdf(fninitbase_org,fninitbase,prc_num);
[fn,finfo] = getcdfinfo(fninitbase,prc_num_x,prc_num_y);
disp(fn);

for p = 1:prc_num_y
    var0 = ncread(fn(p),varname);
    var1 = permute(var0,[3,1,2]);
    var1(:,1:dimz) = var1(:,1:dimz) + dvaransmat(ny*(p-1)+1:ny*p,:);
    ncwrite(fn(p),varname,permute(var1(:,:,1),[2,3,1]));
end

% Run scale-rm for perturbed initial condition
disp(scalecommand);
[status,cmdout] = system(scalecommand);
if status == 1
    exit;
end
disp(cmdout);
copycdf(fnhistbase,perhistdata,prc_num);

% Plot total PREC
[fn1,finfo1] = getcdfinfo(perhistdata,prc_num_x,prc_num_y);
dataPREC1 = ncreadhist(fn1,prc_num_x,prc_num_y,"PREC");
totalPREC1 = trapz(datat,dataPREC1,3); % trapezoidal rule
save(ansdata,"totalPREC1","-append"); % Save perturbed total PREC
plot(datay,totalPREC_org,'k-',datay,totalPREC1,'b-',datay,totalPRECref,'r--');
legend("Nominal",varname+" Perturbed","Reference",'Location','northwest');
xlabel("y [m]");
ylabel("Total PREC [mm]");
savefig(figdata+"_totalPREC_comp.fig");
print(figdata+"_totalPREC_comp","-dpng");
