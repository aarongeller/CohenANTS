function eegpower = mych13part(trials, doplot)

%% Analyzing Neural Time Series Data
% Matlab code for Chapter 13
% Mike X Cohen
% 
% This code accompanies the book, titled "Analyzing Neural Time Series Data" 
% (MIT Press). Using the code without following the book may lead to confusion, 
% incorrect data analyses, and misinterpretations of results. 
% Mike X Cohen assumes no responsibility for inappropriate or incorrect use of this code. 

%% Figure 13.6

load sampleEEGdata % note you don't need the ".mat" (unless the filename contains a period in it)

if ~exist('trials', 'var')
    trials = 1:size(EEG.data,3);
end

if ~exist('doplot', 'var')
    doplot = 1;
end

%% figure 13.11

% definitions, selections...
chan2use = 'fcz';
chan2use_ind = find(strcmpi({EEG.chanlocs.labels}, chan2use));

min_freq =  2;
max_freq = 80;
num_frex = 30;

% define wavelet parameters
frex = logspace(log10(min_freq),log10(max_freq),num_frex);

tempconv = mywavconv(EEG.data(chan2use_ind, :, trials), EEG.srate, frex);
tempconv2 = mywavconv_bak(EEG.data(chan2use_ind, :, trials), EEG.srate, frex);
% tempconv_trialavg = squeeze(mean(tempconv, 3));
% temppower = abs(tempconv_trialavg).^2;
% eegpower = temppower';
temppower = abs(tempconv).^2;
% ***LEARNING POINT***: you need to take the mean AFTER computing power 
temppower_trialavg = squeeze(mean(temppower,3));
eegpower = temppower_trialavg';

baseidx = dsearchn(EEG.times',[-500 -200]');

if doplot
    mych13fig(dodbnorm(eegpower, baseidx), EEG.times, frex);
end
