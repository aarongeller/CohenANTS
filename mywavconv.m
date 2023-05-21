function m = mywavconv(d, srate, freqs)
numfreqs = length(freqs);

% d assuemed to have dimensions: channels x samples x trials (like EEG.data)
numchannels = size(d, 1);
numsamples =  size(d, 2);
numtrials = size(d, 3);

% make matrix of Morlet wavelets
halfn = 1;
time = -halfn:1/srate:halfn;
wav_length = length(time); % 2*srate + 1
wavmat = zeros(numfreqs, wav_length);
% see ch 13 fig 14: increase wavenumber with increasing frequency
min_wavenum = 3; % for lowest freq
max_wavnum = 10; % for highest freq
wavenums = logspace(log10(min_wavenum), log10(max_wavnum), length(freqs));
for i=1:length(freqs)
    wavmat(i,:) = mywav(halfn, 0, wavenums(i), freqs(i));
end

total_data_samples = numsamples*numtrials;
conv_length = total_data_samples + wav_length - 1;
conv_samples_pow2 = pow2(nextpow2(conv_length));

% make matrix of fft of wavelets: freqs x channels x conv_samples_pow2
wavmat_fft_wide = fft(wavmat, conv_samples_pow2, 2);
freq_wavmat_fft_wide = zeros(numfreqs, numchannels, conv_samples_pow2);
for i=1:numfreqs
    freq_wavmat_fft_wide(i,:,:) = repmat(wavmat_fft_wide(i,:), numchannels, 1);
end

% make matrix of fft of data: channels x conv_samples_pow2
datamat = [];
for i=1:numtrials
    % concatenate trials horizontally
    datamat = [datamat d(:,:,i)];
end
datamat_fft = fft(datamat, conv_samples_pow2, 2);

% finish convolution: 
% for every freq, do ifft of pointwise product of data-fft (channels x
% conv_samples_pow2) and wavelet-fft (channels x conv_samples_pow2)
m = zeros(numchannels, numsamples, numtrials, numfreqs);
half_wav_length = floor(wav_length/2);
for i=1:numfreqs
    thiswavmat  = squeeze(freq_wavmat_fft_wide(i,:,:));
    if numchannels==1
        thiswavmat = thiswavmat.';
    end
    this_freq_conv = ifft(datamat_fft.*thiswavmat, [], 2);
    % trim the pow2 samples from the convolution
    this_freq_conv = this_freq_conv(:,1:conv_length);
    % trim the wavelet-samples from the convolution
    this_freq_conv_mat = this_freq_conv(:,half_wav_length+1:length(this_freq_conv)-half_wav_length);
    % restore trials with reshape
    m(:,:,:,i) = reshape(this_freq_conv_mat, numchannels, numsamples, numtrials);
end

% learning points 5/2023: 1) take average of power TFS, not of complex
% valued convolution output; 2) ok to concatenate trials but not
% channels; 3) regular transpose on complex vector is conjugate
% transpose, if you just want to take row to column you want .'
