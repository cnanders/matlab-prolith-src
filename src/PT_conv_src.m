

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
[dRows, dCols] = size(pupil1.x);
if (dRows == 1 || dCols == 1)
    dX1 = pupil1.x;
    dY1 = pupil1.y;
    dZ1 = pupil1.z;
else
    dX1 = reshape(pupil1.x, [1, dRows * dCols]);
    dY1 = reshape(pupil1.y, [1, dRows * dCols]);
    dZ1 = reshape(pupil1.z, [1, dRows * dCols]);
end
    
% Interpolate pupil1 on output grid
dZ1Cart = griddata(...
    dX1, dY1, dZ1, ...
    dX, ...
    dY ...
);


% If pupil2 data is 2D, convert to 1D list for interpolation with griddata
[dRows, dCols] = size(pupil2.x);
if (dRows == 1 || dCols == 1)
    dX2 = pupil2.x;
    dY2 = pupil2.y;
    dZ2 = pupil2.z;
else
    dX2 = reshape(pupil2.x, [1, dRows * dCols]);
    dY2 = reshape(pupil2.y, [1, dRows * dCols]);
    dZ2 = reshape(pupil2.z, [1, dRows * dCols]);
end

% Interpolate pupil2 on output grid
dZ2Cart = griddata(...
    dX2, dY2, dZ2, ...
    dX, ...
    dY ...
);

dZ = conv2(dZ1Cart, dZ2Cart, 'same');
dZ = dZ ./ max(max(dZ)); 

pupil.x = reshape(dX, [1, dPixels * dPixels]);
pupil.y = reshape(dY, [1, dPixels * dPixels]);
pupil.z = reshape(dZ, [1, dPixels * dPixels]);

end
