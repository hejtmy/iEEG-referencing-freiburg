function [ selectedChannelsIndices ] = selectchannelsindices(  Header, signalTypes )
%SELECTCHANNELS returns a vector of channel indices that are of a given recorging type
%   signalTypes: cell with strings of signal types, e.g. {'SEEG', 'ECoG-Grid', 'ECoG-Strip'};  
    
%VALIDATE signal types
    selectedChannelsIndices = [];
    for channelIndex = 1:size(Header.channels, 2)
        if isfield(Header.channels(channelIndex), 'signalType')  % if the field exists - if it doesn't, this should really return something
            if ismember(Header.channels(channelIndex).signalType, signalTypes)
                selectedChannelsIndices = [selectedChannelsIndices, channelIndex];
            end
        else
            fprintf('Channel %d struct does not have singalType field in header', channelIndex);
        end
    end
end