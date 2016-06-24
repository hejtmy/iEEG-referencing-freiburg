function [ bool ] = checkheader( Header, data )
%CHECKHEADER Summary of this function goes here
%   Detailed explanation goes here

    bool = false;
    %% check continuous sequence
    for channelIndex = 2:size(Header.channels)
        if Header.channels(channelIndex).numberOnAmplifier - Header.channels(channelIndex-1).numberOnAmplifier ~= 1
            warning('Freiburg:Header:inconsitent','Header channels are not in a continuous sequence. Might lead to problems');
            return
        end
    end
    
    if size(data,2) ~= size(Header.channels,2)
         warning('Freiburg:Header:incorrectDimensions','Header channel do not have same number of channels as there are in the data');
         return
    end
    bool = true;
end

