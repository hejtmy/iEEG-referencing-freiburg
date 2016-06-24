#Referencing functions for iEEG data
These script are only useful with specific Header file format as adopted by University Freiburg and promoted in KISARG by Dr. Jiří Hammer.

Core of these functions are based on Dr. Hammers original functions. Credit should go to him.

## Example of use

```matlab
load('path to data file')
load ('path to header file')

Header = H; %renames for clarity

%% checking function - checks dimensions, header ordering etc. can be easilly modified
if ~checkheader(Header, d)
    warning('Freiburg:Header:failedCheck', 'Header file did not pass the check');
    return
end

% selecting indices of channels that we want
selectedChannelsIndices = selectchannelsindices(Header, {'SEEG'});
nChannels = size(Header.channels, 2); %original number of channels
% creating per Headbox averaging filter matrix
filterMatrix = createspatialfilter(Header, nChannels, selectedChannelsIndices, 'filterName', 'commonAverage', 'channelGrouping', 'perHeadbox');
filteredData = rawData * filterMatrix;  
```

### createspatialfilter 
- Header: header for the patient that passes checkheader function
- nChannels: original number of all channels present in the data and in the header. It's required for better indexing. Eg. last section
- selectedChannelsIndices: indices of channels that we want to use. They should be the same in the header and in the data file
- 'filterName': string that can be 'bipolar', 'commonAverage', 'noFilter'
- 'channelGrouping': applicable only in common average filter. can be 'perHeadbox' or 'perElectrode'

## Basic explanation
createspatial filter creates a matrix with values that are used to create "referenced" data by simple matrix multiplication of data and filterMatrix.

The only non simple element that needs to be checked and paid attention to is the continuation of channel indexing. For clarity I decided to use the original idenxing as is in the data and in the header, irrespective of what might be in the header under numberOnAmplifier. I keep the same indices throughout the entire operation, working with nChannels x nChannels matrix so that I don't have to reindex - if the selectedIndex is 6, the appropriate channel is always refered to as 6th, irrespective of everything else. 

The reindexing and shrinking of the matrix to fit dimensions of selected indices is done after the matrix is constructed et the end of createspatial.m function.

## Rules for submitting
Please have a look at (Better coding)[https://hejtmy.github.io/coding-versioning-best-practices/]

### Channel number vs channel index
Channel number - numberOnAmplifier as is presented in the header
Channel index - index of the channel in the Header as well as in the data - preffered for clarity.
