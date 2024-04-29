% Plot 2 Cases of Initial State Perturbation
% 
% Toshiyuki Ohtsuka, March 2024
clear;
figname = "comp2cases_QV_Uub0p5"; % Figure name
figdir  = "Perturbed\QV"; % Directory to save figure
load("Perturbed\QV\dvarsettings.mat"); % MAT file of settings
load("Perturbed\QV\Uub0p5L2\dvarans.mat"); % Data of Case 1
dvaransmat1 = dvaransmat; % Initial state perturbation in Case 1
totalPREC11 = totalPREC1; % Total PREC after perturbation in Case 1
load("Perturbed\QV\Uub0p5L1\dvarans.mat"); % Data of Case 2
dvaransmat2 = dvaransmat; % Initial state perturbation in Case 2
totalPREC12 = totalPREC1; % Total PREC after perturbation in Case 2
% totalPREC_org and totalPRECref must be same for all data. 

%%%% Prepare Labels for Figures %%%%
x1 = "Grid y";
y1 = "Grid z";
%z1 = "\Delta \rho \theta [kg \cdot K/m^3]"; % z label
z1 = "q_v"; % z label
t1 = "(a) Minimum $\ell_2$ Norm Solution"; % title

x2 = x1;
y2 = y1;
z2 = z1;
t2 = "(b) Minimum $\ell_1$ Norm Solution";

x3 = "Position y [m]";
y3 = "Accumulated Precipitation [mm]";
t3 = "(c) Accumulated Precipitation"; % title
% legend
%leg3 = ["Nominal", "$\rho \theta$ Perturbed (Min $\ell_2$ Norm)", "$\rho \theta$ Perturbed (Min $\ell_1$ Norm)", "Reference"];
%leg3 = ["Nominal", "$\rho \theta$ Perturbed (Min $\ell_2$ Norm)", "$\rho \theta$ Perturbed (Min $\ell_1$ Norm)", "Upper Bound"];
%leg3 = ["Nominal", "$q_v$ Perturbed (Min $\ell_2$ Norm)", "$q_v$ Perturbed (Min $\ell_1$ Norm)", "Reference"];
leg3 = ["Nominal", "$q_v$ Perturbed (Min $\ell_2$ Norm)", "$q_v$ Perturbed (Min $\ell_1$ Norm)", "Upper Bound"];

FP = [100,100,1000,700]; % Figure Position
FS = 10; % Font Size

%%%% Plot Perturbations of Initial Condition %%%%
f = figure;
f.Position = FP;

subplot(2,2,1);
surf(dvaransmat1');
set(gca,'FontSize',FS);
xlabel(x1);
ylabel(y1);
zlabel(z1);
title(t1,'Interpreter','latex');

subplot(2,2,2);
surf(dvaransmat2');
set(gca,'FontSize',FS);
xlabel(x2);
ylabel(y2);
zlabel(z2);
title(t2,'Interpreter','latex');

%%%% Plot Accumulated Precipitations %%%%
subplot(2,2,[3,4]);
plot(datay,totalPREC_org,'k-','LineWidth',1);
hold on;
plot(datay,totalPREC11,'g-',datay,totalPREC12,'b-','LineWidth',2);
plot(datay,totalPRECref,'r--','LineWidth',1);
legend(leg3,'Location','northwest','Interpreter','latex');
set(gca,'FontSize',FS);
xlabel(x3);
ylabel(y3);
title(t3,'Interpreter','latex');
hold off;

savefig(figdir+filesep+figname);
exportgraphics(f,figdir+filesep+figname+'.pdf','ContentType','vector');
exportgraphics(f,figdir+filesep+figname+'.png');
