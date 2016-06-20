function [ strct ] = matlabversion()
%MATLABVERSION Summary of this function goes here
%   Detailed explanation goes here
    split = strsplit(version,' ');
    strct = struct();
    [match, nomatch] = regexp('R2010b','\d+', 'match', 'split');
    strct.year = str2double(match);
end