function PT_save_src(pupil, filename)
% Function to write a given pupil as .src file
%
% Takes a pupil structure in the same format as PT_display and saves it
% into a .src file stored under 'filename'. If
% filename is empty, open a dialogbox allowing the definition of a
% filename.
%
%  PT_save_src(pupil, filename, header, logscale)
%
% Written by Christoph Hennerkes, SMO PEG, December 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Check if we got a file
if ~exist('filename', 'var') || isempty(filename)
    filename = uiputfile('*.src', 'Define .src file ...');
end

M(:,1) = pupil.x(:);
M(:,2) = pupil.y(:);
M(:,3) = pupil.z(:);

% Write file
try
    f = fopen(filename, 'wt');
    fprintf(f, '[Version]\n9.3\n\n');
    fprintf(f, '[Parameters]\n');
    fprintf(f, '%s\n', filename);
    fprintf(f, '[DATA]\n');
    for j = 1:length(M)
        fprintf(f,'%1.5f \t %1.5f \t %1.8f \n', M(j,1), M(j,2), M(j,3));
    end
    fclose(f);
catch mE
    rethrow(mE)
end


end