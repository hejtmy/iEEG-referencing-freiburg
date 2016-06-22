function [ bool ] = onsameelectrode( Header, index1, index2 )
%ONSAMEELECTRODE returns if two channels are on the same electrode or not
%   Detailed explanation goes here
    shank1 = extractfromstring(Header.channels(index1).name, 'string');
    shank2 = extractfromstring(Header.channels(index2).name, 'string');        
    bool = strcmp(shank1, shank2) ;
end

