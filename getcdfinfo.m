function [fn,finfo] = getcdfinfo(fnbase,prc_num_x,prc_num_y)
% getcdfinfo - Get information of netCDF data for SCALE
% Syntax [fn,finfo] = getcdfinfo(fnbase,prc_num_x,prc_num_y)
% Input 
%  fnbase: Base name of data files "...pe" 
%  prc_num_x, prc_num_y: Numbers of processes in x and y directions
% Output
%  fn: Array of data files
%  finfo: Array of information on data files
%
% T. Ohtsuka, Oct. 2023
prc_num = prc_num_x * prc_num_y; % Number of processes
for i = 1:prc_num
    fnnum = sprintf('%06u',i-1);
    fn(i) = fnbase + fnnum + '.nc';
    finfo(i) = ncinfo(fn(i));
end
