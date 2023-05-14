function cad = getcad_seeded(convmat, seedelec)

% convmat is complex valued output from wavelet convolution
% and has dimensions: channels x samples x trials x frequencies
numchannels = size(convmat,1);
numsamples =  size(convmat,2);
numtrials = size(convmat,3);
numfreqs = size(convmat,4);

anglemat = angle(convmat);
cad = zeros(size(anglemat)); % complex angle diff
m = zeros(numchannels, numsamples, numfreqs);

for i=1:numchannels
    % for every channel
    for j=1:numtrials
        % get complex valued angle difference for that trial
        % i.e., get (samples x freqs) matrix for seedelec-i phase
        % differences for that trial
        cad(i,:,j,:) = exp(1i*(anglemat(i,:,j,:) - anglemat(seedelec,:,j,:)));        
    end
end
