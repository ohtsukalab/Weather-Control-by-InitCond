function copycdf(fn0,fn1,np)
% copycdf - Copy a set of netCDF data for SCALE
% Syntax copycdf(fn0,fn1,np)
% Input 
%  fn0: Base name of original files "...pe" 
%  fn1: Base name of destination files "...pe" 
%  np:  Numbers of processes
%
% T. Ohtsuka, Nov. 2023
for i = 1:np
    fnnum = sprintf('%06u',i-1);
    fn0full = fn0 + fnnum + '.nc';
    fn1full = fn1 + fnnum + '.nc';
    command = "copy /Y "+fn0full+" "+fn1full;
%    command = "copy /Y "+fn0full+" "+fn1full+" > null";
    disp(command);
    system(command);
end
