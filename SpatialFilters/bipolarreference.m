function [ filterMatrix, channelGroups ] = bipolarreference( Header, nInputChannels, selectedChannelsIndices )
%BIPOLARREFERENCE Summary of this function goes here
%   Detailed explanation goes here
    % define channel groups
    channelGroups = getchannelgroups(Header, selectedChannelsIndices, 'bipolar');    
    % design filter
    filterMatrix = zeros(nInputChannels, size(channelGroups,2));      % init
    for channelGroup = 1:size(channelGroups,2)
        selectedChannels = channelGroups{channelGroup};
        filterMatrix(selectedChannels(1), channelGroup) = 1;                     % set weights for BIP channels
        if size(selectedChannels,2) == 2
            filterMatrix(selectedChannels(2), channelGroup) = -1;                % set weights for BIP channels
        else
            warning(['BIP: only 1 channel on electrode shank, no referencing. Channel = ' num2str(channelGroup)]);
        end
    end  
end