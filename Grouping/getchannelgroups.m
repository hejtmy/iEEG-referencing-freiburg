function channelGroups = getchannelgroups(Header, selectedChannelsIndices, groupSpecification)
% returns channel groups (cell array) based on group specification

% (c) Jiri, Apr16
% renamed functions and variables and cleaned flow so that it can be read by other people - Lukáš Hejtmánek, June, 2016

%% VALIDATION

%validate Header - others should already be validated above

%%
% selected channels (for example signal type = iEEG)

% select channels from the header based on the channel number
% convert from number to index
%selectedChannelsIndices = 1:size(selectedChannelsNumbers, 2);      % corresponds to indices in rawData - raw data was already shrunk, doesnt correspond to indices in whole raw data

switch groupSpecification
    case 'perHeadbox'
        channelGroups = perheadboxgrouping(Header, selectedChannelsIndices);
    case 'bipolar'
        channelGroups = bipolargrouping(Header, selectedChannelsIndices);
    case 'perElectrode'
        channelGroups = perelectrodegrouping(Header, selectedChannelsIndices);
end
return