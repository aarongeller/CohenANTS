function m = myISPCtrials_seeded(convmat, seedelec)

complexanglediffmat = getcad_seeded(convmat, seedelec);

% get magnitude of mean complex vector over trials
m = abs(squeeze(mean(complexanglediffmat, 3)));
