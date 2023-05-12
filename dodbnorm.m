function eegpower = dodbnorm(eegpower, baseidx)

num_frex = size(eegpower,1);

for i=1:num_frex
    eegpower(i,:) = 10*log10(eegpower(i,:)./mean(eegpower(i,baseidx(1):baseidx(2))));
end
