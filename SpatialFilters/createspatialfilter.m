function [filterMatrix, channelGroups] = createspatialfilter(Header, nInputChannels, selectedChannelsIndices, varargin)
% creates a spatial filter for (intracranial) EEG data
% input vars:
%   Header: header structure
%   nInputChannels: number of input channels
%   selectedChannelsIndices: not indices of selected channels
%   varargin:
%           'filterName': 'bipolar', 'commonaverage', 'noFilter'
%           'channelGrouping': 'perElectrode', 'perHeadbox'
% output var:
%   filterMatrix: nInputChannels x nInputChannels
% example: 
%   S_car = createSpatialFilter(Header, 110, filterSettings);
%   X_car = X_ref * S_car;   where:
%       X_ref = [samples x nInputChannels] data matrix
%       X_car = [samples x nInputChannels] data matrix
%       S_car = [nInputChannels x nInputChannels] spatial filter (CAR) matrix

% (c) Jiri, May16
% renamed functions and variables and cleaned flow so that it can be read by other people - Lukáš Hejtmánek, June, 2016

%VALIDATING HEADER AND nInputChannels

%% INPUT PARSING
p = inputParser;
%validating functions

validFilter = {'bipolar', 'commonAverage', 'noFilter'};
checkValidFilter = @(x) any(validatestring(x, validFilter));

validGrouping = {'perHeadbox', 'perElectrode'};
checkValidGrouping = @(x) any(validatestring(x, validGrouping));

checkChannels = @(x) isnumeric(x);

addRequired(p,'selectedChannelsIndices',checkChannels);
if(matlabversion> 2014)
    addParameter(p,'filterName', 'noFilter', checkValidFilter);
    addParameter(p, 'channelGrouping','', checkValidGrouping);
else
    addParamValue(p,'filterName', 'noFilter', checkValidFilter);
    addParamValue(p, 'channelGrouping','', checkValidGrouping);
end
parse(p, selectedChannelsIndices, varargin{:});

%% The real flow
switch p.Results.filterName
    case 'bipolar'
        [filterMatrix, channelGroups] = bipolarreference(Header, nInputChannels, selectedChannelsIndices);
    case 'commonAverage'
        [filterMatrix, channelGroups] = commonaveragereference(Header, nInputChannels, selectedChannelsIndices, p.Results.channelGrouping);
    case 'noFilter'
        filterMatrix =  eye(nInputChannels);
end

%removes any empty columns -> when we multiply by raw data, we already
%discard not needed columns and values (we don't need to substract and
%reindex)
filterMatrix = filterMatrix(:,any(filterMatrix));