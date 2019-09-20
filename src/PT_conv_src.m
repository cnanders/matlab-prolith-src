

% Returns the convolution of two pupil fill srcs resampled to a
% resolution of pixels (last param)
% @param {struct 1x1} pupil1 - a structure storing the x and y coordinates as well
% as the corresponding intensities in the .x, .y and .z components of the
% structure. The size and shapes of each of these is identical and can be
% either a one-dimensional list (just specifying spots) or two-dimensional
% matrices (bitmaps).
% @param {struct 1x1} pupil2 - see pupil1 definition
% @param {double 1x1} dPixels - number of pixels in output pupil
% @return {struct 1x1} pupil - see pupil1 definition

function pupil = PT_conv_src(pupil1, pupil2, dPixels)

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


% If pupil2 data is 2D, convert to 1D list for interpolation with griddata
if ~isvector(pupil2.x)
    pupil2.x = pupil2.x(:);
    pupil2.y = pupil2.y(:);
    pupil2.z = pupil2.z(:);
end

% Interpolate pupil2 on output grid
dZ2Cart = griddata(...
    pupil2.x, pupil2.y, pupil2.z, ...
    dX, ...
    dY ...
);

dZ = conv2(dZ1Cart, dZ2Cart, 'same');
dZ = dZ ./ max(max(dZ)); 

pupil.x = dX(:);
pupil.y = dY(:);
pupil.z = dZ(:);

end
