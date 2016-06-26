function [ channelGroups ] = perelectrodegrouping( Header, selectedChannelsIndices)
%PERELECTRODE Summary of this function goes here
%   In case all channels from one electrode are discarded, electrode is returned as empty - ISSUE, fix it
    electrodesFullNames = extractfield(Header.channels, 'name');
    electrodesNames = cellfun(@(x) extractfromstring(x, 'string'), electrodesFullNames, 'UniformOutput', false);
   	uniqueElectrodesNames = unique(electrodesNames);
    channelGroups = cell(1,size(uniqueElectrodesNames,2));
    
    for electrodeIndex = 1:size(uniqueElectrodesNames,2)
        electrodeName = uniqueElectrodesNames(electrodeIndex);
        channelsThatBelong = cellfun(@(x) strcmp(electrodeName, x) ,electrodesNames, 'UniformOutput', true);
        channelsIndices = find(channelsThatBelong);
        channelGroups{electrodeIndex} = intersect(channelsIndices,selectedChannelsIndices);
    end
end