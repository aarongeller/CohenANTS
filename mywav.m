function [v,x] = mywav(halfn, mu, wavenum, freq, srate)

if ~exist('wavenum', 'var')
    wavenum = 5; 
end

if ~exist('freq', 'var')
    freq = 30; 
end

if ~exist('srate', 'var')
    srate = 256;
end

[g, x] = mygauss(halfn, mu, wavenum, freq, srate);

compex = exp(i*2*pi*freq*x);
v = sqrt(1/(wavenum*sqrt(pi)))*compex.*g;

