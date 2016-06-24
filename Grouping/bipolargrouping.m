function [ channelsGroups ] = bipolargrouping( Header, selectedChannelsIndices )
%BIPOLAR Returns cells with each cell having indexes of neighbouring electrodes
%   selectedChannelIndices: indices of electrodes as they go in the header file as well as in hte data (not necessarily
%   the same as number on amplifier"
%   
%   the complicated part is that if we discard a channel we nned to skip in in bipolar calculations
    channelsGroups = [];
    groupIndex = 1;
    for channelIndex = 2:length(selectedChannelsIndices)
        currentChannelIndex = selectedChannelsIndices(channelIndex);
        previousChannelIndex =selectedChannelsIndices(channelIndex-1);
        if currentChannelIndex - previousChannelIndex == 1 %checking if neighbours
            if onsameelectrode(Header, currentChannelIndex, previousChannelIndex)
                channelsGroups{groupIndex} = [previousChannelIndex, currentChannelIndex];
                groupIndex = groupIndex+1;
            end
        end
    end   
end