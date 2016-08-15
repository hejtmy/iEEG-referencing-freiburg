function [refData, channelGroups] = referenceeeg(data, montage, selectedChannels, referenceType, varargin)
%REFERENCEEEG Summary of this function goes here
%   Detailed explanation goes here
%   Selected channels:  cell with names of channels we want to include {'SEEG', 'ECoG-Grid', 'ECoG-Strip'}

    selectedChannelsIndices = selectchannelsindices(montage, selectedChannels);
    nChannels = size(montage.channels, 2);
    % TODO - better
    if ~isempty(varargin)
        [filterMatrix, channelGroups] = createspatialfilter(montage, nChannels, selectedChannelsIndices, 'filterName', referenceType, varargin);
    else 
         [filterMatrix, channelGroups] = createspatialfilter(montage, nChannels, selectedChannelsIndices, 'filterName', referenceType);
    end
    refData = data * filterMatrix;
end

