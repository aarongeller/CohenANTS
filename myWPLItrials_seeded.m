function m = myWPLItrials_seeded(convmat, seedelec)

complexanglediffmat = getcad_seeded(convmat, seedelec);

% eq 26.7
% m is channels x samples x freqs
m = squeeze(mean(abs(imag(complexanglediffmat)) .* sign(imag(complexanglediffmat)), 3) ...
            ./ mean(abs(imag(complexanglediffmat)), 3));
