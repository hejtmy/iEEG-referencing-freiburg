% (c) Jiri, May16
% renamed functions and variables and cleaned flow so that it can be read by other people - Luk� Hejtm�nek, June, 2016

%% load example data (exported from Petr Jezdik)
load('/home/hammer/export/shareData/subjData_carDriving/16_PR1_day1/rawData/amplifierData/P96_2016-01-25_14-30_001.mat');
assert(exist('d','var') == 1);

%% load header 'Header'
fileName = 'path to file'; 
assert(exist(fileName,'file') == 2);
load(fileName);
Header = H;
clear H;
assert(size(d,2) == size(Header.channels,2));

%% selected channels: signal type = iEEG
selectedChannelsIndices = selectchannelsindices(Header, {'SEEG', 'ECoG-Grid', 'ECoG-Strip'});
rawData = d(:,selectedChannelsIndices); % bad idea

%% EXAMPLE: design spatial filter: CAR (per headbox)
filterMatrix = createSpatialFilter_kisarg(Header, size(selectedChannelsIndices,2), selectedChannelsIndices, 'filterName', 'commonAverage', 'channelGrouping', 'perHeadbox');
assert(size(rawData,2) == size(filterMatrix,1));
% apply spatial filter
filteredData = rawData * filterMatrix;  
assert(size(filteredData,1) == size(rawData,1));

%% EXAMPLE: design spatial filter: CAR (per electrode shank)
filterMatrix = createSpatialFilter_kisarg(Header, size(selectedChannelsIndices,2), selectedChannelsIndices, 'filterName', 'commonAverage', 'channelGrouping', 'perElectrode');
assert(size(rawData,2) == size(filterMatrix,1));

% apply spatial filter
filteredData = rawData * filterMatrix;  
assert(size(filteredData,1) == size(rawData,1));

%% EXAMPLE: design spatial filter: BIP (bipolar on electrode shanks)
filterMatrix = createSpatialFilter_kisarg(Header, size(selectedChannelsIndices,2), selectedChannelsIndices, 'filterName', 'bipolar');
assert(size(rawData,2) == size(filterMatrix,1));
% apply spatial filter
filteredData = rawData * filterMatrix;  
assert(size(filteredData,1) == size(rawData,1));