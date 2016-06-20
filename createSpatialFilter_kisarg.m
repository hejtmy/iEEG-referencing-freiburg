%bad design in the filter settings accepting struct as an input variable - as this function depends on the struct naming
%conventions elsewhere - need to redo it to optional parameters
function filterMatrix = createSpatialFilter_kisarg(Header, nInputChannels, varargin)
% creates a spatial filter for (intracranial) EEG data
% input vars:
%   Header: header structure
%   nInputChannels: number of input channels
%   filterSettings = struct with fields: 
%        name: 'car'
%       channelGroups: 'perElectrode' OR 'perHeadbox'
% output var:
%   filterMatrix: nInputChannels x nInputChannels
% example: 
%   S_car = createSpatialFilter(Header, 110, filterSettings);
% usage:
%   X_car = X_ref * S_car;   where:
%       X_ref = [samples x nInputChannels] data matrix
%       X_car = [samples x nInputChannels] data matrix
%       S_car = [nInputChannels x nInputChannels] spatial filter (CAR) matrix

% (c) Jiri, May16
% renamed functions and variables and cleaned flow so that it can be read by other people - Luk� Hejtm�nek, June, 2016

%VALIDATING HEADER AND nInputChannels

%% INPUT PARSING
p = inputParser;
%validating functions
checkEvent = @(x) isfield(obj.experiment_data.events, x) && ischar(x);
validFilter = {'bipolar', 'commonAverage', 'noFilter'};
checkValidFilter = @(x) any(validatestring(x, validFilter));
validGrouping = {'perHeadbox', 'perElectrode', 'bipolar'};
checkValidGrouping = @(x) any(validatestring(x, validGrouping));

version = matlabversion;
if(version.year > 2015)
    addParameter(p,'filterName', 'noFilter', checkValidFilter);
    addParameter(p, 'channelGrouping','', checkValidGrouping);
else
    addParamValue(p,'filterName',[-500 1000], checkTimeRange);
    addParameter(p, 'channelGrouping','', checkValidGrouping);
end
parse(p, varargin{:});

%% The real flow
switch p.Results.filterName
    case 'bipolar'
        filterMatrix = bipolarreference(Header, nInputChannels);
    case 'commonAverage'
        filterMatrix = commonaveragereference(Header, nInputChannels, p.Resulkts.channelGrouping);
    case 'noFilter'
        filterMatrix =  eye(nInputChannels);
end

