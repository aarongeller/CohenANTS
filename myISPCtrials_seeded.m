function m = myISPCtrials_seeded(convmat, seedelec)

complexanglediffmat = getcad_seeded(convmat, seedelec);

% get magnitude of mean complex vector over trials
% m is channels x samples x freqs
m = abs(squeeze(mean(complexanglediffmat, 3)));
