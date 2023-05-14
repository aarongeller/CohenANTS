function mych13fig(eegpower, times, frex)
min_freq = frex(1);
max_freq = frex(end);
figure
subplot(121)
contourf(times,frex,eegpower,40,'linecolor','none')
set(gca,'clim',[-3 3],'xlim',[-200 1000],'yscale','log','ytick',logspace(log10(min_freq),log10(max_freq),6),'yticklabel',round(logspace(log10(min_freq),log10(max_freq),6)*10)/10)
title('Logarithmic frequency scaling')
colorbar;

subplot(122)
contourf(times,frex,eegpower,40,'linecolor','none')
set(gca,'clim',[-3 3],'xlim',[-200 1000])
title('Linear frequency scaling')
colorbar;
