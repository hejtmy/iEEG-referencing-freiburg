function channelGroups = getChannelGroups_kisarg(Header, selectedChannelsIndices, groupSpecification)
% returns channel groups (cell array) based on group specification

% (c) Jiri, Apr16
% renamed functions and variables and cleaned flow so that it can be read by other people - Lukáš Hejtmánek, June, 2016

%% VALIDATION

%validate Header - others should already be validated above

%%
% selected channels (for example signal type = iEEG)

% select channels from the header based on the channel number
% convert from number to index
selectedChannelsIndices = 1:size(selectedChannelsNumbers, 2);      % corresponds to indices in rawData - raw data was already shrunk, doesnt correspond to indices in whole raw data

%% Common average reference: headboxes of amplifier with different REFs & GNDs
if strcmp(groupSpecification, 'perHeadbox')
        headboxAllNumbers = [];
        for channelIndex = 1:size(Header.channels,2)
            headboxAllNumbers = cat(2, headboxAllNumbers, Header.channels(channelIndex).headboxNumber);        % headbox numbers from all channels
        end
        headboxSelectedNumbers = headboxAllNumbers(selectedChannelsNumbers);                      % headbox numbers from selected channels (e.g. iEEG channels)
        assert(size(selectedChannelsIndices,2) == size(headboxSelectedNumbers,2));         % check that each part has a headbox number

        headboxUniqueNumbers = unique(headboxSelectedNumbers);                                          % headbox numers
        channelGroups = cell(1,size(headboxUniqueNumbers,2));
        for headboxIndex = 1:size(headboxUniqueNumbers,2)
            thisHeadboxNumber = headboxUniqueNumbers(headboxIndex);
            for channelIndex = 1:size(selectedChannelsIndices,2)    %TODO!!! Shouldn't this ba selectedNumber?
                if headboxSelectedNumbers(channelIndex) == thisHeadboxNumber
                    channelGroups{headbox} = cat(2, channelGroups{headbox}, channelIndex);
                end
            end
        end
end

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


%% BIP: channel groups = neighboring SEEG channels on same electrode shank
if strcmp(groupSpecification, 'bip')   
    channelGroups = [];
    position = 1;
    for channel = 2:size(Header.channels,2) % TODO! Differently!!! FOR FUCK SAKE
        prevCh_shank = extractFromString(Header.channels(channel-1).name, 'string');
        currCh_shank = extractFromString(Header.channels(channel).name, 'string');        
        if strcmp(prevCh_shank, currCh_shank) && strcmp(Header.channels(channel-1).signalType, 'SEEG') && strcmp(Header.channels(channel).signalType, 'SEEG')
            channelGroups{position} = [channel-1, channel];
            position = position+1;
        end
    end   
end
