function datall = ncreadhist(fnar,nx,ny,dn)
% ncreadhist - Read netCDF history data from nx*ny files and combine into an array
% Syntax datall = ncreadhist(fnar,nx,ny,dn)
% Input 
%  fnar: Array of filenames of netCDF obtained by getcdfinfo.m 
%  nx,ny: Numbers of processes in x and y directions
%  dn: String of data name
% Output
%  datall: Array combining data from nx*ny files
% Ref. SCALE USERS GUIDE Ver. 5.4.5 Subsec 4.2.3
% 
% T. Ohtsuka, Oct. 2023
datall = [];
for i = 1:ny
    dtmp = [];
    for j = 1:nx
        k = nx*(i-1) + j;
        dtmp = [dtmp;ncread(fnar(k),dn)];
    end
    datall = [datall,dtmp];
end