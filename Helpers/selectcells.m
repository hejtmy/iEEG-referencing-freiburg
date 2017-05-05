function [ selected ] = selectcells( cellarray, func )
%SELECTCELLS Summary of this function goes here
%   Detailed explanation goes here
    idx = cellfun(func, cellarray, 'UniformOutput', false);
    idx = cell2mat(idx);
    selected = cellarray(idx);
end

