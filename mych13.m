function mych13(trialnum)
if ~exist('trialnum', 'var')
    trialnum = 98;
end

datafile = 'sampleEEGdata.mat';
load(datafile);

numchannels = size(EEG.data, 1);
numsamples =  size(EEG.data, 2);

minfreq = 2;
maxfreq = 30;
numsteps = 5;

myfreqs = linspace(minfreq, maxfreq, numsteps);

convmat = mywavconv(EEG.data(:,:,trialnum), EEG.srate, myfreqs);
powmat = abs(convmat).^2;
phasemat = angle(convmat);

allchannels_pow = zeros(numchannels, length(myfreqs), numsamples);
allchannels_phase = zeros(numchannels, length(myfreqs), numsamples);

for i=1:numsteps
    allchannels_pow(:,i,:) = squeeze(powmat(:,:,:,i));
    allchannels_phase(:,i,:) = squeeze(phasemat(:,:,:,i));
end    

ind180 = get_nearest_ind(EEG.times, 180);
pow180 = squeeze(allchannels_pow(:,:,ind180));
phase180 = squeeze(allchannels_phase(:,:,ind180));

dotopoplots(EEG, myfreqs, pow180, phase180, 180);

ind360 = get_nearest_ind(EEG.times, 360);
pow360 = squeeze(allchannels_pow(:,:,ind360));
phase360 = squeeze(allchannels_phase(:,:,ind360));

dotopoplots(EEG, myfreqs, pow360, phase360, 360);

function n = get_nearest_ind(v, num)
lowerinds = find(v<num);
n = max(lowerinds);
if num - n > v(n + 1) - num
    n = n + 1;
end

function dotopoplots(EEG, freqs, powmat, phasemat, tval)
figure;
for i=1:10
    subplot(5,2,i);
    if mod(i,2)
        freqind = floor(i/2)+1; 
        topoplot(powmat(:, freqind), EEG.chanlocs, 'electrodes', 'off', 'plotrad', .53);
        title([num2str(freqs(freqind)) ' Hz Power, ' int2str(tval) ...
               ' ms']);
    else
        freqind = i/2; 
        topoplot(phasemat(:, freqind), EEG.chanlocs, 'electrodes', 'off', 'plotrad', .53);
        title([num2str(freqs(freqind)) ' Hz Phase, ' int2str(tval) ...
               ' ms']);
    end
end
