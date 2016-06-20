function [ valueArray ] = extractfield( structArray, name )
%EXTRACTFIELD loops through structs and extracts the field of that name
%   Deailed explanation goes here
    if size(structArray,2) > 1 
        dim = 2;
    else 
        dim = 1;
    end
    valueArray = zeros(length(structArray),1);
    for i = 1:size(structArray,dim);
        valueArray(i) = structArray(i).(name);
    end
end