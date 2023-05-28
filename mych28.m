function mych28(seedelec)

if ~exist('seedelec', 'var')
    seedelec = 'poz';
end

load sampleEEGdata;
chanind = find(strcmpi(seedelec, {EEG.chanlocs.labels}));

chan_erp = squeeze(mean(EEG.data(chanind, :, :), 3));
% figure; plot(EEG.times, chan_erp);

% based on ERP
timewin = [800 1400];
timeinds = find(EEG.times>=timewin(1) & EEG.times<timewin(2));

[gpfrom, gpto] = mygranger_seeded(EEG.data(:,timeinds,:), chanind, EEG.srate);

% figure; plot(m);
figure; topoplot(gpfrom, EEG.chanlocs, 'electrodes', 'off', ...
                 'plotrad', .53, 'maplimits', [0 .05]); colorbar;
title('GP from seed');

figure; topoplot(gpto, EEG.chanlocs, 'electrodes', 'off', ...
                 'plotrad', .53, 'maplimits', [0 .05]); colorbar;
title('GP to seed');
