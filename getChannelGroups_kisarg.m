function channelGroups = getChannelGroups_kisarg(Header, groupSpecification)
% returns channel groups (cell array) based on group specification

% (c) Jiri, Apr16
% renamed functions and variables and cleaned flow so that it can be read by other people - Lukáš Hejtmánek, June, 2016

channelGroups = [];

%% selected channels (for example signal type = iEEG)
assert(isfield(Header,'selectedChannelsNumbers'));
selectedChannelsNumbers = Header.selectedChannelsNumbers;
selectedChannelsIndexes = 1:size(selectedChannelsNumbers,2);      % corresponds to indices in rawData

%% CAR: channel groups = headboxes of amplifier with different REFs & GNDs
if strcmp(groupSpecification, 'perHeadbox')
    if isfield(Header.channels(1), 'headboxNumber')      % re-referencing per headbox
        headboxAll = [];
        for ch = 1:size(Header.channels,2)
            headboxAll = cat(2, headboxAll, Header.channels(ch).headboxNumber);        % headbox numbers from all channels
        end
        headboxSelected = headboxAll(selectedChannelsNumbers);                      % headbox numbers from selected channels (e.g. iEEG channels)
        assert(size(selectedChannelsIndexes,2) == size(headboxSelected,2));         % check that each part has a headbox number

        headboxUnique = unique(headboxSelected);                                          % headbox numers
        channelGroups = cell(1,size(headboxUnique,2));
        for headbox = 1:size(headboxUnique,2)
            thisHeadbox = headboxUnique(headbox);
            for channel = 1:size(selectedChannelsIndexes,2)
                if headboxSelected(channel) == thisHeadbox
                    channelGroups{headbox} = cat(2, channelGroups{headbox}, channel);
                end
            end
        end
    else                                            % only 1 headbox in recording
        channelGroups{1,1} = selectedChannelsIndexes;
    end
    
end

%% CAR: channel groups = SEEG electrode shanks
if strcmp(groupSpecification, 'perElectrode')
    electrodesAll = [];
    for channel = 1:size(Header.channels,2)
        electrodesAll{channel} = extractFromString(Header.channels(channel).name, 'string');    % string part of all channel names
    end    
    electrodesSelected = electrodesAll(selectedChannelsNumbers);        % string part of selected channels
    electrodesUnique = unique(electrodesSelected);                              % electrode shank names
    
    channelGroups = cell(1,size(electrodesUnique,2));
    for electrode = 1:size(electrodesUnique,2)
        electrodeName = electrodesUnique{electrode};
        for channel = 1:size(selectedChannelsIndexes,2)
            if strcmp(extractFromString(Header.channels(channel).name, 'string'), electrodeName)
                channelGroups{electrode} = cat(2, channelGroups{electrode}, channel);
            end
        end
    end    
end


%% BIP: channel groups = neighboring SEEG channels on same electrode shank
if strcmp(groupSpecification, 'bip')   
    channelGroups = [];
    position = 1;
    for channel = 2:size(Header.channels,2)
        prevCh_shank = extractFromString(Header.channels(channel-1).name, 'string');
        currCh_shank = extractFromString(Header.channels(channel).name, 'string');        
        if strcmp(prevCh_shank, currCh_shank) && strcmp(Header.channels(channel-1).signalType, 'SEEG') && strcmp(Header.channels(channel).signalType, 'SEEG')
            channelGroups{position} = [channel-1, channel];
            position = position+1;
        end
    end   
end
