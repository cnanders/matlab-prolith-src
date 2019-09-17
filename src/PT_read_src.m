function pupil = PT_read_src(varargin)
% Small function to read in .src files
%
% The function returns a structure storing the x and y coordinates as well
% as the corresponding intensities in the .x, .y and .z components of the
% structure. The size and shapes of each of these is identical and can be
% either a one-dimensional list (just specifying spots) or two-dimensional
% matrices (bitmaps). 
%
% Written by Christoph Hennerkes, SMO PEG, December 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MAXHEADERLINES = 5000;

% Check if we got a file
if nargin > 0
    filename = varargin{1};
else
    filename = uigetfile('*.src', 'Select .src file ...');
end

if ~exist(filename, 'file')
    error('File "%s" not found!', filename);
end

fid = fopen(filename, 'r'); % Rely on fopen's error handling...

% Read the header first
line = strtrim(fgetl(fid));
header = {};
count = 0;
while ~strcmpi('[data]', line)
    header = [header, {line}];  %#ok<AGROW>
    line = strtrim(fgetl(fid));
    count = count + 1;
    if count > MAXHEADERLINES
        error('Header too large!');
    end
end

% Ok, [data] has been read ... read the final entries
data = fscanf(fid, '%f %f %f\n', [3, inf]);
x = data(1,:);
y = data(2,:);
z = data(3,:);

% Check the contents of x and y and try to determine if we have a two
% dimensional bitmap
n = numel(unique(x));
m = numel(unique(y));
if n*m == numel(z)
    % First good indication that we have a bitmap, skip otherwise
    % Now generate new meshgrids for x and y based on n, m and the maximum
    % and minimum values of x and y
    maxX = max(unique(x)); minX = min(unique(x));
    maxY = max(unique(y)); minY = min(unique(y));
    if any((unique(x) - linspace(minX, maxX, n)) > 0.001)
        warning('Large deviation in x positions found!');
    end
    if any((unique(y) - linspace(minY, maxY, m)) > 0.001)
        warning('Large deviation in y positions found!');
    end
    [newX, newY] = meshgrid(linspace(minX, maxX, n), linspace(minY, maxY, m));
    newZ = griddata(x, y, z, newX, newY, 'nearest');
    
    % Replace old one dimensional arrays with new arrays
    x = newX; y = newY; z = newZ;
end


% Assemble the final pupil structure
if numel(header) > 0
    pupil.header = header;
end
pupil.x = x;
pupil.y = y;
pupil.z = z;
pupil.filename = filename;

end