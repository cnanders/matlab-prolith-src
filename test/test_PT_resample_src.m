try 
    purge
end

close all
clc
clear

[cDirThis, cName, cExt] = fileparts(mfilename('fullpath'));
cDirSrc = fullfile(cDirThis, '..', 'src');
cDirMpm = fullfile(cDirThis, '..', 'mpm-packages');

addpath(cDirSrc);
addpath(cDirMpm);

p1 = PT_read_src();
PT_display(p1);


p2 = PT_resample_src(p1, 71); 
PT_display(p2);


PT_save_src(p2);