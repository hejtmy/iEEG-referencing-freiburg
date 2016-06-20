function [ valueArray ] = extractfield( structArray, name )
%EXTRACTFIELD loops through structs and extracts the field of that name
%   Deailed explanation goes here
    if size(structArray,2) > 1 
        dim = 2;
    else 
        dim = 1;
    end
    checkExistance = @(x) isfield (x, name) &&  ~isempty(x.(name)); %checking existance of field and value inside
    valueArray = zeros(1, length(structArray));
    for i = 1:size(structArray,dim);
        if ~checkExistance(structArray(i))
            valueArray(i) = NaN;      
            continue
        end
        valueArray(i) = structArray(i).(name);
    end
end