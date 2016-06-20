function [ filterMatrix ] = commonaveragereference( Header, nInputChannels, selectedChannelsIndices, channelGrouping )
%COMMONAVERAGEREFERENCE Summary of this function goes here
%   Detailed explanation goes here
 %  define channel groups
    channelGroups = getChannelGroups_kisarg(Header, selectedChannelsIndices, channelGrouping);
    
    filterMatrix = zeros(nInputChannels);
    for channelGroup = 1:size(channelGroups, 2)
        selectedChannels = channelGroups{channelGroup};
        nChannels = size(selectedChannels, 2);
        filterMatrix(selectedChannels, selectedChannels) = eye(nChannels) - 1/nChannels.*ones(nChannels);    % set weights for CAR channels
    end
end