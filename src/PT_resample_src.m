

% Returns the convolution of two pupil fill srcs resampled to a
% resolution of pixels (last param)
% @param {struct 1x1} pupil - a structure storing the x and y coordinates as well
% as the corresponding intensities in the .x, .y and .z components of the
% structure. The size and shapes of each of these is identical and can be
% either a one-dimensional list (just specifying spots) or two-dimensional
% matrices (bitmaps).
% @param {double 1x1} dPixels - number of pixels in output pupil
% @return {struct 1x1} pupil - see pupil1 definition

function pupil = PT_resample_src(pupil1, dPixels)

% Output pupil sampling
dX = linspace(-1, 1, dPixels);
dY = dX;
[dX, dY] = meshgrid(dX, dY);

% If pupil1 data is 2D, convert to 1D list for interpolation with griddata
if ~isvector(pupil1.x)
    pupil1.x = pupil1.x(:);
    pupil1.y = pupil1.y(:);
    pupil1.z = pupil1.z(:);
end
    
% Interpolate pupil1 on output grid
dZ1Cart = griddata(...
    pupil1.x, pupil1.y, pupil1.z, ...
    dX, ...
    dY ...
);

% griddata returns NaN when the input data source has
% no information at the provided grid point
dZ1Cart(isnan(dZ1Cart)) = 0; 

dZ = dZ1Cart;
dZ = dZ ./ max(max(dZ)); 

x = dX(:);
y = dY(:);
z = dZ(:);

%{
% kill anything that is very low intentisy
indexLow = z < 0.01;
x(indexLow) = [];
y(indexLow) = [];
z(indexLow) = [];
%}

pupil.x = x;
pupil.y = y;
pupil.z = z;

end
