function [ cellArray ] = extractfield( structArray, name )
%EXTRACTFIELD loops through structs and extracts the field of that name
%   Deailed explanation goes here
    if size(structArray,2) > 1 
        dim = 2;
    else 
        dim = 1;
    end
    checkExistance = @(x) isfield (x, name) &&  ~isempty(x.(name)); %checking existance of field and value inside
    cellArray = cell(1, length(structArray));
    for i = 1:size(structArray,dim);
        if ~checkExistance(structArray(i))
            cellArray{i} = NaN;      
            continue
        end
        cellArray{i} = structArray(i).(name);
    end
end