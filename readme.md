#Referencing functions for iEEG data
These script are only useful with specific Header file format as adopted by University Freiburg and promoted in KISARG by Dr. Jiří Hammer.

Core of these functions are based on Dr. Hammers original functions. Credit should go to him.

## Rules for submitting
- Never commit to master!
- All coding should be done in feature branches and pulled to develop.
- When issues are resolved, develop will be pulled to master and released.
- Bugfix commits should be presented as such.
- Small commits of single files are preferable.
- No "broken" code should be pulled into develop - all issues with file dependencies should be fixed in features before pull request.

### Rules for coding
- things should be named clearly, uniquely
```
~~ch~~ channel
~~selCh_i~~ selectedChannelsIndices
```
- variables should be defined in small focus
- functions should validate input where error can be expected
- function should not depend on specific input of other functions if possible - this can lead to confusion in complex functions as matlab doesn't well implement namespaces and classes
```matlab
settings = struct()
settings.channels = 64
settings.outcome = 'matrix'
selectmatrix(data, settings) % bad style - doesn't raise erors and warning and needs high control on the selectmatrix function side. Also, can lead to settings definitions far away from the function which reduces reading flow
selectmatrix(data, 'channels', 64, 'outcome', 'matrix') % better - clear what it does, can be easilly controlled in the function
```
- naming should be preserved throughout functions if possible (if one function accepts "header" as parameter, the passing script should also pass in header variable)
- functions should be short (under 60 lines) and do a single thing

### Naming conventions
- functions in matlab are for some reason written as smallcase only, but let's keep it that way
```matlab
~~getMeSandwich('tuna with egg')~~ %c# style
~~get_me_sandwich('tuna with egg')~~ %php style
getmesandwich('tuna with egg') %matlab style
```
- variables can vary uppercase and lowercase letters. Global should start with uppercase, local with lowercase
```matlab
~~channel_number~~ % r style, php style - not a good style
~~channelnumber~~ % this means function
channelNumber
```
- variables should respect if they are an array of a single value and use plural or singular
- variables starting with n or i mean number of or index of only
```matlab
~~nChannel = 8~~ % if this is number of channels, it should be in plural
~~channelIndex = [5:6]~~ % shoudl be in plural channelIndices
iChannel = 5
iChannels = [4 5]
channelIndex = 7
nChannels = 64
```
### Channel number vs channel index
Channel number - numberOnAmplifier as is presented in the header
Channel index - index of the channel in the Header as well as in the data - preffered for clarity.
