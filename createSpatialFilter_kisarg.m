%bad design in the filter settings accepting struct as an input variable - as this function depends on the struct naming
%conventions elsewhere - need to redo it to optional parameters
function filterMatrix = createSpatialFilter_kisarg(Header, nInputChannels, filterSettings)
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
% renamed functions and variables and cleaned flow so that it can be read by other people - Lukáš Hejtmánek, June, 2016

%  init
filterFound = false;
           
%% CAR: common average reference
if strfind(filterSettings.name, 'car')        % ~ common average re-reference (CAR)
    filterFound = true;
    
    % define channel groups
    channelGroups = getChannelGroups_kisarg(Header, filterSettings.channelGroups);
    
    % design filter
    filterMatrix = zeros(nInputChannels);                        % init
    for channelGroup = 1:size(channelGroups,2)
        selectedChannels = channelGroups{channelGroup};
        nChannels = size(selectedChannels,2);
        filterMatrix(selectedChannels,selectedChannels) = eye(nChannels) - 1/nChannels.*ones(nChannels);    % set weights for CAR channels
    end    
end

%% BIP: bipolar reference
if strcmp(filterSettings.name, 'bip')
    filterFound = true;
    
    % define channel groups
    channelGroups = getChannelGroups_kisarg(Header, 'bip');
    
    % design filter
    filterMatrix = zeros(nInputChannels, size(channelGroups,2));      % init
    selCh_H = [];
    for channelGroup = 1:size(channelGroups,2)
        selectedChannels = channelGroups{channelGroup};
        filterMatrix(selectedChannels(1),channelGroup) = 1;                     % set weights for BIP channels
        if size(selectedChannels,2) == 2
            filterMatrix(selectedChannels(2),channelGroup) = -1;                % set weights for BIP channels
        else
            warning(['BIP: only 1 channel on electrode shank, no referencing. Channel = ' num2str(channelGroup)]);
        end
        selCh_H = cat(2, selCh_H, selectedChannels(1));
    end  
end

%% NAN: no spatial filter
if strcmp(filterSettings.name, 'nan')
    filterFound = true;
    filterMatrix = eye(nInputChannels);
end

assert(filterFound);
