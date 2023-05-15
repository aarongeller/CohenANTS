function m = myPLItrials_seeded(convmat, seedelec)

complexanglediffmat = getcad_seeded(convmat, seedelec);

% eq 26.6
% m is channels x samples x freqs
m = abs(squeeze(mean(sign(imag(complexanglediffmat)), 3)));
