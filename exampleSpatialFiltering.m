% (c) Jiri, May16
% renamed functions and variables and cleaned flow so that it can be read by other people - Lukáš Hejtmánek, June, 2016

%% load example data (exported from Petr Jezdik)
load('/home/hammer/export/shareData/subjData_carDriving/16_PR1_day1/rawData/amplifierData/P96_2016-01-25_14-30_001.mat');
assert(exist('d','var') == 1);

%% load header 'Header'
fileName = 'path to file'; 
assert(exist(fileName,'file') == 2);
load(fileName);
Header = H;

if ~checkheader(Header, d)
    warning('Freiburg:Header:failedCheck', 'Header file did not pass the check');
    return
end

%% selected channels: signal type = iEEG
selectedChannelsIndices = selectchannelsindices(Header, {'SEEG', 'ECoG-Grid', 'ECoG-Strip'});
nChannels = size(Header.channels, 2);    %original number of channels

%% EXAMPLE: design spatial filter: CAR (per headbox)
filterMatrix = createspatialfilter(Header, nChannels, selectedChannelsIndices, 'filterName', 'commonAverage', 'channelGrouping', 'perHeadbox');
% apply spatial filter
filteredData = d * filterMatrix;  

%% EXAMPLE: design spatial filter: CAR (per electrode shank)
filterMatrix = createspatialfilter(Header, nChannels, selectedChannelsIndices, 'filterName', 'commonAverage', 'channelGrouping', 'perElectrode');
% apply spatial filter
filteredData = d * filterMatrix;  

%% EXAMPLE: design spatial filter: BIP (bipolar on electrode shanks)
filterMatrix = createspatialfilter(Header, nChannels, selectedChannelsIndices, 'filterName', 'bipolar');
% apply spatial filter
filteredData = d * filterMatrix;  