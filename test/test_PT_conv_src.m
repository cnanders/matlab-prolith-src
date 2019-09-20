
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
p2 = PT_read_src();
p = PT_conv_src(p1, p2, 251);
PT_display(p)

p3 = PT_read_src();
p = PT_conv_src(p, p3, 51);
PT_display(p)