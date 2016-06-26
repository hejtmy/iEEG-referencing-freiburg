function [ selectedChannelsNumbers ] = selectchannels( Header, signalTypes )
%SELECTCHANNELS returns a vector of channel numbersOnAmplifier that are of a given recorging type
%   signalTypes: cell with strings of signal types, e.g. {'SEEG', 'ECoG-Grid', 'ECoG-Strip'};  
    
%VALIDATE signal types
    selectedChannelsNumbers = [];
    for channelIndex = 1:size(Header.channels, 2)
        if isfield(Header.channels(channelIndex), 'signalType')  % if the field exists - if it doesn't, this should really return something
            if ismember(Header.channels(channelIndex).signalType, signalTypes)
                selectedChannelsNumbers = [selectedChannelsNumbers, Header.channels(channelIndex).numberOnAmplifier];
            end
        else
            fprintf('Channel %d struct does not have singalType field in header', channelIndex);
        end
    end
end