function [gpfromseed, gptoseed] = mygranger_seeded(d, seedelec_ind, srate)

numchannels = size(d,1);
numsamples =  size(d,2);
numtrials = size(d,3);

% Granger prediction parameters
timewin = 200; % in ms
order   =  27; % in ms

% convert parameters to indices
timewin_points = round(timewin/(1000/srate));
order_points   = round(order/(1000/srate));

d_flat = reshape(d, numchannels, numsamples*numtrials);
d_flat = zscore(d_flat, 0, 2);

[Ax,Ex] = armorf(d_flat(seedelec_ind,:), numtrials, timewin_points, order_points);

gpfromseed = zeros(numchannels,1);
gptoseed = zeros(numchannels,1);

for i=1:numchannels
    if i==seedelec_ind
        m(i) = 0;
    else
        % fit AR models (model estimation from bsmart toolbox)
        [Ay,Ey] = armorf(d_flat(i,:), numtrials, timewin_points, order_points);
        [Axy,E] = armorf([d_flat(seedelec_ind,:); d_flat(i,:)], numtrials, timewin_points, order_points);
    
        % time-domain causal estimate
        gptoseed(i)=log(Ex/E(1,1));
        gpfromseed(i)=log(Ey/E(2,2));
    end
end
