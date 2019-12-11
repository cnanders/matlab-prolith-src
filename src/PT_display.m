function h = PT_display(pupilOrFile, header, logscale)
% Function to display a given pupil structure
%
% The function takes a pupil structure containing x and y coordinates as
% well as intensities in the corresponding .x, .y and .z components. In
% case the components are one-dimensional, a scatter plot is generated.
% Otherwise a bitmap is plotted using imagesc.
%
%  h = PT_display(pupil, header, logscale)
%
% Written by Christoph Hennerkes, SMO PEG, December 2014.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TODO: Add input validation

% Also accept a filename as first input
if ischar(pupilOrFile)
    pupil = PT_read_src(pupilOrFile);
else
    pupil = pupilOrFile;
end


% Define the minimal span of the displayed pupil. In case of one
% dimensional values, it often happens that only spots carrying intensity
% are specified.
MINSPAN = 1;
TITLEPROPS = { 'FontSize', 14, 'FontWeight', 'bold' };

% Check if we are asked to do a logarithmic plot
if exist('logscale', 'var')
    minorder = -6;
    if isnumeric(logscale) && isscalar(logscale)
        minorder = logscale;
    end
    % Convert to log scale
    pupil.z = log10(pupil.z/max(pupil.z(:)));
    pupil.z(pupil.z<minorder) = min(pupil.z(:));
else
    % Just normalize
    pupil.z = pupil.z/max(pupil.z(:));
end

% Special handling of DOE bitmaps
xmax = max(pupil.x(:));
xmin = min(pupil.x(:));
ymax = max(pupil.y(:));
ymin = min(pupil.y(:));
DOELIMIT = 0.05;
ISDOE = false;
if (xmax < DOELIMIT && xmin > -DOELIMIT && ymax < DOELIMIT && ymin > -DOELIMIT)
    pupil.x = pupil.x * 1000;
    pupil.y = pupil.y * 1000;
    xmax = xmax * 1000;
    xmin = xmin * 1000;
    ymax = ymax * 1000;
    ymin = ymin * 1000;
    ISDOE = true;
end

% Check if we are dealing with an array or bitmap structure
if isvector(pupil.z)
    % Scatter plot
    figure
    scatter(pupil.x, pupil.y, [], pupil.z, 'filled');
else
    % Bitmap plot
    figure
    imagesc(...
        unique(pupil.x, 'stable'), ...
        unique(pupil.y, 'stable'), ...
        pupil.z);
    set(gca,'YDir','normal');
end

h = gcf;

colorbar()
axis image;

xlim([min(xmin,-MINSPAN), max(xmax,MINSPAN)]);
ylim([min(ymin,-MINSPAN), max(ymax,MINSPAN)]);

% Check if header is specified
if exist('header', 'var') && ~isempty(header)
    title(header, TITLEPROPS{:});
else
    if isfield(pupil, 'filename')
        title(pupil.filename, 'Interpreter', 'none', TITLEPROPS{:});
    end
end
if ISDOE
    xlabel('x [mrad]');
    ylabel('y [mrad]');
else
    xlabel('sigma x');
    ylabel('sigma y');
end
end