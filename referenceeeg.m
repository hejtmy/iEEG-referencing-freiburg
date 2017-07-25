function [refData, channelGroups] = referenceeeg(data, montage, selectedChannels, referenceType, varargin)
%REFERENCEEEG Summary of this function goes here
%   Detailed explanation goes here
%   Selected channels:  cell with names of channels we want to include {'SEEG', 'ECoG-Grid', 'ECoG-Strip'}
checkValidChannels = @(x) isnumeric(x);
p = inputParser;
p.KeepUnmatched = true;
if(matlabversion> 2014)
  addParameter(p, 'badChannels',[], checkValidChannels);
else
  addParamValue(p, 'badChannels',[], checkValidChannels);
end
parse(p, varargin{:});

selectedChannelsIndices = selectchannelsindices(montage, selectedChannels);
selectedChannelsIndices = setdiff(selectedChannelsIndices, p.Results.badChannels);

nChannels = size(montage.channels, 2);
[filterMatrix, channelGroups] = createspatialfilter(montage, nChannels, ...
  selectedChannelsIndices, 'filterName', referenceType, varargin{:});

refData = data * filterMatrix;