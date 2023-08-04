function rootPath=iefundamentalsRootPath()
% Return the path to the root isetefundamentals directory
%
% This function must reside in the directory at the base of the ISET
% directory structure.  It is used to determine the location of various
% sub-directories.
%
% Example:
%   fullfile(isetRootPath,'data')

rootPath=which('iefundamentalsRootPath');

rootPath = fileparts(rootPath);

end
