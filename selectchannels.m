function [ selectedChannelNumbers ] = selectchannels( Header, signalTypes )
%SELECTCHANNELS Summary of this function goes here
%   signalTypes: cell with strings of signal types, e.g. {'SEEG', 'ECoG-Grid', 'ECoG-Strip'};  
    selectedChannelNumbers = [];
    signalTypes = {'SEEG', 'ECoG-Grid', 'ECoG-Strip'};           % select desired channel group
    for channelIndex = 1:size(Header.channels, 2)
        if isfield(Header.channels(channelIndex), 'signalType')  % if the field exists - if it doesn't, this should really return something
            if ismember(Header.channels(channelIndex).signalType, signalTypes)
                selectedChannelsNumbers = [selectedChannelsNumbers, Header.channels(channelIndex).numberOnAmplifier];
            end
        else
            fprintf('Channel %d struct does not have singalType field', channelIndex);
        end
    end
end

