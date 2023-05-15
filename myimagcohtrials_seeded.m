function m = myimagcohtrials_seeded(convmat, seedelec)

% convmat is complex valued output from wavelet convolution
% and has dimensions: channels x samples x trials x frequencies
numchannels = size(convmat,1);
numsamples =  size(convmat,2);
numtrials = size(convmat,3);
numfreqs = size(convmat,4);

% imag_cross_powermat = zeros(size(convmat));
m = zeros(numchannels, numsamples, numfreqs);
for i=1:numchannels
    % p. 345 and Nolte paper
    e1e2_powermat = imag(convmat(i,:,:,:).*conj(convmat(seedelec,:,:,:)));
    e1e1_powermat = convmat(seedelec,:,:,:).*conj(convmat(seedelec,:,:,:));
    e2e2_powermat = convmat(i,:,:,:).*conj(convmat(i,:,:,:));
    S_ij = squeeze(mean(e1e2_powermat, 3));
    S_ii = squeeze(mean(e1e1_powermat, 3));
    S_jj = squeeze(mean(e2e2_powermat, 3));
    m(i,:,:) = abs( S_ij ./ (sqrt(S_ii.*S_jj)) );
end

