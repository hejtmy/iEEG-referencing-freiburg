function [ filtermatrix ] = bipolarreference( Header, nInputChannels )
%BIPOLARREFERENCE Summary of this function goes here
%   Detailed explanation goes here
    % define channel groups
    channelGroups = getChannelGroups_kisarg(Header, 'bipolar');
    
    % design filter
    filterMatrix = zeros(nInputChannels, size(channelGroups,2));      % init
    selCh_H = [];
    for channelGroup = 1:size(channelGroups,2)
        selectedChannels = channelGroups{channelGroup};
        filterMatrix(selectedChannels(1), channelGroup) = 1;                     % set weights for BIP channels
        if size(selectedChannels,2) == 2
            filterMatrix(selectedChannels(2), channelGroup) = -1;                % set weights for BIP channels
        else
            warning(['BIP: only 1 channel on electrode shank, no referencing. Channel = ' num2str(channelGroup)]);
        end
        selCh_H = cat(2, selCh_H, selectedChannels(1));
    end  

end

