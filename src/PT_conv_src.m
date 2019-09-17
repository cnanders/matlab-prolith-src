

% Convolves two pupil fill srcs together and returns the output with a
% resolution of pixels (last param)
% @param {struct} pupil1
% @param {double 1xm} pupil1.x - list of sigmaX values of src1
% @param {double 1xm} pupil1.y - list of sigmaY values of src1
% @param {double 1xm} pupil1.z - list of relative intensity values of src1
% @param {struct} pupil1
% @param {double 1xm} pupil2.x - list of sigmaX values of src2
% @param {double 1xm} pupil2.y - list of sigmaY values of src2
% @param {double 1xm} pupil2.z - list of relative intensity values of src2
% @param {double 1x1} dPixels - number of pixels in output pupil
% @return {struct} pupil
% @return {double pixels * pixels} pupil.x - sigmaX values of output
% @return {double pixels * pixels} pupil.y - sigmaY values of output
% @return {double pixels * pixels} pupil.z - intensity values of output

function pupil = PT_conv_src(pupil1, pupil2, dPixels)

dX = linspace(-1, 1, dPixels);
dY = dX;
[dX, dY] = meshgrid(dX, dY);

dZ1Cart = griddata(...
    pupil1.x, pupil1.y, pupil1.z, ...
    dX, ...
    dY ...
);

dZ2Cart = griddata(...
    pupil2.x, pupil2.y, pupil2.z, ...
    dX, ...
    dY ...
);

% dZ1Cart = dZ1Cart ./ max(max(dZ1Cart));
% dI2Cart = dI2Cart ./ max(max(dI2Cart));

dZ = conv2(dZ1Cart, dZ2Cart, 'same');
dZ = dZ ./ max(max(dZ)); 

pupil.x = dX;
pupil.y = dY;
pupil.z = dZ;

end
