function [v,x] = mygauss(halfn, mu, wavenum, freq, srate)

if ~exist('wavenum', 'var')
    wavenum = 5; 
end

if ~exist('freq', 'var')
    freq = 30; 
end

if ~exist('srate', 'var')
    srate = 256;
end

sigma = wavenum/(2*pi*freq); % eq 12.2
x = mu-halfn:1/srate:mu+halfn;
v = exp(-0.5*((x-mu)./sigma).^2);
% in chapter 11 he divides v by freq (e.g. line 368)

