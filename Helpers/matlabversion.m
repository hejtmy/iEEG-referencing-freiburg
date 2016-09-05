function [ year ] = matlabversion()
%MATLABVERSION Summary of this function goes here
%   Detailed explanation goes here
    split = strsplit(version,' ');
    [match, nomatch] = regexp(split{2},'\d+','match','split');
    year = str2double(match);
end
