
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
figure
PT_display(p)

PT_save_src(p, 'met5_f2x_medium_with_sep2019_flare.src');


%{
p3 = PT_read_src();
p = PT_conv_src(p, p3, 251);
figure
PT_display(p)
%}