% plot_FWGN.m

%MIMO-OFDM Wireless Communications with MATLAB¢ç   Yong Soo Cho, Jaekwon Kim, Won Young Yang and Chung G. Kang
%2010 John Wiley & Sons (Asia) Pte Ltd

clear, clf
fm=100;   % Maximum Doppler frquency
ts_mu=50; scale=1e-6; ts=ts_mu*scale; % Sampling time
fs=1/ts;  % Sampling frequency
Nd=1e6;   % Number of samples
% To get the complex fading channel
[h,Nfft,Nifft,doppler_coeff] = FWGN_model(fm,fs,Nd);
subplot(211), plot([1:Nd]*ts,10*log10(abs(h))), axis([0 0.5 -30 5])
str = sprintf('channel modeled by Clarke/Gan with f_m=%d[Hz], T_s=%d[mus]',fm,ts_mu);
title(str), xlabel('time[s]'), ylabel('Magnitude[dB]')
subplot(223), hist(abs(h),50), xlabel('Magnitude'), ylabel('Occasions')
subplot(224), hist(angle(h),50), xlabel('Phase[rad]'), ylabel('Occasions')