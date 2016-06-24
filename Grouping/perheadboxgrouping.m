function [ channelGroups ] = perheadboxgrouping( Header, selectedChannelsIndices )
%PERHEADBOX Summary of this function goes here
%   Detailed explanation goes here
% Common average reference: headboxes of amplifier with different REFs & GNDs
    if ~isfield(Header.channels(1), 'headboxNumber')
        channelGroups{1,1} = selectedChannelsIndices;
        return
    end
    %creates a vector of header indeces
    headboxAllNumbers = extractfield(Header.channels, 'headboxNumber')';
    headboxAllNumbers = cell2mat(headboxAllNumbers);                                            %needs to convert to doubles
    %validate that all numbers are indeed numbers - TODO
    headboxSelectedNumbers = headboxAllNumbers(selectedChannelsIndices)';           % headbox numbers - FIX THIS!!!
    assert(size(selectedChannelsIndices,2) == size(headboxSelectedNumbers,2));          % check that each part has a headbox number
    headboxUniqueNumbers = unique(headboxSelectedNumbers);                              % headbox numers
    channelGroups = cell(1, size(headboxUniqueNumbers,2));
    for headboxNumber = headboxUniqueNumbers
        %select all indices of all headbox numbers
        indices = (headboxSelectedNumbers == headboxNumber);
        channelGroups{headboxNumber} = selectedChannelsIndices(indices);
    end
end