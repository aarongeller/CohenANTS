function mych18(trialnum, channum)
if ~exist('trialnum', 'var')
    trialnum = 98;
end

datafile = 'sampleEEGdata.mat';
load(datafile);

% numchannels = size(EEG.data, 1);
% numsamples =  size(EEG.data, 2);
% numtrials = size(EEG.data, 3);

trialnchannels = EEG.data(:,:,trialnum);
numchannels = size(trialnchannels,1);
numsamples =  size(trialnchannels,2);


% Part 1: wavelet convolution for 3 freq bands, without and with
% baseline correction
rangemat = [4 8;
            8 12;
            13 30];
num_bands = size(rangemat,1);
freqs_per_band = 5;

freqstodo = [];
for i=1:size(rangemat,1)
    thisfreqstodo = linspace(rangemat(i,1), rangemat(i,2), freqs_per_band);
    freqstodo = [freqstodo thisfreqstodo];
end

convmat = mywavconv(EEG.data(:, :, trialnum), EEG.srate, freqstodo);
powmat = abs(convmat).^2;

allchannels_pow = zeros(numchannels, length(freqstodo), numsamples);
for i=1:length(freqstodo)
    allchannels_pow(:,i,:) = squeeze(powmat(:,:,:,i));
end

within_band_mean_pow = zeros(numchannels, num_bands, numsamples);
for i=1:numchannels
    for j=1:num_bands
        within_band_mean_pow(i,j,:) = squeeze(mean(allchannels_pow(i,(j-1)*freqs_per_band+1:j*freqs_per_band,:)));   
    end
end

% baseline correction:
baseline_time = 0.2; % 200 ms
baseline_samples = 1:round(baseline_time*EEG.srate);
% allchannels_pow_baselined = zeros(size(allchannels_pow));
allchannels_pow_baselined = zeros(size(within_band_mean_pow));

for i=1:size(allchannels_pow,1)
    rawtfs = squeeze(within_band_mean_pow(i,:,:));
    baselined_tfs = zeros(size(rawtfs));
    for j=1:size(rawtfs,1)
        rawvec = rawtfs(j,:);
        % z transform
        baselined_tfs(j,:) = (rawvec - mean(rawvec(baseline_samples)))/std(rawvec(baseline_samples));    
    end
    allchannels_pow_baselined(i,:,:) = baselined_tfs;
end

% part 2: topomaps for 5 time points
chosen_samples = round(linspace(1, numsamples, 5));
for i=1:num_bands
    if i==1
        freqstr = 'theta';
        maplim = 75;
    elseif i==2
        freqstr = 'alpha';
        maplim = 50;
    else
        freqstr = 'beta';
        maplim = 30;
    end        
    figure;
    for j=1:2
        if j==1 % do raw plot
            condstr = 'raw';
            for k=1:length(chosen_samples)
                subplot(2, length(chosen_samples), (j-1)*length(chosen_samples)+k);
                timestr = num2str(chosen_samples(k)/EEG.srate);
                topoplot(within_band_mean_pow(:,i,chosen_samples(k)), EEG.chanlocs, 'electrodes', 'off', ...
                 'plotrad', .53); % 'maplimits', [0 100]);
                title([freqstr ' ' condstr ' ' timestr 's']);
            end
        else % do baselined plot
            condstr = 'baselined';
            for k=1:length(chosen_samples)
                subplot(2, length(chosen_samples), (j-1)*length(chosen_samples)+k);
                timestr = num2str(chosen_samples(k)/EEG.srate);
                topoplot(allchannels_pow_baselined(:,i,chosen_samples(k)), EEG.chanlocs, 'electrodes', 'off', ...
                         'plotrad', .53, 'maplimits', [-maplim maplim]);
                title([freqstr ' ' condstr ' ' timestr 's']);
            end
        end
    end
end
