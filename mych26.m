function mych26(seedelec, freqband, numfreqs, timewin)
if ~exist('freq', 'var')
    freqband = [4 8];
end

if ~exist('numfreqs', 'var')
    numfreqs = 5;
end

if ~exist('timewin', 'var')
    timewin = [300 350];
end

datafile = 'sampleEEGdata.mat';
load(datafile);

if ~exist('seedelec', 'var')
    % seedelec = 1;
    chan2use = 'P1';
    seedelec = find(strcmpi({EEG.chanlocs.labels}, chan2use));
end

freqs = linspace(freqband(1), freqband(end), numfreqs);
convmat = mywavconv(EEG.data, EEG.srate, freqs);

% do ISPC-trials:
ispcmat = myISPCtrials_seeded(convmat, seedelec);
ispcmat_freqmean = mean(ispcmat, 3);
timeinds = find(EEG.times>=timewin(1) & EEG.times<timewin(2));
ispcmat_timewin = mean(ispcmat_freqmean(:,timeinds), 2);
figure; topoplot(ispcmat_timewin, EEG.chanlocs, 'electrodes', 'off', ...
                 'plotrad', .53, 'maplimits', [0 1]);
colorbar;
title('ISPC-trials');

% do PLI:
plimat = myPLI_seeded(convmat, seedelec);
plimat_freqmean = mean(plimat, 3);
plimat_timewin = mean(plimat_freqmean(:,timeinds), 2);
figure; topoplot(plimat_timewin, EEG.chanlocs, 'electrodes', 'off', ...
                 'plotrad', .53, 'maplimits', [0 .2]);
colorbar;
title('PLI');

% do wPLI:
wplimat = myWPLI_seeded(convmat, seedelec);
wplimat_freqmean = mean(wplimat, 3);
wplimat_timewin = mean(wplimat_freqmean(:,timeinds), 2);
figure; topoplot(wplimat_timewin, EEG.chanlocs, 'electrodes', 'off', ...
                 'plotrad', .53, 'maplimits', [-.2 .2]);
colorbar;
title('wPLI');
