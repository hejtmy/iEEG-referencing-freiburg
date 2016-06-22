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
        channelGroups = perheadbox(Header, selectedChannelsIndices);
    case 'bipolar'
        channelGroups = bipolargrouping(Header, selectedChannelsIndices);
end
return

%% Common average reference: SEEG electrode shanks
if strcmp(groupSpecification, 'perElectrode')
    electrodesAllNames = [];
    for channel = 1:size(Header.channels,2)
        electrodesAllNames{channel} = extractFromString(Header.channels(channel).name, 'string');    % string part of all channel names
    end    
    electrodesSelectedNames = electrodesAllNames(selectedChannelsNumbers);        % string part of selected channels
    electrodesUniqueNames = unique(electrodesSelectedNames);                              % electrode shank names
    
    channelGroups = cell(1,size(electrodesUniqueNames,2));
    for electrodeIndex = 1:size(electrodesUniqueNames,2)
        electrodeName = electrodesUniqueNames{electrodeIndex};
        for channelIndex = 1:size(selectedChannelsIndices,2)
            if strcmp(extractFromString(Header.channels(channelIndex).name, 'string'), electrodeName)
                channelGroups{electrodeIndex} = cat(2, channelGroups{electrodeIndex}, channelIndex);
            end
        end
    end    
end